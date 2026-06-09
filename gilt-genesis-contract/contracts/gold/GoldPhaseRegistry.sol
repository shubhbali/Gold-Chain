// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract GoldPhaseRegistry is AccessControl {
    enum GoldPhase {
        BridgeBacked,
        MigrationAnnounced,
        BridgeDepositsStopped,
        MigrationOpen,
        LegacyRedemptionOnly,
        LegacySunset
    }

    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    GoldPhase public phase;

    event PhaseChanged(GoldPhase indexed previousPhase, GoldPhase indexed newPhase);

    error InvalidTransition(GoldPhase currentPhase, GoldPhase nextPhase);
    error DepositsClosed();
    error MigrationNotOpen();

    constructor(address governance_) {
        require(governance_ != address(0), "invalid governance");
        _grantRole(DEFAULT_ADMIN_ROLE, governance_);
        _grantRole(GOVERNANCE_ROLE, governance_);
        phase = GoldPhase.BridgeBacked;
    }

    function setPhase(GoldPhase nextPhase) external onlyRole(GOVERNANCE_ROLE) {
        GoldPhase current = phase;
        if (!_isValidTransition(current, nextPhase)) revert InvalidTransition(current, nextPhase);
        phase = nextPhase;
        emit PhaseChanged(current, nextPhase);
    }

    function requireBridgeDepositOpen() external view {
        if (phase != GoldPhase.BridgeBacked && phase != GoldPhase.MigrationAnnounced) revert DepositsClosed();
    }

    function requireMigrationOpen() external view {
        if (phase != GoldPhase.MigrationOpen) revert MigrationNotOpen();
    }

    function withdrawalsEnabled() external view returns (bool) {
        return phase != GoldPhase.LegacySunset;
    }

    function _isValidTransition(GoldPhase current, GoldPhase next) internal pure returns (bool) {
        if (next == current) return false;
        if (uint8(next) != uint8(current) + 1) return false;
        return true;
    }
}
