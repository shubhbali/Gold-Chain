pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../contracts/GoldMigrationSwap1155.sol";
import "../contracts/LegacyGoldReserveVault.sol";
import "../contracts/PhysicalGold1155.sol";

contract GoldMigrationSwap1155Test is Test {
    function testSwapMovesLegacyGoldToReserveAndPaysNewGoldById() public {
        PhysicalGold1155 legacyGold = new PhysicalGold1155("ipfs://legacy/{id}.json");
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json");
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        GoldMigrationSwap1155 swap =
            new GoldMigrationSwap1155(address(legacyGold), address(newGold), address(reserveVault));

        address user = address(0x1234);
        uint256 paxgTokenId = legacyGold.PAXG_TOKEN_ID();
        uint256 xautTokenId = legacyGold.XAUT_TOKEN_ID();
        uint256 paxgAmount = 50 ether;
        uint256 xautAmount = 20 ether;

        legacyGold.mint(user, paxgTokenId, paxgAmount);
        legacyGold.mint(user, xautTokenId, xautAmount);
        newGold.mint(address(swap), paxgTokenId, paxgAmount);
        newGold.mint(address(swap), xautTokenId, xautAmount);

        vm.startPrank(user);
        legacyGold.setApprovalForAll(address(swap), true);
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
    }
}
