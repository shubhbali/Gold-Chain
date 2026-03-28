// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract PhysicalGold1155 is ERC1155, ERC1155Supply, Ownable {
    uint256 public constant PAXG_TOKEN_ID = 1;
    uint256 public constant XAUT_TOKEN_ID = 2;

    string public name;
    string public symbol;

    constructor(string memory uri_) ERC1155(uri_) {
        name = "Physical Gold";
        symbol = "PGOLD";
    }

    function mint(address account, uint256 tokenId, uint256 amount) external onlyOwner {
        require(_isSupportedTokenId(tokenId), "unsupported token id");
        _mint(account, tokenId, amount, "");
    }

    function mintBatch(address account, uint256[] calldata tokenIds, uint256[] calldata amounts) external onlyOwner {
        uint256 length = tokenIds.length;
        require(length == amounts.length, "length mismatch");
        for (uint256 i; i < length; ++i) {
            require(_isSupportedTokenId(tokenIds[i]), "unsupported token id");
        }
        _mintBatch(account, tokenIds, amounts, "");
    }

    function burn(address account, uint256 tokenId, uint256 amount) external onlyOwner {
        _burn(account, tokenId, amount);
    }

    function burnBatch(address account, uint256[] calldata tokenIds, uint256[] calldata amounts) external onlyOwner {
        _burnBatch(account, tokenIds, amounts);
    }

    function _isSupportedTokenId(uint256 tokenId) internal pure returns (bool) {
        return tokenId == PAXG_TOKEN_ID || tokenId == XAUT_TOKEN_ID;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
