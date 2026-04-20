// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IGiltValidatorSet {
    function felony(address consensusAddress) external;
    function getMiningValidators() external view returns (address[] memory, bytes[] memory);
    function isCurrentValidator(address validator) external view returns (bool);
}
