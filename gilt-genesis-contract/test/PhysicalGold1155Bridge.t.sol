pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../contracts/PhysicalGold1155.sol";

contract PhysicalGold1155BridgeTest is Test {
    PhysicalGold1155 internal gold;
    address internal owner = address(this);
    address internal bridgeDepositor = address(0xBEEF);
    address internal user = address(0xCAFE);

    function setUp() public {
        gold = new PhysicalGold1155("ipfs://gold/{id}.json");
        gold.setBridgeConfig(bridgeDepositor, 1000, 1);
    }

    function testBridgeDepositMintsScaledAmount() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 2 ether));

        assertEq(gold.balanceOf(user, tokenId), 2000 ether);
    }

    function testBridgeDepositRequiresConfiguredDepositor() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        vm.expectRevert("only bridge depositor");
        gold.deposit(user, abi.encode(tokenId, 1 ether));
    }

    function testWithdrawSingleBurnsExactAmount() public {
        uint256 tokenId = gold.XAUT_TOKEN_ID();
        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        vm.prank(user);
        gold.withdrawSingle(tokenId, 1000 ether);

        assertEq(gold.balanceOf(user, tokenId), 0);
    }

    function testWithdrawSingleRejectsNonExactAmount() public {
        uint256 tokenId = gold.XAUT_TOKEN_ID();
        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        vm.expectRevert("non exact withdraw");
        vm.prank(user);
        gold.withdrawSingle(tokenId, 999 ether + 1);
    }
}
