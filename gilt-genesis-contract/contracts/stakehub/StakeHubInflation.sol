// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "../lib/0.8.x/StakeHubMath.sol";
import "./StakeHubCommon.sol";

contract StakeHubInflation is StakeHubCommon {
    function recordInflationMint(
        address consensusAddress
    ) external payable onlyStakeHubDelegateCall onlyValidatorContract {
        uint256 totalReward = msg.value;
        if (totalReward == 0) {
            return;
        }

        if (!inflationEnabled || inflationBaseSupply == 0) revert InvalidRequest();
        _autoRetryPendingSystemReward();

        uint256 dayIndex = block.timestamp / BREATHE_BLOCK_INTERVAL;
        if (inflationRecorderByDay[dayIndex] != address(0)) revert InflationAlreadyRecorded(dayIndex);
        uint256 expectedAmount = expectedInflationMintAmount(dayIndex);
        if (expectedAmount == 0 || totalReward != expectedAmount) {
            revert InvalidInflationMintAmount(expectedAmount, totalReward);
        }

        uint256 inflationBps = _currentInflationBps(dayIndex);
        uint256 effectiveSupply = inflationBaseSupply + inflationMintedAmount;
        uint256 maxMintForDay = ((effectiveSupply * inflationBps) / POWER_SCALE) / 365;
        uint256 mintedForDay = inflationMintedByDay[dayIndex] + totalReward;
        if (maxMintForDay == 0 || mintedForDay > maxMintForDay) revert InflationScheduleExceeded();

        inflationRecorderByDay[dayIndex] = consensusAddress;
        inflationMintedByDay[dayIndex] = mintedForDay;
        inflationMintedAmount += totalReward;
        inflationLastMintTimestamp = block.timestamp;
        effectiveSupply = inflationBaseSupply + inflationMintedAmount;

        address operatorAddress = consensusToOperator[consensusAddress];
        Validator memory valInfo = _validators[operatorAddress];
        uint256 redirectedAmount;
        uint256 pendingAmount;
        if (valInfo.creditContract == address(0) || valInfo.jailed) {
            emit InflationRedirected(consensusAddress, operatorAddress, totalReward);
            (redirectedAmount, pendingAmount) = _forwardSystemRewardOrQueue(
                operatorAddress, totalReward, _REWARD_FORWARD_REASON_INFLATION_REDIRECT, true
            );
        } else {
            _distributeValidatorReward(operatorAddress, valInfo, totalReward);
            inflationDistributedAmount += totalReward;
        }

        emit InflationIntervalRecorded(dayIndex, consensusAddress, totalReward);
        emit InflationMintRecorded(totalReward, inflationBps, inflationMintedAmount, effectiveSupply);
        emit InflationRecordedV2(
            totalReward,
            totalReward - redirectedAmount - pendingAmount,
            redirectedAmount,
            pendingAmount,
            inflationBps,
            inflationMintedAmount,
            effectiveSupply
        );
    }

    function currentInflationBps(
        uint256 dayIndex
    ) external view onlyStakeHubDelegateCall returns (uint256) {
        return _currentInflationBps(dayIndex);
    }

    function inflationEffectiveSupply() external view onlyStakeHubDelegateCall returns (uint256) {
        return inflationBaseSupply + inflationMintedAmount;
    }

    function expectedInflationMintAmount(
        uint256 dayIndex
    ) public view onlyStakeHubDelegateCall returns (uint256) {
        if (!inflationEnabled || inflationBaseSupply == 0 || inflationRecorderByDay[dayIndex] != address(0)) {
            return 0;
        }
        uint256 inflationBps = _currentInflationBps(dayIndex);
        if (inflationBps == 0) {
            return 0;
        }
        uint256 effectiveSupply = inflationBaseSupply + inflationMintedAmount;
        return ((effectiveSupply * inflationBps) / POWER_SCALE) / 365;
    }

    function _currentInflationBps(
        uint256 dayIndex
    ) internal view returns (uint256) {
        return StakeHubMath.currentInflationBps(
            dayIndex,
            inflationStartDayIndex,
            inflationRateInitialBps,
            inflationRateMinBps,
            inflationDecayBpsPerYear,
            POWER_SCALE
        );
    }
}
