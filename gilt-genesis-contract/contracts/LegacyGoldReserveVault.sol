// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract LegacyGoldReserveVault is Ownable, ERC1155Holder {
    event LegacyGold1155Released(
        address indexed token, address indexed recipient, uint256 indexed tokenId, uint256 amount
    );

    function release1155(address token, address recipient, uint256 tokenId, uint256 amount) external onlyOwner {
        IERC1155(token).safeTransferFrom(address(this), recipient, tokenId, amount, "");
        emit LegacyGold1155Released(token, recipient, tokenId, amount);
    }
}
