pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../contracts/GoldMigrationController.sol";
import "../contracts/GoldMigrationSwap1155.sol";
import "../contracts/LegacyGoldReserveVault.sol";
import "../contracts/PhysicalGold1155.sol";

contract GoldMigrationSwap1155Test is Test {
    address internal constant GOV_HUB_ADDR = 0x0000000000000000000000000000000000001007;

    function testSwapRoutesToControllerAndMintsNewGoldById() public {
        PhysicalGold1155 legacyGold = new PhysicalGold1155("ipfs://legacy/{id}.json", 1, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        GoldMigrationController controller = new GoldMigrationController();
        newGold.setMigrationController(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(legacyGold), address(newGold), address(reserveVault), address(0x2002));
        vm.stopPrank();

        GoldMigrationSwap1155 swap = new GoldMigrationSwap1155(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.setWalletMigrationRouter(address(swap));
        controller.activateMigration();
        vm.stopPrank();
        swap.setSwapEnabled(true);

        address user = address(0x1234);
        uint256 paxgTokenId = legacyGold.PAXG_TOKEN_ID();
        uint256 xautTokenId = legacyGold.XAUT_TOKEN_ID();
        uint256 paxgAmount = 50 ether;
        uint256 xautAmount = 20 ether;

        legacyGold.setBridgeDepositor(address(this));
        legacyGold.deposit(user, abi.encode(paxgTokenId, paxgAmount));
        legacyGold.deposit(user, abi.encode(xautTokenId, xautAmount));
        vm.startPrank(user);
        legacyGold.setApprovalForAll(address(controller), true);
        swap.swap(paxgTokenId, paxgAmount);
        swap.swap(xautTokenId, xautAmount);
        vm.stopPrank();

        assertEq(
            legacyGold.balanceOf(address(reserveVault), paxgTokenId),
            paxgAmount,
            "reserve should receive PAXG-backed legacy gold"
        );
        assertEq(
            legacyGold.balanceOf(address(reserveVault), xautTokenId),
            xautAmount,
            "reserve should receive XAUT-backed legacy gold"
        );
        assertEq(newGold.balanceOf(user, paxgTokenId), paxgAmount, "user should receive new PAXG-backed gold");
        assertEq(newGold.balanceOf(user, xautTokenId), xautAmount, "user should receive new XAUT-backed gold");
        assertEq(legacyGold.balanceOf(user, paxgTokenId), 0, "user PAXG-backed legacy balance should be spent");
        assertEq(legacyGold.balanceOf(user, xautTokenId), 0, "user XAUT-backed legacy balance should be spent");
        assertEq(controller.legacyCapturedById(paxgTokenId), paxgAmount, "wrong tracked captured PAXG amount");
        assertEq(controller.legacyCapturedById(xautTokenId), xautAmount, "wrong tracked captured XAUT amount");
        assertEq(controller.finalMintedById(paxgTokenId), paxgAmount, "wrong tracked minted PAXG amount");
        assertEq(controller.finalMintedById(xautTokenId), xautAmount, "wrong tracked minted XAUT amount");
    }
}
