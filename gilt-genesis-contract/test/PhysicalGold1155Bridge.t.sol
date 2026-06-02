pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "../contracts/PhysicalGold1155.sol";

contract PhysicalGold1155BridgeTest is Test {
    PhysicalGold1155 internal gold;
    address internal bridgeDepositor = address(0xBEEF);
    address internal user = address(0xCAFE);
    address internal rootRecipient = address(0xABCD);
    address internal migrationController = address(0xD00D);
    uint256 internal constant ONE_XAUT_ROOT_UNIT = 1_000_000;

    event GoldRedemptionRequested(
        address indexed redeemer,
        address indexed recipient,
        uint256 indexed tokenId,
        uint256 goldAmount,
        uint256 rootReleaseAmount
    );
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

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
        (bool ok,) = address(gold)
            .call(abi.encodeWithSignature("setBridgeConfig(address,uint256,uint256)", bridgeDepositor, 1000, 1));
        assertFalse(ok, "setBridgeConfig must not exist");
    }

    function testArbitraryIssuanceMintFunctionsAreNotCallable() public {
        (bool mintOk,) = address(gold).call(abi.encodeWithSignature("mint(address,uint256,uint256)", user, 1, 1));
        assertFalse(mintOk, "mint must not exist");

        (bool issuanceOk,) = address(gold)
            .call(abi.encodeWithSignature("mintForIssuance(address,uint256,uint256,bytes32)", user, 1, 1, bytes32(0)));
        assertFalse(issuanceOk, "mintForIssuance must not exist");
    }

    function testAdminBurnFunctionsAreNotCallable() public {
        uint256[] memory tokenIds = new uint256[](1);
        uint256[] memory amounts = new uint256[](1);
        tokenIds[0] = gold.PAXG_TOKEN_ID();
        amounts[0] = 1 ether;

        (bool burnOk,) =
            address(gold).call(abi.encodeWithSignature("burn(address,uint256,uint256)", user, tokenIds[0], amounts[0]));
        assertFalse(burnOk, "admin burn must not exist");

        (bool burnBatchOk,) = address(gold).call(
            abi.encodeWithSignature("burnBatch(address,uint256[],uint256[])", user, tokenIds, amounts)
        );
        assertFalse(burnBatchOk, "admin burnBatch must not exist");
    }

    function testSetBridgeDepositorRotatesBridgeOperatorWithoutChangingMath() public {
        address nextBridgeDepositor = address(0xDEAD);
        uint256 tokenId = gold.PAXG_TOKEN_ID();

        gold.setBridgeDepositor(nextBridgeDepositor);
        gold.finalizeBridgeRoutePrecision();
        assertEq(gold.bridgeScaleNumerator(), 1000, "ratio numerator changed");
        assertEq(gold.bridgeScaleDenominator(), 1, "ratio denominator changed");

        vm.prank(bridgeDepositor);
        vm.expectRevert("only bridge depositor");
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        vm.prank(nextBridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));
        assertEq(gold.balanceOf(user, tokenId), 1000 ether, "rotated depositor should mint at fixed ratio");
    }

    function testBridgeRoutePrecisionCanBeConfiguredBeforeFinalization() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();

        gold.setBridgeRoutePrecision(tokenId, 18, 18, 2000, 1, 1);

        vm.prank(bridgeDepositor);
        vm.expectRevert("bridge route precision not finalized");
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));
        assertEq(gold.balanceOf(user, tokenId), 2000 ether);
    }

    function testBridgeRoutePrecisionFinalizationPreventsLaterChanges() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        uint256 xautTokenId = gold.XAUT_TOKEN_ID();

        gold.finalizeBridgeRoutePrecision();
        assertTrue(gold.bridgeRoutePrecisionFinalized());

        vm.expectRevert("bridge route precision finalized");
        gold.setBridgeRoutePrecision(tokenId, 18, 18, 2000, 1, 1);

        vm.expectRevert("bridge route precision finalized");
        gold.setBridgeRoutePrecision(xautTokenId, 6, 18, 2000 * (10 ** 12), 1, 1);
    }

    function testBridgeRoutePrecisionFinalizationIsIrreversible() public {
        gold.finalizeBridgeRoutePrecision();

        vm.expectRevert("bridge route precision finalized");
        gold.finalizeBridgeRoutePrecision();
    }

    function testBridgeRoutePrecisionFinalizesPaxgAndXautRoutes() public {
        assertEq(gold.PAXG_TOKEN_ID(), 1, "PAXG-backed GOLD must be ID 1");
        assertEq(gold.XAUT_TOKEN_ID(), 2, "XAUT-backed GOLD must be ID 2");

        gold.finalizeBridgeRoutePrecision();

        (
            bool paxgEnabled,
            uint8 paxgRootDecimals,
            uint8 paxgGoldDecimals,
            uint256 paxgScaleNumerator,
            uint256 paxgScaleDenominator,
            uint256 paxgRootUnit
        ) = gold.bridgeRoutePrecision(gold.PAXG_TOKEN_ID());
        (
            bool xautEnabled,
            uint8 xautRootDecimals,
            uint8 xautGoldDecimals,
            uint256 xautScaleNumerator,
            uint256 xautScaleDenominator,
            uint256 xautRootUnit
        ) = gold.bridgeRoutePrecision(gold.XAUT_TOKEN_ID());

        assertTrue(paxgEnabled, "PAXG route not enabled");
        assertEq(paxgRootDecimals, 18, "wrong PAXG root decimals");
        assertEq(paxgGoldDecimals, 18, "wrong PAXG GOLD decimals");
        assertEq(paxgScaleNumerator, 1000, "wrong PAXG scale numerator");
        assertEq(paxgScaleDenominator, 1, "wrong PAXG scale denominator");
        assertEq(paxgRootUnit, 1, "wrong PAXG root unit");

        assertTrue(xautEnabled, "XAUT route not enabled");
        assertEq(xautRootDecimals, 6, "wrong XAUT root decimals");
        assertEq(xautGoldDecimals, 18, "wrong XAUT GOLD decimals");
        assertEq(xautScaleNumerator, 1000 * (10 ** 12), "wrong XAUT scale numerator");
        assertEq(xautScaleDenominator, 1, "wrong XAUT scale denominator");
        assertEq(xautRootUnit, 1, "wrong XAUT root unit");
    }

    function testBridgeRoutePrecisionFinalizationRejectsInvalidXautPrecision() public {
        gold.setBridgeRoutePrecision(gold.XAUT_TOKEN_ID(), 18, 18, 1000, 1, 1);

        vm.expectRevert("invalid XAUT route precision");
        gold.finalizeBridgeRoutePrecision();
    }

    function testBridgeDepositMintsScaledAmount() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 2 ether));

        assertEq(gold.balanceOf(user, tokenId), 2000 ether);
    }

    function testBridgeDepositRequiresConfiguredDepositor() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.expectRevert("only bridge depositor");
        gold.deposit(user, abi.encode(tokenId, 1 ether));
    }

    function testBridgeDepositRejectsBeforeRouteFinalization() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();

        vm.prank(bridgeDepositor);
        vm.expectRevert("bridge route precision not finalized");
        gold.deposit(user, abi.encode(tokenId, 1 ether));
    }

    function testWithdrawSingleRejectsBeforeRouteFinalization() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        gold.setMigrationController(migrationController);
        vm.prank(migrationController);
        gold.setMigrationMintingEnabled(true);
        vm.prank(migrationController);
        gold.mintForMigration(user, tokenId, 1 ether, bytes32("seed"));

        vm.prank(user);
        vm.expectRevert("bridge route precision not finalized");
        gold.withdrawSingle(tokenId, 1 ether);
    }

    function testSetBridgeDepositorRejectsZeroAddress() public {
        vm.expectRevert("invalid bridge depositor");
        gold.setBridgeDepositor(address(0));
    }

    function testMigrationMintingIsOffAtLaunch() public {
        assertFalse(gold.migrationMintingEnabled(), "migration minting must launch off");
        assertFalse(gold.migrationMintingFinalized(), "migration minting should not launch finalized");
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

    function testWithdrawSingleBurnsExactAmountAndEmitsRedemptionRequestForXaut() public {
        uint256 tokenId = gold.XAUT_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, ONE_XAUT_ROOT_UNIT));
        assertEq(gold.balanceOf(user, tokenId), 1000 ether, "wrong XAUT scaled mint");

        vm.expectEmit(true, true, true, true);
        emit TransferSingle(user, user, address(0), tokenId, 1000 ether);
        vm.expectEmit(true, true, true, true);
        emit GoldRedemptionRequested(user, rootRecipient, tokenId, 1000 ether, ONE_XAUT_ROOT_UNIT);
        vm.prank(user);
        gold.withdrawSingle(tokenId, 1000 ether, rootRecipient);

        assertEq(gold.balanceOf(user, tokenId), 0);
    }

    function testWithdrawSingleDefaultsRecipientToRedeemerForPaxg() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        vm.expectEmit(true, true, true, true);
        emit TransferSingle(user, user, address(0), tokenId, 1000 ether);
        vm.expectEmit(true, true, true, true);
        emit GoldRedemptionRequested(user, user, tokenId, 1000 ether, 1 ether);
        vm.prank(user);
        gold.withdrawSingle(tokenId, 1000 ether);

        assertEq(gold.balanceOf(user, tokenId), 0);
    }

    function testCloseBridgeDepositsStopsNewOldGoldMintingButKeepsWithdrawOpen() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        gold.closeBridgeDeposits();
        assertTrue(gold.bridgeDepositsClosed());

        vm.prank(bridgeDepositor);
        vm.expectRevert("bridge deposits closed");
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        vm.prank(user);
        gold.withdrawSingle(tokenId, 1000 ether);
        assertEq(gold.balanceOf(user, tokenId), 0);
    }

    function testMigrationControllerCanCloseBridgeDeposits() public {
        gold.setMigrationController(migrationController);

        vm.prank(migrationController);
        gold.closeBridgeDeposits();

        assertTrue(gold.bridgeDepositsClosed(), "bridge deposits should be closed");
    }

    function testCloseBridgeDepositsIsIrreversible() public {
        gold.closeBridgeDeposits();

        vm.expectRevert("bridge deposits closed");
        gold.closeBridgeDeposits();
    }

    function testCloseBridgeDepositsDoesNotBlockWithdrawSingleRedemption() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        gold.closeBridgeDeposits();
        vm.prank(user);
        gold.withdrawSingle(tokenId, 1000 ether);

        assertEq(gold.balanceOf(user, tokenId), 0);
    }

    function testWithdrawSingleRejectsZeroRecipient() public {
        uint256 tokenId = gold.PAXG_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, 1 ether));

        vm.expectRevert("invalid recipient");
        vm.prank(user);
        gold.withdrawSingle(tokenId, 1000 ether, address(0));
    }

    function testWithdrawSingleRejectsNonExactAmount() public {
        uint256 tokenId = gold.XAUT_TOKEN_ID();
        gold.finalizeBridgeRoutePrecision();

        vm.prank(bridgeDepositor);
        gold.deposit(user, abi.encode(tokenId, ONE_XAUT_ROOT_UNIT));

        vm.expectRevert("non exact withdraw");
        vm.prank(user);
        gold.withdrawSingle(tokenId, 999 ether + 1);
    }
}
