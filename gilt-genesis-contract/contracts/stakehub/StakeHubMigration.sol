// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "../interface/0.8.x/IGoldMigrationController.sol";
import "./StakeHubCommon.sol";

contract StakeHubMigration is StakeHubCommon {
    using EnumerableSet for EnumerableSet.AddressSet;

    function activateTokenBMigration(
        address newStakeTokenB,
        address reserveVault
    ) external onlyStakeHubDelegateCall onlyGov {
        _requireActiveGoldMigrationController(stakeTokenB, newStakeTokenB, reserveVault);
        _activateTokenBMigration(newStakeTokenB, reserveVault);
    }

    function depositTokenBMigrationReserve1155(
        uint256 tokenId,
        uint256 amount
    ) external view onlyStakeHubDelegateCall whenNotPaused {
        tokenId;
        amount;
        revert TokenBMigrationNotAvailable();
    }

    function withdrawTokenBMigrationReserve1155(
        address recipient,
        uint256 tokenId,
        uint256 amount
    ) external view onlyStakeHubDelegateCall onlyGov {
        recipient;
        tokenId;
        amount;
        revert TokenBMigrationNotAvailable();
    }

    function hasApprovedTokenBMigration(
        uint256 proposalId,
        address operatorAddress
    ) external view onlyStakeHubDelegateCall returns (bool) {
        return _tokenBMigrationApprovals[proposalId][operatorAddress];
    }

    function migrateLegacyTokenB(
        address operatorAddress
    ) external onlyStakeHubDelegateCall whenNotPaused notInBlackList validatorExist(operatorAddress) {
        IGoldMigrationController migrationController = _activeTokenBMigrationController();
        if (!_migrateLegacyTokenBPosition(migrationController, operatorAddress, msg.sender)) {
            revert TokenBMigrationNotAvailable();
        }
    }

    function migrateLegacyTokenBDelegators(
        address operatorAddress,
        uint256 offset,
        uint256 limit
    ) external onlyStakeHubDelegateCall whenNotPaused validatorExist(operatorAddress) {
        IGoldMigrationController migrationController = _activeTokenBMigrationController();
        uint256 totalLength = _tokenBDelegators[operatorAddress].length();
        if (offset >= totalLength) {
            return;
        }

        limit = limit == 0 ? totalLength : limit;
        uint256 count = (totalLength - offset) > limit ? limit : (totalLength - offset);
        for (uint256 i; i < count; ++i) {
            _migrateLegacyTokenBPosition(
                migrationController, operatorAddress, _tokenBDelegators[operatorAddress].at(offset + i)
            );
        }
    }

    function _activeTokenBMigrationController() internal view returns (IGoldMigrationController migrationController) {
        address migrationControllerAddress = tokenBMigrationController;
        if (legacyStakeTokenB == address(0) || migrationControllerAddress == address(0) || tokenBCutoverVersion == 0) {
            revert TokenBMigrationNotAvailable();
        }

        migrationController =
            _requireActiveGoldMigrationController(legacyStakeTokenB, stakeTokenB, legacyTokenBReserveVault);
    }

    function _migrateLegacyTokenBPosition(
        IGoldMigrationController migrationController,
        address operatorAddress,
        address delegator
    ) internal returns (bool) {
        if (_tokenBDelegationVersion[operatorAddress][delegator] >= tokenBCutoverVersion) {
            return false;
        }

        uint256 migratedPrimaryAmount = _delegatedTokenBById[operatorAddress][delegator][stakeTokenBPrimaryId];
        uint256 migratedSecondaryAmount = _delegatedTokenBById[operatorAddress][delegator][stakeTokenBSecondaryId];
        uint256 migratedAmount = migratedPrimaryAmount + migratedSecondaryAmount;
        if (migratedAmount == 0) {
            return false;
        }
        if (migratedAmount != _delegatedTokenB[operatorAddress][delegator]) revert InvalidRequest();

        _settleTokenBReward(operatorAddress, delegator);
        if (migratedPrimaryAmount != 0) {
            migrationController.migrateStake(delegator, stakeTokenBPrimaryId, migratedPrimaryAmount);
            emit LegacyTokenB1155Migrated(operatorAddress, delegator, stakeTokenBPrimaryId, migratedPrimaryAmount);
        }
        if (migratedSecondaryAmount != 0) {
            migrationController.migrateStake(delegator, stakeTokenBSecondaryId, migratedSecondaryAmount);
            emit LegacyTokenB1155Migrated(operatorAddress, delegator, stakeTokenBSecondaryId, migratedSecondaryAmount);
        }

        totalLegacyDelegatedTokenB[operatorAddress] -= migratedAmount;
        _tokenBDelegationVersion[operatorAddress][delegator] = tokenBCutoverVersion;
        _syncTokenBRewardDebt(operatorAddress, delegator);

        emit LegacyTokenBMigrated(operatorAddress, delegator, migratedAmount);
        return true;
    }

    function _approveTokenBMigrationProposal(
        uint256 proposalId,
        address operatorAddress
    ) internal {
        if (_tokenBMigrationApprovals[proposalId][operatorAddress]) revert InvalidRequest();

        _tokenBMigrationApprovals[proposalId][operatorAddress] = true;
        pendingTokenBMigrationApprovalCount += 1;

        emit TokenBMigrationApproved(
            proposalId, operatorAddress, pendingTokenBMigrationApprovalCount, pendingTokenBMigrationRequiredApprovals
        );
    }

    function _clearPendingTokenBMigrationProposal() internal {
        pendingTokenBMigrationStakeTokenB = address(0);
        pendingTokenBMigrationReserveVault = address(0);
        pendingTokenBMigrationApprovalCount = 0;
        pendingTokenBMigrationRequiredApprovals = 0;
    }
}
