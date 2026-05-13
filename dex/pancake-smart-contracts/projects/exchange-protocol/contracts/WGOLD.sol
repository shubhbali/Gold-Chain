// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract WGOLD is ERC1155, ERC1155Holder {
    uint256 public constant PAXG_TOKEN_ID = 1;
    uint256 public constant XAUT_TOKEN_ID = 2;

    IERC1155 public immutable rawGold;

    event Wrapped(address indexed account, uint256 indexed tokenId, uint256 amount);
    event WrappedBatch(address indexed account, uint256[] tokenIds, uint256[] amounts);
    event Unwrapped(address indexed account, uint256 indexed tokenId, uint256 amount);
    event UnwrappedBatch(address indexed account, uint256[] tokenIds, uint256[] amounts);

    constructor(address gold_) ERC1155("") {
        require(gold_ != address(0), "WGOLD: invalid gold");
        rawGold = IERC1155(gold_);
    }

    function wrap(uint256 tokenId, uint256 amount) external {
        require(_isSupportedTokenId(tokenId), "WGOLD: unsupported token");
        require(amount != 0, "WGOLD: invalid amount");

        rawGold.safeTransferFrom(msg.sender, address(this), tokenId, amount, "");
        _mint(msg.sender, tokenId, amount, "");

        emit Wrapped(msg.sender, tokenId, amount);
    }

    function wrapBatch(uint256[] calldata tokenIds, uint256[] calldata amounts) external {
        uint256 length = tokenIds.length;
        require(length == amounts.length, "WGOLD: length mismatch");
        require(length != 0, "WGOLD: empty batch");

        for (uint256 i = 0; i < length; ++i) {
            require(_isSupportedTokenId(tokenIds[i]), "WGOLD: unsupported token");
        }
        for (uint256 i = 0; i < length; ++i) {
            require(amounts[i] != 0, "WGOLD: invalid amount");
        }

        rawGold.safeBatchTransferFrom(msg.sender, address(this), tokenIds, amounts, "");
        _mintBatch(msg.sender, tokenIds, amounts, "");

        emit WrappedBatch(msg.sender, tokenIds, amounts);
    }

    function unwrap(uint256 tokenId, uint256 amount) external {
        require(_isSupportedTokenId(tokenId), "WGOLD: unsupported token");
        require(amount != 0, "WGOLD: invalid amount");

        _burn(msg.sender, tokenId, amount);
        rawGold.safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        emit Unwrapped(msg.sender, tokenId, amount);
    }

    function unwrapBatch(uint256[] calldata tokenIds, uint256[] calldata amounts) external {
        uint256 length = tokenIds.length;
        require(length == amounts.length, "WGOLD: length mismatch");
        require(length != 0, "WGOLD: empty batch");

        for (uint256 i = 0; i < length; ++i) {
            require(_isSupportedTokenId(tokenIds[i]), "WGOLD: unsupported token");
            require(amounts[i] != 0, "WGOLD: invalid amount");
        }

        _burnBatch(msg.sender, tokenIds, amounts);
        rawGold.safeBatchTransferFrom(address(this), msg.sender, tokenIds, amounts, "");

        emit UnwrappedBatch(msg.sender, tokenIds, amounts);
    }

    function backingById(uint256 tokenId) external view returns (uint256) {
        require(_isSupportedTokenId(tokenId), "WGOLD: unsupported token");
        return rawGold.balanceOf(address(this), tokenId);
    }

    function totalBacking() external view returns (uint256) {
        return rawGold.balanceOf(address(this), PAXG_TOKEN_ID) + rawGold.balanceOf(address(this), XAUT_TOKEN_ID);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC1155Receiver) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _isSupportedTokenId(uint256 tokenId) private pure returns (bool) {
        return tokenId == PAXG_TOKEN_ID || tokenId == XAUT_TOKEN_ID;
    }
}
