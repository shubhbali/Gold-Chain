pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../contracts/GoldMigrationSwap.sol";
import "../contracts/LegacyGoldReserveVault.sol";
import "../contracts/PhysicalGoldToken.sol";
import "./utils/test_token/MiniToken.sol";

contract GoldMigrationSwapTest is Test {
    function testSwapMovesLegacyGoldToReserveAndPaysNewGold() public {
        MiniToken legacyGold = new MiniToken();
        PhysicalGoldToken newGold = new PhysicalGoldToken("Physical Gold", "PGOLD");
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        GoldMigrationSwap swap = new GoldMigrationSwap(address(legacyGold), address(newGold), address(reserveVault));

        address user = address(0x1234);
        uint256 amount = 50 ether;

        legacyGold.transfer(user, amount);
        newGold.mint(address(swap), amount);

        vm.startPrank(user);
        legacyGold.approve(address(swap), amount);
        swap.swap(amount);
        vm.stopPrank();

        assertEq(legacyGold.balanceOf(address(reserveVault)), amount, "reserve should receive legacy gold");
        assertEq(newGold.balanceOf(user), amount, "user should receive new gold");
        assertEq(legacyGold.balanceOf(user), 0, "user legacy balance should be spent");
    }
}
