// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "./StakeHubCommon.sol";

contract StakeHubGoldStaking is StakeHubCommon {
    using EnumerableSet for EnumerableSet.AddressSet;

    function delegateTokenB1155(
        address operatorAddress,
        uint256 tokenId,
        uint256 tokenBAmount
    ) external onlyStakeHubDelegateCall whenNotPaused notInBlackList validatorExist(operatorAddress) {
        if (stakeTokenB == address(0) || tokenBAmount == 0 || !_isSupportedTokenBId(tokenId)) {
            revert InvalidRequest();
        }

        if (_legacyDelegatedTokenBAmount(operatorAddress, msg.sender) != 0) revert InvalidRequest();
        _settleTokenBReward(operatorAddress, msg.sender);
        IERC1155(stakeTokenB).safeTransferFrom(msg.sender, address(this), tokenId, tokenBAmount, "");
        if (_delegatedTokenB[operatorAddress][msg.sender] == 0) {
            _tokenBDelegators[operatorAddress].add(msg.sender);
        }
        _delegatedTokenB[operatorAddress][msg.sender] += tokenBAmount;
        _delegatedTokenBById[operatorAddress][msg.sender][tokenId] += tokenBAmount;
        totalDelegatedTokenB[operatorAddress] += tokenBAmount;
        totalDelegatedTokenBById[operatorAddress][tokenId] += tokenBAmount;
        _tokenBDelegationVersion[operatorAddress][msg.sender] = tokenBCutoverVersion;
        _syncTokenBRewardDebt(operatorAddress, msg.sender);

        emit TokenBDelegated(operatorAddress, msg.sender, tokenBAmount);
        emit TokenB1155Delegated(operatorAddress, msg.sender, tokenId, tokenBAmount);
    }

    function undelegateTokenB1155(
        address operatorAddress,
        uint256 tokenId,
        uint256 tokenBAmount
    ) external onlyStakeHubDelegateCall whenNotPaused notInBlackList validatorExist(operatorAddress) {
        uint256 unbondVersion = _tokenBDelegationVersion[operatorAddress][msg.sender];
        uint256 delegatedAmountById = _delegatedTokenBById[operatorAddress][msg.sender][tokenId];
        if (tokenBAmount == 0 || tokenBAmount > delegatedAmountById) revert InvalidRequest();

        _settleTokenBReward(operatorAddress, msg.sender);
        _delegatedTokenBById[operatorAddress][msg.sender][tokenId] = delegatedAmountById - tokenBAmount;

        uint256 remainingAmount = _delegatedTokenB[operatorAddress][msg.sender] - tokenBAmount;
        _delegatedTokenB[operatorAddress][msg.sender] = remainingAmount;
        totalDelegatedTokenB[operatorAddress] -= tokenBAmount;
        totalDelegatedTokenBById[operatorAddress][tokenId] -= tokenBAmount;
        if (tokenBCutoverVersion != 0 && unbondVersion < tokenBCutoverVersion) {
            totalLegacyDelegatedTokenB[operatorAddress] -= tokenBAmount;
        }
        _syncTokenBRewardDebt(operatorAddress, msg.sender);
        _queueTokenB1155Unbond(operatorAddress, msg.sender, tokenId, tokenBAmount, unbondVersion);
        if (remainingAmount == 0) {
            _tokenBDelegators[operatorAddress].remove(msg.sender);
        }

        emit TokenBUndelegated(operatorAddress, msg.sender, tokenBAmount);
        emit TokenB1155Undelegated(operatorAddress, msg.sender, tokenId, tokenBAmount);
    }

    function claimTokenB(
        address operatorAddress,
        uint256 requestNumber
    ) external onlyStakeHubDelegateCall whenNotPaused notInBlackList validatorExist(operatorAddress) {
        _claimTokenB(operatorAddress, msg.sender, requestNumber);
    }

    function claimTokenBBatch(
        address[] calldata operatorAddresses,
        uint256[] calldata requestNumbers
    ) external onlyStakeHubDelegateCall whenNotPaused notInBlackList {
        if (operatorAddresses.length != requestNumbers.length) revert InvalidRequest();

        for (uint256 i; i < operatorAddresses.length; ++i) {
            if (!_validatorSet.contains(operatorAddresses[i])) revert ValidatorNotExisted();
            _claimTokenB(operatorAddresses[i], msg.sender, requestNumbers[i]);
        }
    }

    function claimTokenBReward(
        address operatorAddress
    ) external onlyStakeHubDelegateCall whenNotPaused notInBlackList validatorExist(operatorAddress) {
        _claimTokenBReward(operatorAddress, msg.sender);
    }

    function claimTokenBRewardBatch(
        address[] calldata operatorAddresses
    ) external onlyStakeHubDelegateCall whenNotPaused notInBlackList {
        for (uint256 i; i < operatorAddresses.length; ++i) {
            if (!_validatorSet.contains(operatorAddresses[i])) revert ValidatorNotExisted();
            _claimTokenBReward(operatorAddresses[i], msg.sender);
        }
    }

    function getDelegatedTokenB(
        address operatorAddress,
        address delegator
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        return _delegatedTokenB[operatorAddress][delegator];
    }

    function getDelegatedTokenBById(
        address operatorAddress,
        address delegator,
        uint256 tokenId
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        return _delegatedTokenBById[operatorAddress][delegator][tokenId];
    }

    function getLegacyDelegatedTokenB(
        address operatorAddress,
        address delegator
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        return _legacyDelegatedTokenBAmount(operatorAddress, delegator);
    }

    function getLegacyDelegatedTokenBById(
        address operatorAddress,
        address delegator,
        uint256 tokenId
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        if (tokenBCutoverVersion == 0 || _tokenBDelegationVersion[operatorAddress][delegator] >= tokenBCutoverVersion) {
            return 0;
        }
        return _delegatedTokenBById[operatorAddress][delegator][tokenId];
    }

    function getTokenBDelegators(
        address operatorAddress,
        uint256 offset,
        uint256 limit
    ) external view onlyStakeHubDelegateCall returns (address[] memory delegators, uint256 totalLength) {
        totalLength = _tokenBDelegators[operatorAddress].length();
        if (offset >= totalLength) {
            return (delegators, totalLength);
        }

        limit = limit == 0 ? totalLength : limit;
        uint256 count = (totalLength - offset) > limit ? limit : (totalLength - offset);
        delegators = new address[](count);
        for (uint256 i; i < count; ++i) {
            delegators[i] = _tokenBDelegators[operatorAddress].at(offset + i);
        }
    }

    function tokenBUnbondRequest(
        address operatorAddress,
        address delegator,
        uint256 index
    ) external view onlyStakeHubDelegateCall returns (uint256 tokenBAmount, uint256 unlockTime) {
        uint256 head = _tokenB1155UnbondHead[operatorAddress][delegator];
        uint256 tail = _tokenB1155UnbondTail[operatorAddress][delegator];
        if (head + index >= tail) revert InvalidRequest();

        TokenB1155UnbondRequest memory request = _tokenB1155UnbondRequests[operatorAddress][delegator][head + index];
        tokenBAmount = request.tokenBAmount;
        unlockTime = request.unlockTime;
    }

    function tokenB1155UnbondRequest(
        address operatorAddress,
        address delegator,
        uint256 index
    ) external view onlyStakeHubDelegateCall returns (uint256 tokenId, uint256 tokenBAmount, uint256 unlockTime) {
        uint256 head = _tokenB1155UnbondHead[operatorAddress][delegator];
        uint256 tail = _tokenB1155UnbondTail[operatorAddress][delegator];
        if (head + index >= tail) revert InvalidRequest();

        TokenB1155UnbondRequest memory request = _tokenB1155UnbondRequests[operatorAddress][delegator][head + index];
        tokenId = request.tokenId;
        tokenBAmount = request.tokenBAmount;
        unlockTime = request.unlockTime;
    }

    function pendingTokenBUnbondRequest(
        address operatorAddress,
        address delegator
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        return _tokenB1155UnbondTail[operatorAddress][delegator] - _tokenB1155UnbondHead[operatorAddress][delegator];
    }

    function claimableTokenBUnbondRequest(
        address operatorAddress,
        address delegator
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        uint256 head = _tokenB1155UnbondHead[operatorAddress][delegator];
        uint256 tail = _tokenB1155UnbondTail[operatorAddress][delegator];
        uint256 count;

        while (head < tail) {
            TokenB1155UnbondRequest memory request = _tokenB1155UnbondRequests[operatorAddress][delegator][head];
            if (block.timestamp < request.unlockTime) {
                break;
            }
            ++count;
            ++head;
        }

        return count;
    }

    function pendingTokenBReward(
        address operatorAddress,
        address delegator
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        (uint256 delegatedAmount, uint256 rewardAcc) = _rewardedTokenBPosition(operatorAddress, delegator);
        return _pendingTokenBRewardAt(operatorAddress, delegator, delegatedAmount, rewardAcc);
    }

    function _queueTokenBUnbond(
        address operatorAddress,
        address delegator,
        uint256 tokenBAmount
    ) internal {
        uint256 tail = _tokenBUnbondTail[operatorAddress][delegator];
        _tokenBUnbondRequests[operatorAddress][delegator][tail] =
            TokenBUnbondRequest({ tokenBAmount: tokenBAmount, unlockTime: block.timestamp + unbondPeriod });
        _tokenBUnbondRequestVersion[operatorAddress][delegator][tail] = tokenBCutoverVersion;
        _tokenBUnbondTail[operatorAddress][delegator] = tail + 1;
    }

    function _queueTokenB1155Unbond(
        address operatorAddress,
        address delegator,
        uint256 tokenId,
        uint256 tokenBAmount,
        uint256 unbondVersion
    ) internal {
        uint256 tail = _tokenB1155UnbondTail[operatorAddress][delegator];
        _tokenB1155UnbondRequests[operatorAddress][delegator][tail] = TokenB1155UnbondRequest({
            tokenId: tokenId, tokenBAmount: tokenBAmount, unlockTime: block.timestamp + unbondPeriod
        });
        _tokenBUnbondRequestVersion[operatorAddress][delegator][tail] = unbondVersion;
        _tokenB1155UnbondTail[operatorAddress][delegator] = tail + 1;
    }

    function _claimTokenB(
        address operatorAddress,
        address delegator,
        uint256 requestNumber
    ) internal {
        _claimTokenB1155(operatorAddress, delegator, requestNumber);
    }

    function _claimTokenB1155(
        address operatorAddress,
        address delegator,
        uint256 requestNumber
    ) internal {
        if (stakeTokenB == address(0)) revert InvalidRequest();

        uint256 head = _tokenB1155UnbondHead[operatorAddress][delegator];
        uint256 tail = _tokenB1155UnbondTail[operatorAddress][delegator];
        if (head >= tail) revert InvalidRequest();

        uint256 requestCount = tail - head;
        uint256 number = requestNumber == 0 || requestNumber > requestCount ? requestCount : requestNumber;

        uint256 activePrimaryAmount;
        uint256 activeSecondaryAmount;
        uint256 legacyPrimaryAmount;
        uint256 legacySecondaryAmount;
        while (number != 0) {
            TokenB1155UnbondRequest memory request = _tokenB1155UnbondRequests[operatorAddress][delegator][head];
            if (block.timestamp < request.unlockTime) {
                break;
            }

            uint256 requestVersion = _tokenBUnbondRequestVersion[operatorAddress][delegator][head];
            if (tokenBCutoverVersion != 0 && requestVersion < tokenBCutoverVersion) {
                if (request.tokenId == stakeTokenBPrimaryId) {
                    legacyPrimaryAmount += request.tokenBAmount;
                } else {
                    legacySecondaryAmount += request.tokenBAmount;
                }
            } else if (request.tokenId == stakeTokenBPrimaryId) {
                activePrimaryAmount += request.tokenBAmount;
            } else {
                activeSecondaryAmount += request.tokenBAmount;
            }

            delete _tokenB1155UnbondRequests[operatorAddress][delegator][head];
            delete _tokenBUnbondRequestVersion[operatorAddress][delegator][head];
            ++head;
            --number;
        }

        uint256 totalClaimed = activePrimaryAmount + activeSecondaryAmount + legacyPrimaryAmount + legacySecondaryAmount;
        if (totalClaimed == 0) revert InvalidRequest();

        _tokenB1155UnbondHead[operatorAddress][delegator] = head;
        if (activePrimaryAmount != 0) {
            IERC1155(stakeTokenB)
                .safeTransferFrom(address(this), delegator, stakeTokenBPrimaryId, activePrimaryAmount, "");
            emit TokenB1155Claimed(operatorAddress, delegator, stakeTokenBPrimaryId, activePrimaryAmount);
        }
        if (activeSecondaryAmount != 0) {
            IERC1155(stakeTokenB)
                .safeTransferFrom(address(this), delegator, stakeTokenBSecondaryId, activeSecondaryAmount, "");
            emit TokenB1155Claimed(operatorAddress, delegator, stakeTokenBSecondaryId, activeSecondaryAmount);
        }
        if (legacyPrimaryAmount != 0) {
            IERC1155(legacyStakeTokenB)
                .safeTransferFrom(address(this), delegator, stakeTokenBPrimaryId, legacyPrimaryAmount, "");
            emit LegacyTokenB1155Claimed(operatorAddress, delegator, stakeTokenBPrimaryId, legacyPrimaryAmount);
        }
        if (legacySecondaryAmount != 0) {
            IERC1155(legacyStakeTokenB)
                .safeTransferFrom(address(this), delegator, stakeTokenBSecondaryId, legacySecondaryAmount, "");
            emit LegacyTokenB1155Claimed(operatorAddress, delegator, stakeTokenBSecondaryId, legacySecondaryAmount);
        }

        emit TokenBClaimed(operatorAddress, delegator, totalClaimed);
    }

    function _claimTokenBReward(
        address operatorAddress,
        address delegator
    ) internal {
        _settleTokenBReward(operatorAddress, delegator);
        uint256 reward = _pendingTokenBReward[operatorAddress][delegator];
        if (reward == 0) revert InvalidRequest();

        _pendingTokenBReward[operatorAddress][delegator] = 0;
        (bool success,) = payable(delegator).call{ value: reward, gas: transferGasLimit }("");
        if (!success) revert TransferFailed();

        emit TokenBRewardClaimed(operatorAddress, delegator, reward);
    }
}
