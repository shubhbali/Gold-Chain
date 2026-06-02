// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

library StakeHubMath {
    function effectiveVotingPower(
        uint256 stakeA,
        uint256 stakeB,
        uint256 stakeWeightA,
        uint256 stakeWeightB,
        uint256 powerScale,
        bool ratioEnabled,
        uint256 minBtoARatioBps,
        uint256 maxBPowerRatioBps
    ) internal pure returns (uint256) {
        uint256 weightedA = (stakeA * stakeWeightA) / powerScale;
        uint256 weightedB = (stakeB * stakeWeightB) / powerScale;

        if (weightedA == 0) {
            return 0;
        }

        if (ratioEnabled && minBtoARatioBps > 0 && stakeB * powerScale < stakeA * minBtoARatioBps) {
            weightedB = 0;
        }

        uint256 maxBWeighted = (weightedA * maxBPowerRatioBps) / powerScale;
        if (weightedB > maxBWeighted) {
            weightedB = maxBWeighted;
        }

        return weightedA + weightedB;
    }

    function currentInflationBps(
        uint256 dayIndex,
        uint256 inflationStartDayIndex,
        uint256 inflationRateInitialBps,
        uint256 inflationRateMinBps,
        uint256 inflationDecayBpsPerYear,
        uint256 powerScale
    ) internal pure returns (uint256) {
        if (dayIndex <= inflationStartDayIndex) {
            return inflationRateInitialBps;
        }

        uint256 yearsElapsed = (dayIndex - inflationStartDayIndex) / 365;
        uint256 current = inflationRateInitialBps;
        for (uint256 i; i < yearsElapsed; ++i) {
            current = (current * (powerScale - inflationDecayBpsPerYear)) / powerScale;
            if (current <= inflationRateMinBps) {
                return inflationRateMinBps;
            }
        }
        if (current < inflationRateMinBps) {
            return inflationRateMinBps;
        }
        return current;
    }
}
