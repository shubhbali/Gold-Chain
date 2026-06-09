// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./GoldRouteToken.sol";

contract ReserveGoldController is AccessControl {
    bytes32 public constant RESERVE_ISSUER_ROLE = keccak256("RESERVE_ISSUER_ROLE");

    GoldRouteToken public immutable gold;
    uint256 public mintCap;
    uint256 public totalReserveMinted;
    bool public paused;
    bytes32 public latestReserveReportHash;

    event ReserveReportUpdated(bytes32 indexed reportHash);
    event ReserveMintCapUpdated(uint256 previousCap, uint256 newCap);
    event ReserveGoldMinted(address indexed recipient, uint256 amount, bytes32 indexed reportHash);
    event PauseSet(bool paused);

    error Paused();
    error CapExceeded();
    error InvalidAmount();
    error InvalidRecipient();

    constructor(GoldRouteToken gold_, uint256 mintCap_, address admin_) {
        require(address(gold_) != address(0), "invalid gold");
        require(admin_ != address(0), "invalid admin");
        gold = gold_;
        mintCap = mintCap_;
        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
        _grantRole(RESERVE_ISSUER_ROLE, admin_);
    }

    function setReserveReport(bytes32 reportHash) external onlyRole(DEFAULT_ADMIN_ROLE) {
        latestReserveReportHash = reportHash;
        emit ReserveReportUpdated(reportHash);
    }

    function setMintCap(uint256 newCap) external onlyRole(DEFAULT_ADMIN_ROLE) {
        emit ReserveMintCapUpdated(mintCap, newCap);
        mintCap = newCap;
    }

    function setPaused(bool paused_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        paused = paused_;
        emit PauseSet(paused_);
    }

    function mintReserveBackedGold(address recipient, uint256 amount) external onlyRole(RESERVE_ISSUER_ROLE) {
        if (paused) revert Paused();
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        if (totalReserveMinted + amount > mintCap) revert CapExceeded();
        totalReserveMinted += amount;
        gold.mintReserveBackedGold(recipient, amount);
        emit ReserveGoldMinted(recipient, amount, latestReserveReportHash);
    }
}
