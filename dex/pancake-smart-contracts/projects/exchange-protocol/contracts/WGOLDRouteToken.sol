// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract WGOLDRouteToken is ERC20, ERC1155Holder {
    uint256 public immutable routeTokenId;
    IERC1155 public immutable wrappedGold;

    event WrappedRoute(address indexed account, uint256 indexed tokenId, uint256 amount);
    event UnwrappedRoute(address indexed account, uint256 indexed tokenId, uint256 amount);

    constructor(
        address wrappedGold_,
        uint256 routeTokenId_,
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
        require(wrappedGold_ != address(0), "WGOLDRouteToken: invalid wrapper");
        require(routeTokenId_ == 1 || routeTokenId_ == 2, "WGOLDRouteToken: invalid tokenId");
        wrappedGold = IERC1155(wrappedGold_);
        routeTokenId = routeTokenId_;
    }

    function wrap(uint256 amount) external {
        require(amount != 0, "WGOLDRouteToken: invalid amount");
        wrappedGold.safeTransferFrom(msg.sender, address(this), routeTokenId, amount, "");
        _mint(msg.sender, amount);
        emit WrappedRoute(msg.sender, routeTokenId, amount);
    }

    function unwrap(uint256 amount) external {
        require(amount != 0, "WGOLDRouteToken: invalid amount");
        _burn(msg.sender, amount);
        wrappedGold.safeTransferFrom(address(this), msg.sender, routeTokenId, amount, "");
        emit UnwrappedRoute(msg.sender, routeTokenId, amount);
    }
}
