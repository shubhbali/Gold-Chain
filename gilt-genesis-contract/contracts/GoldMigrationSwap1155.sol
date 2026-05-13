// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./GoldMigrationController.sol";

contract GoldMigrationSwap1155 is Ownable {
    GoldMigrationController public immutable migrationController;
    bool public swapEnabled;

    event SwapEnabledSet(bool enabled);
    event GoldSwapped(address indexed account, uint256 indexed tokenId, uint256 amount);
    event RouterMigrated(address indexed account, uint256 indexed tokenId, uint256 amount);

    constructor(address migrationController_) {
        require(migrationController_ != address(0), "invalid controller");
        migrationController = GoldMigrationController(migrationController_);
        swapEnabled = false;
    }

    function legacyGold() external view returns (address) {
        return address(migrationController.legacyGold());
    }

    function newGold() external view returns (address) {
        return address(migrationController.finalGold());
    }

    function reserveVault() external view returns (address) {
        return migrationController.reserveVault();
    }

    function setSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
        emit SwapEnabledSet(enabled);
    }

    function swap(uint256 tokenId, uint256 amount) external {
        require(swapEnabled, "swap disabled");
        require(amount != 0, "invalid amount");

        migrationController.migrateWalletFor(msg.sender, tokenId, amount);
        emit GoldSwapped(msg.sender, tokenId, amount);
        emit RouterMigrated(msg.sender, tokenId, amount);
    }
}
