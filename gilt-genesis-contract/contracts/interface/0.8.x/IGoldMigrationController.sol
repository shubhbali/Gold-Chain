// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IGoldMigrationController {
    function lifecycleState() external view returns (uint8);
    function migrationPaused() external view returns (bool);
    function legacyGold() external view returns (address);
    function finalGold() external view returns (address);
    function reserveVault() external view returns (address);
    function stakeMigrationCaller() external view returns (address);
    function migrateStake(
        address delegator,
        uint256 tokenId,
        uint256 amount
    ) external;
}
