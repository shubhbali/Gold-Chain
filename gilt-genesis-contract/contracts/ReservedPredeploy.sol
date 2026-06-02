// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract ReservedPredeploy {
    error ReservedPredeployInactive();

    fallback() external payable {
        revert ReservedPredeployInactive();
    }

    receive() external payable {
        revert ReservedPredeployInactive();
    }
}
