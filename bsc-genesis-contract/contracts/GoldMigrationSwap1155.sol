// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract GoldMigrationSwap1155 is Ownable, ERC1155Holder {
    IERC1155 public immutable legacyGold;
    IERC1155 public immutable newGold;
    address public immutable reserveVault;
    bool public swapEnabled;

    event SwapEnabledSet(bool enabled);
    event GoldSwapped(address indexed account, uint256 indexed tokenId, uint256 amount);
    event NewGoldWithdrawn(address indexed recipient, uint256 indexed tokenId, uint256 amount);

    constructor(address legacyGold_, address newGold_, address reserveVault_) {
        require(legacyGold_ != address(0) && newGold_ != address(0) && reserveVault_ != address(0), "invalid address");
        legacyGold = IERC1155(legacyGold_);
        newGold = IERC1155(newGold_);
        reserveVault = reserveVault_;
        swapEnabled = true;
    }

    function setSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
        emit SwapEnabledSet(enabled);
    }

    function swap(uint256 tokenId, uint256 amount) external {
        require(swapEnabled, "swap disabled");
        require(amount != 0, "invalid amount");

        legacyGold.safeTransferFrom(msg.sender, reserveVault, tokenId, amount, "");
        newGold.safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        emit GoldSwapped(msg.sender, tokenId, amount);
    }

    function withdrawNewGold(address recipient, uint256 tokenId, uint256 amount) external onlyOwner {
        newGold.safeTransferFrom(address(this), recipient, tokenId, amount, "");
        emit NewGoldWithdrawn(recipient, tokenId, amount);
    }
}
