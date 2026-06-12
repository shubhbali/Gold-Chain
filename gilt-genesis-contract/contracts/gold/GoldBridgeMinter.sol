// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./GoldRouteToken.sol";
import "./GoldPhaseRegistry.sol";

contract GoldBridgeMinter is AccessControl {
    bytes32 public constant CHILD_BRIDGE_ROLE = keccak256("CHILD_BRIDGE_ROLE");

    GoldRouteToken public immutable gold;
    GoldPhaseRegistry public immutable phases;

    mapping(bytes32 => bool) public processedDeposits;

    event BridgeClaimMinted(bytes32 indexed depositId, address indexed recipient, uint256 indexed routeId, uint256 amount);
    event BridgeClaimBurned(address indexed account, uint256 indexed routeId, uint256 amount);

    error AlreadyProcessed(bytes32 depositId);
    error InvalidAmount();
    error InvalidRecipient();
    error WithdrawalsClosed();

    constructor(GoldRouteToken gold_, GoldPhaseRegistry phases_, address admin_) {
        require(address(gold_) != address(0), "invalid gold");
        require(address(phases_) != address(0), "invalid phases");
        require(admin_ != address(0), "invalid admin");
        gold = gold_;
        phases = phases_;
        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
    }

    function finalizeDeposit(bytes32 depositId, uint256 routeId, uint256 amount, address recipient)
        external
        onlyRole(CHILD_BRIDGE_ROLE)
    {
        phases.requireBridgeDepositOpen();
        if (processedDeposits[depositId]) revert AlreadyProcessed(depositId);
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        processedDeposits[depositId] = true;
        gold.mintBridgeClaim(recipient, routeId, amount);
        emit BridgeClaimMinted(depositId, recipient, routeId, amount);
    }

    function burnForWithdrawal(address account, uint256 routeId, uint256 amount) external onlyRole(CHILD_BRIDGE_ROLE) {
        if (!phases.withdrawalsEnabled()) revert WithdrawalsClosed();
        if (amount == 0) revert InvalidAmount();
        gold.burnBridgeClaim(account, routeId, amount);
        emit BridgeClaimBurned(account, routeId, amount);
    }
}
