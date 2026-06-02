// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "../interface/0.8.x/IGovToken.sol";
import "../interface/0.8.x/IStakeCredit.sol";
import "./StakeHubCommon.sol";

contract StakeHubRewards is StakeHubCommon {
    function distributeReward(
        address consensusAddress
    ) external payable onlyStakeHubDelegateCall onlyValidatorContract {
        _autoRetryPendingSystemReward();

        address operatorAddress = consensusToOperator[consensusAddress];
        Validator memory valInfo = _validators[operatorAddress];
        if (valInfo.creditContract == address(0) || valInfo.jailed) {
            emit RewardDistributeFailed(operatorAddress, "INVALID_VALIDATOR");
            _forwardSystemRewardOrQueue(operatorAddress, msg.value, _REWARD_FORWARD_REASON_INVALID_VALIDATOR, false);
            return;
        }

        _distributeValidatorReward(operatorAddress, valInfo, msg.value);
    }

    function retryPendingSystemReward(
        uint256 maxAmount
    ) external onlyStakeHubDelegateCall onlyGov {
        uint256 pending = pendingSystemReward;
        if (pending == 0) {
            emit RewardForwardRetried(msg.sender, 0, true, "");
            return;
        }

        uint256 amount = maxAmount == 0 || maxAmount > pending ? pending : maxAmount;
        (bool success, bytes memory failReason) = _retryPendingSystemReward(amount, _REWARD_FORWARD_REASON_MANUAL_RETRY);
        emit RewardForwardRetried(msg.sender, amount, success, failReason);
    }

    function sweepPendingSystemReward(
        address recipient,
        uint256 amount
    ) external onlyStakeHubDelegateCall onlyGov {
        if (recipient == address(0) || amount == 0 || amount > pendingSystemReward) revert InvalidRequest();
        pendingSystemReward -= amount;
        uint256 resolvedInflationAmount = _consumePendingInflation(amount);
        if (resolvedInflationAmount != 0) {
            inflationRedirectedAmount += resolvedInflationAmount;
        }
        (bool success,) = payable(recipient).call{ value: amount, gas: transferGasLimit }("");
        if (!success) revert TransferFailed();
        emit RewardForwardSwept(msg.sender, recipient, amount, resolvedInflationAmount);
    }
}
