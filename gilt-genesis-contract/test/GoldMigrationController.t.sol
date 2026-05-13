pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../contracts/GoldMigrationController.sol";
import "../contracts/LegacyGoldReserveVault.sol";
import "../contracts/PhysicalGold1155.sol";

contract GoldMigrationControllerTest is Test {
    address internal constant GOV_HUB_ADDR = 0x0000000000000000000000000000000000001007;

    function testInactiveStateRejectsWalletMigration() public {
        GoldMigrationController controller = new GoldMigrationController();
        vm.expectRevert(abi.encodeWithSelector(GoldMigrationController.InvalidState.selector, 2, 0));
        controller.migrateWallet(1, 1 ether);
    }

    function testLifecycleAndStakeMigrationCounters() public {
        PhysicalGold1155 legacyGold = new PhysicalGold1155("ipfs://legacy/{id}.json", 1, 1, address(this));
        PhysicalGold1155 finalGold = new PhysicalGold1155("ipfs://new/{id}.json", 1, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        GoldMigrationController controller = new GoldMigrationController();

        address stakeHubCaller = address(0x2002);
        address delegator = address(0x1234);
        uint256 tokenId = legacyGold.PAXG_TOKEN_ID();
        uint256 amount = 21 ether;

        finalGold.setMigrationController(address(controller));
        legacyGold.setBridgeDepositor(address(this));
        legacyGold.deposit(stakeHubCaller, abi.encode(tokenId, amount));

        vm.startPrank(stakeHubCaller);
        legacyGold.setApprovalForAll(address(controller), true);
        vm.stopPrank();

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(legacyGold), address(finalGold), address(reserveVault), stakeHubCaller);
        controller.activateMigration();
        vm.stopPrank();

        vm.prank(stakeHubCaller);
        controller.migrateStake(delegator, tokenId, amount);

        assertEq(legacyGold.balanceOf(address(reserveVault), tokenId), amount, "reserve should capture legacy gold");
        assertEq(finalGold.balanceOf(stakeHubCaller, tokenId), amount, "stake hub caller should receive final gold");
        assertEq(controller.legacyCapturedById(tokenId), amount, "wrong captured counter");
        assertEq(controller.finalMintedById(tokenId), amount, "wrong minted counter");
        assertEq(controller.totalLegacyCaptured(), amount, "wrong total captured");
        assertEq(controller.totalFinalMinted(), amount, "wrong total minted");
    }

    function testExitOnlyAndFinalizeLifecycle() public {
        PhysicalGold1155 legacyGold = new PhysicalGold1155("ipfs://legacy/{id}.json", 1, 1, address(this));
        PhysicalGold1155 finalGold = new PhysicalGold1155("ipfs://new/{id}.json", 1, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        GoldMigrationController controller = new GoldMigrationController();
        finalGold.setMigrationController(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(legacyGold), address(finalGold), address(reserveVault), address(0x2002));
        controller.activateMigration();
        controller.setExitOnly(block.number + 10);
        vm.roll(block.number + 11);
        controller.finalizeMigration();
        vm.stopPrank();

        assertEq(uint8(controller.lifecycleState()), uint8(GoldMigrationController.LifecycleState.FINALIZED));
    }

    function testFinalizedStateRejectsWalletMigration() public {
        PhysicalGold1155 legacyGold = new PhysicalGold1155("ipfs://legacy/{id}.json", 1, 1, address(this));
        PhysicalGold1155 finalGold = new PhysicalGold1155("ipfs://new/{id}.json", 1, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        GoldMigrationController controller = new GoldMigrationController();
        finalGold.setMigrationController(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(legacyGold), address(finalGold), address(reserveVault), address(0x2002));
        controller.activateMigration();
        controller.setExitOnly(block.number + 2);
        vm.roll(block.number + 3);
        controller.finalizeMigration();
        vm.stopPrank();

        vm.expectRevert(
            abi.encodeWithSelector(
                GoldMigrationController.InvalidState.selector,
                GoldMigrationController.LifecycleState.ACTIVE,
                GoldMigrationController.LifecycleState.FINALIZED
            )
        );
        controller.migrateWallet(1, 1 ether);
    }
}
