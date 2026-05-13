pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../contracts/PhysicalGold1155.sol";

contract PhysicalGold1155BridgeTest is Test {
    PhysicalGold1155 internal gold;
    address internal bridgeDepositor = address(0xBEEF);
    address internal user = address(0xCAFE);
    address internal migrationController = address(0xD00D);

    function setUp() public {
        gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        gold.setBridgeDepositor(bridgeDepositor);
    }

    function testConstructorRejectsZeroRatio() public {
        vm.expectRevert("invalid bridge ratio");
        new PhysicalGold1155("ipfs://gold/{id}.json", 0, 1, address(this));

        vm.expectRevert("invalid bridge ratio");
        new PhysicalGold1155("ipfs://gold/{id}.json", 1, 0, address(this));
    }

    function testBridgeRatioSetterIsNotCallable() public {
        (bool ok,) = address(gold).call(
            abi.encodeWithSignature("setBridgeConfig(address,uint256,uint256)", bridgeDepositor, 1000, 1)
        );
        assertFalse(ok, "setBridgeConfig must not exist");
    }

    function testArbitraryIssuanceMintFunctionsAreNotCallable() public {
        (bool mintOk,) = address(gold).call(abi.encodeWithSignature("mint(address,uint256,uint256)", user, 1, 1));
        assertFalse(mintOk, "mint must not exist");

        (bool issuanceOk,) = address(gold).call(
            abi.encodeWithSignature("mintForIssuance(address,uint256,uint256,bytes32)", user, 1, 1, bytes32(0))
        );
        assertFalse(issuanceOk, "mintForIssuance must not exist");
    }

    function testSetBridgeDepositorRotatesBridgeOperatorWithoutChangingMath() public {
        address nextBridgeDepositor = address(0xDEAD);
        uint256 tokenId = gold.PAXG_TOKEN_ID();

        gold.setBridgeDepositor(nextBridgeDepositor);
        assertEq(gold.bridgeScaleNumerator(), 1000, "ratio numerator changed");
        assertEq(gold.bridgeScaleDenominator(), 1, "ratio denominator changed");

        vm.prank(bridgeDepositor);
        vm.expectRevert("only bridge depositor");
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        vm.prank(nextBridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));
        assertEq(gold.balanceOf(user, tokenId), 1000 ether, "rotated depositor should mint at fixed ratio");
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

    function testSetBridgeDepositorRejectsZeroAddress() public {
        vm.expectRevert("invalid bridge depositor");
        gold.setBridgeDepositor(address(0));
    }

    function testMigrationMintRequiresControllerAndEnabledFlag() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();

        vm.prank(migrationController);
        vm.expectRevert("only migration controller");
        gold.mintForMigration(user, tokenId, 1 ether, bytes32("m1"));

        gold.setMigrationController(migrationController);

        vm.prank(migrationController);
        vm.expectRevert("migration minting disabled");
        gold.mintForMigration(user, tokenId, 1 ether, bytes32("m2"));

        vm.prank(migrationController);
        gold.setMigrationMintingEnabled(true);
        vm.prank(migrationController);
        gold.mintForMigration(user, tokenId, 1 ether, bytes32("m3"));
        assertEq(gold.balanceOf(user, tokenId), 1 ether);
    }

    function testFinalizeMigrationMintingIsIrreversible() public {
        gold.setMigrationController(migrationController);
        vm.prank(migrationController);
        gold.setMigrationMintingEnabled(true);
        vm.prank(migrationController);
        gold.finalizeMigrationMinting();

        vm.prank(migrationController);
        vm.expectRevert("migration minting finalized");
        gold.setMigrationMintingEnabled(true);
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
