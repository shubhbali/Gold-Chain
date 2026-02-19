// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GiltRatioGovernance {
    uint256 public constant FLOOR = 5;      // 5% minimum
    uint256 public constant CAP = 30;       // 30% maximum
    uint256 public constant ENACTMENT_DELAY = 60 days;

    uint256 public currentRatio;            // 0 = disabled
    uint256 public pendingRatio;
    uint256 public pendingActivationTime;

    address public giltTokenAddress;

    event RatioProposed(uint256 newRatio, uint256 activationTime);
    event RatioActivated(uint256 newRatio);

    constructor(address _giltTokenAddress) {
        giltTokenAddress = _giltTokenAddress;
        currentRatio = 0; // disabled at launch
    }

    function proposeRatio(uint256 newRatio) external {
        require(newRatio == 0 || (newRatio >= FLOOR && newRatio <= CAP), "Ratio must be 0 or between 5-30%");
        require(getGiltBalance(msg.sender) > 0, "Must hold GILT to propose");

        pendingRatio = newRatio;
        pendingActivationTime = block.timestamp + ENACTMENT_DELAY;

        emit RatioProposed(newRatio, pendingActivationTime);
    }

    function executeRatio() external {
        require(pendingActivationTime > 0, "No pending ratio");
        require(block.timestamp >= pendingActivationTime, "Enactment delay not passed");

        currentRatio = pendingRatio;
        pendingRatio = 0;
        pendingActivationTime = 0;

        emit RatioActivated(currentRatio);
    }

    function getCurrentRatio() external view returns (uint256) {
        return currentRatio;
    }

    function getGiltBalance(address account) internal view returns (uint256) {
        // Native token balance check - will be replaced with actual implementation
        return account.balance;
    }
}
