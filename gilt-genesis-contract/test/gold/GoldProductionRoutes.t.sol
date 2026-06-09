// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/gold/GoldRouteToken.sol";
import "../../contracts/gold/GoldPhaseRegistry.sol";
import "../../contracts/gold/GoldBridgeMinter.sol";
import "../../contracts/gold/ReserveGoldController.sol";
import "../../contracts/gold/GoldMigrationController.sol";

contract GoldProductionRoutesTest is Test {
    address admin = address(0xA11CE);
    address user = address(0xB0B);

    GoldRouteToken gold;
    GoldPhaseRegistry phases;
    GoldBridgeMinter bridgeMinter;
    ReserveGoldController reserve;
    GoldMigrationController migration;

    function setUp() public {
        vm.startPrank(admin);
        gold = new GoldRouteToken("", admin);
        phases = new GoldPhaseRegistry(admin);
        bridgeMinter = new GoldBridgeMinter(gold, phases, admin);
        reserve = new ReserveGoldController(gold, 1_000_000 ether, admin);
        migration = new GoldMigrationController(gold, phases, reserve, admin);

        gold.grantRole(gold.BRIDGE_MINTER_ROLE(), address(bridgeMinter));
        gold.grantRole(gold.RESERVE_MINTER_ROLE(), address(reserve));
        gold.grantRole(gold.MIGRATION_CONTROLLER_ROLE(), address(migration));
        reserve.grantRole(reserve.RESERVE_ISSUER_ROLE(), address(migration));
        vm.stopPrank();
    }

    function testPaxgAndXautRoutesMintSeparatelyAndBurnOnlyOwnRoute() public {
        bytes32 paxgDeposit = keccak256("paxg deposit");
        bytes32 xautDeposit = keccak256("xaut deposit");
        uint256 paxgRouteId = gold.PAXG_ROUTE_ID();
        uint256 xautRouteId = gold.XAUT_ROUTE_ID();

        vm.startPrank(admin);
        bridgeMinter.finalizeDeposit(paxgDeposit, paxgRouteId, 10 ether, user);
        bridgeMinter.finalizeDeposit(xautDeposit, xautRouteId, 20 ether, user);
        vm.stopPrank();

        assertEq(gold.balanceOf(user, paxgRouteId), 10 ether);
        assertEq(gold.balanceOf(user, xautRouteId), 20 ether);

        vm.prank(admin);
        bridgeMinter.burnForWithdrawal(user, paxgRouteId, 4 ether);

        assertEq(gold.balanceOf(user, paxgRouteId), 6 ether);
        assertEq(gold.balanceOf(user, xautRouteId), 20 ether);
    }

    function testDepositReplayIsRejected() public {
        bytes32 depositId = keccak256("deposit");
        uint256 paxgRouteId = gold.PAXG_ROUTE_ID();

        vm.prank(admin);
        bridgeMinter.finalizeDeposit(depositId, paxgRouteId, 1 ether, user);

        vm.expectRevert(abi.encodeWithSelector(GoldBridgeMinter.AlreadyProcessed.selector, depositId));
        vm.prank(admin);
        bridgeMinter.finalizeDeposit(depositId, paxgRouteId, 1 ether, user);
    }

    function testBridgeDepositsStopButWithdrawalsStillWork() public {
        uint256 paxgRouteId = gold.PAXG_ROUTE_ID();

        vm.prank(admin);
        bridgeMinter.finalizeDeposit(keccak256("deposit"), paxgRouteId, 10 ether, user);

        vm.startPrank(admin);
        phases.setPhase(GoldPhaseRegistry.GoldPhase.MigrationAnnounced);
        phases.setPhase(GoldPhaseRegistry.GoldPhase.BridgeDepositsStopped);
        vm.stopPrank();

        vm.expectRevert(GoldPhaseRegistry.DepositsClosed.selector);
        vm.prank(admin);
        bridgeMinter.finalizeDeposit(keccak256("blocked"), paxgRouteId, 1 ether, user);

        vm.prank(admin);
        bridgeMinter.burnForWithdrawal(user, paxgRouteId, 3 ether);

        assertEq(gold.balanceOf(user, paxgRouteId), 7 ether);
    }

    function testMigrationBurnsLegacyClaimAndMintsReserveBackedGold() public {
        uint256 xautRouteId = gold.XAUT_ROUTE_ID();

        vm.prank(admin);
        bridgeMinter.finalizeDeposit(keccak256("deposit"), xautRouteId, 5 ether, user);

        vm.startPrank(admin);
        phases.setPhase(GoldPhaseRegistry.GoldPhase.MigrationAnnounced);
        phases.setPhase(GoldPhaseRegistry.GoldPhase.BridgeDepositsStopped);
        phases.setPhase(GoldPhaseRegistry.GoldPhase.MigrationOpen);
        migration.migrateLegacyClaim(keccak256("migration ref"), user, xautRouteId, 5 ether);
        vm.stopPrank();

        assertEq(gold.balanceOf(user, xautRouteId), 0);
        assertEq(gold.balanceOf(user, 100), 5 ether);
    }
}
