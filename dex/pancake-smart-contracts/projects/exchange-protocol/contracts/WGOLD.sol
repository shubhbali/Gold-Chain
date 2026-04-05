// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract WGOLD is ERC20, ERC1155Holder {
    uint256 public constant PAXG_TOKEN_ID = 1;
    uint256 public constant XAUT_TOKEN_ID = 2;

    IERC1155 public immutable gold;

    event Wrapped(address indexed account, uint256 indexed tokenId, uint256 amount);
    event WrappedBatch(address indexed account, uint256[] tokenIds, uint256[] amounts, uint256 mintedAmount);
    event Unwrapped(address indexed account, uint256 indexed tokenId, uint256 amount);

    constructor(address gold_) ERC20("Wrapped Gold", "WGOLD") {
        require(gold_ != address(0), "WGOLD: invalid gold");
        gold = IERC1155(gold_);
    }

    function wrap(uint256 tokenId, uint256 amount) external {
        require(_isSupportedTokenId(tokenId), "WGOLD: unsupported token");
        require(amount != 0, "WGOLD: invalid amount");

        gold.safeTransferFrom(msg.sender, address(this), tokenId, amount, "");
        _mint(msg.sender, amount);

        emit Wrapped(msg.sender, tokenId, amount);
    }

    function wrapBatch(uint256[] calldata tokenIds, uint256[] calldata amounts) external {
        uint256 length = tokenIds.length;
        require(length == amounts.length, "WGOLD: length mismatch");
        require(length != 0, "WGOLD: empty batch");

        uint256 mintedAmount;
        for (uint256 i = 0; i < length; ++i) {
            require(_isSupportedTokenId(tokenIds[i]), "WGOLD: unsupported token");
            mintedAmount += amounts[i];
        }
        require(mintedAmount != 0, "WGOLD: invalid amount");

        gold.safeBatchTransferFrom(msg.sender, address(this), tokenIds, amounts, "");
        _mint(msg.sender, mintedAmount);

        emit WrappedBatch(msg.sender, tokenIds, amounts, mintedAmount);
    }

    function unwrap(uint256 tokenId, uint256 amount) external {
        require(_isSupportedTokenId(tokenId), "WGOLD: unsupported token");
        require(amount != 0, "WGOLD: invalid amount");

        _burn(msg.sender, amount);
        gold.safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        emit Unwrapped(msg.sender, tokenId, amount);
    }

    function backingById(uint256 tokenId) external view returns (uint256) {
        require(_isSupportedTokenId(tokenId), "WGOLD: unsupported token");
        return gold.balanceOf(address(this), tokenId);
    }

    function totalBacking() external view returns (uint256) {
        return gold.balanceOf(address(this), PAXG_TOKEN_ID) + gold.balanceOf(address(this), XAUT_TOKEN_ID);
    }

    function _isSupportedTokenId(uint256 tokenId) private pure returns (bool) {
        return tokenId == PAXG_TOKEN_ID || tokenId == XAUT_TOKEN_ID;
    }
}
