// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

/// @notice Route-aware Phase 1 GOLD claim token.
/// @dev GILT is native gas/staking token. This contract only represents GOLD backing claims.
contract GoldRouteToken is ERC1155, ERC1155Supply, AccessControl {
    uint256 public constant PAXG_ROUTE_ID = 1;
    uint256 public constant XAUT_ROUTE_ID = 2;

    bytes32 public constant BRIDGE_MINTER_ROLE = keccak256("BRIDGE_MINTER_ROLE");
    bytes32 public constant RESERVE_MINTER_ROLE = keccak256("RESERVE_MINTER_ROLE");
    bytes32 public constant MIGRATION_CONTROLLER_ROLE = keccak256("MIGRATION_CONTROLLER_ROLE");

    string public name = "Gold Route Claim";
    string public symbol = "GOLD-ROUTE";

    error InvalidRoute(uint256 routeId);
    error ZeroAddress();
    error ZeroAmount();

    constructor(string memory uri_, address admin_) ERC1155(uri_) {
        if (admin_ == address(0)) revert ZeroAddress();
        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
    }

    function mintBridgeClaim(address to, uint256 routeId, uint256 amount) external onlyRole(BRIDGE_MINTER_ROLE) {
        _requireRoute(routeId);
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        _mint(to, routeId, amount, "");
    }

    function burnBridgeClaim(address from, uint256 routeId, uint256 amount) external onlyRole(BRIDGE_MINTER_ROLE) {
        _requireRoute(routeId);
        if (from == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        _burn(from, routeId, amount);
    }

    function mintReserveBackedGold(address to, uint256 amount) external onlyRole(RESERVE_MINTER_ROLE) {
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        // Reserve-backed GOLD intentionally uses a separate route ID outside legacy bridge IDs.
        _mint(to, 100, amount, "");
    }

    function migrationBurn(address from, uint256 routeId, uint256 amount) external onlyRole(MIGRATION_CONTROLLER_ROLE) {
        _requireRoute(routeId);
        if (from == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        _burn(from, routeId, amount);
    }

    function _requireRoute(uint256 routeId) internal pure {
        if (routeId != PAXG_ROUTE_ID && routeId != XAUT_ROUTE_ID) revert InvalidRoute(routeId);
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

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
