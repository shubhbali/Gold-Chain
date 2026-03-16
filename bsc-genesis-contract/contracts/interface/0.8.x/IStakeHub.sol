// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IStakeHub {
    function DEAD_ADDRESS() external view returns (address);
    function LOCK_AMOUNT() external view returns (uint256);
    function BREATHE_BLOCK_INTERVAL() external view returns (uint256);
    function unbondPeriod() external view returns (uint256);
    function transferGasLimit() external view returns (uint256);
    function stakeTokenB() external view returns (address);
    function legacyStakeTokenB() external view returns (address);
    function tokenBCutoverVersion() external view returns (uint256);
    function tokenBMigrationReserve() external view returns (uint256);
    function totalDelegatedTokenB(address operatorAddress) external view returns (uint256);
    function totalLegacyDelegatedTokenB(address operatorAddress) external view returns (uint256);
    function getDelegatedTokenB(address operatorAddress, address delegator) external view returns (uint256);
    function getLegacyDelegatedTokenB(address operatorAddress, address delegator) external view returns (uint256);
    function activateTokenBMigration(address newStakeTokenB, address reserveVault) external;
    function depositTokenBMigrationReserve(uint256 amount) external;
    function migrateLegacyTokenB(address operatorAddress) external;
}
