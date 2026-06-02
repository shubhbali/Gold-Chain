// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface GiltValidatorSetTool {
    function decodePayloadHeader(bytes memory payload) external pure returns (bool, uint8, uint256, bytes memory);
}
