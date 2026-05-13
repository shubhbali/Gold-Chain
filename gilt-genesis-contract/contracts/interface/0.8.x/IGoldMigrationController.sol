// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IGoldMigrationController {
    function lifecycleState() external view returns (uint8);
    function migrateStake(address delegator, uint256 tokenId, uint256 amount) external;
}

