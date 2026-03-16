// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract GoldMigrationSwap is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable legacyGold;
    IERC20 public immutable newGold;
    address public immutable reserveVault;
    bool public swapEnabled;

    event SwapEnabledSet(bool enabled);
    event GoldSwapped(address indexed account, uint256 amount);
    event NewGoldWithdrawn(address indexed recipient, uint256 amount);

    constructor(address legacyGold_, address newGold_, address reserveVault_) {
        require(legacyGold_ != address(0) && newGold_ != address(0) && reserveVault_ != address(0), "invalid address");
        legacyGold = IERC20(legacyGold_);
        newGold = IERC20(newGold_);
        reserveVault = reserveVault_;
        swapEnabled = true;
    }

    function setSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
        emit SwapEnabledSet(enabled);
    }

    function swap(uint256 amount) external {
        require(swapEnabled, "swap disabled");
        require(amount != 0, "invalid amount");

        legacyGold.safeTransferFrom(msg.sender, reserveVault, amount);
        newGold.safeTransfer(msg.sender, amount);

        emit GoldSwapped(msg.sender, amount);
    }

    function withdrawNewGold(address recipient, uint256 amount) external onlyOwner {
        newGold.safeTransfer(recipient, amount);
        emit NewGoldWithdrawn(recipient, amount);
    }
}
