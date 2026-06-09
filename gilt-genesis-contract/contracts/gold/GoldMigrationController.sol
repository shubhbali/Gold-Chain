// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./GoldRouteToken.sol";
import "./GoldPhaseRegistry.sol";
import "./ReserveGoldController.sol";

contract GoldMigrationController is AccessControl {
    bytes32 public constant MIGRATION_OPERATOR_ROLE = keccak256("MIGRATION_OPERATOR_ROLE");

    GoldRouteToken public immutable gold;
    GoldPhaseRegistry public immutable phases;
    ReserveGoldController public immutable reserveController;

    mapping(bytes32 => bool) public migratedRefs;

    event ClaimMigrated(bytes32 indexed migrationRef, address indexed account, uint256 indexed routeId, uint256 amount);

    error AlreadyMigrated(bytes32 migrationRef);
    error InvalidAmount();
    error InvalidAccount();

    constructor(GoldRouteToken gold_, GoldPhaseRegistry phases_, ReserveGoldController reserveController_, address admin_) {
        require(address(gold_) != address(0), "invalid gold");
        require(address(phases_) != address(0), "invalid phases");
        require(address(reserveController_) != address(0), "invalid reserve controller");
        require(admin_ != address(0), "invalid admin");
        gold = gold_;
        phases = phases_;
        reserveController = reserveController_;
        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
        _grantRole(MIGRATION_OPERATOR_ROLE, admin_);
    }

    function migrateLegacyClaim(bytes32 migrationRef, address account, uint256 routeId, uint256 amount)
        external
        onlyRole(MIGRATION_OPERATOR_ROLE)
    {
        phases.requireMigrationOpen();
        if (migratedRefs[migrationRef]) revert AlreadyMigrated(migrationRef);
        if (account == address(0)) revert InvalidAccount();
        if (amount == 0) revert InvalidAmount();
        migratedRefs[migrationRef] = true;

        // Burn old route claim first so it cannot later redeem PAXG/XAUT.
        gold.migrationBurn(account, routeId, amount);
        reserveController.mintReserveBackedGold(account, amount);
        emit ClaimMigrated(migrationRef, account, routeId, amount);
    }
}
