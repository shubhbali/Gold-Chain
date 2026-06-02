pragma solidity ^0.8.10;

import "../contracts/GoldMigrationController.sol";
import "../contracts/LegacyGoldReserveVault.sol";
import "../contracts/PhysicalGold1155.sol";

import "./utils/Deployer.sol";
import "./utils/interface/IStakeCredit.sol";
import "./utils/interface/IStakeHub.sol";

contract GoldLaunchAcceptanceTest is Deployer {
    uint256 internal constant LAUNCH_REWARD_SPLIT_BPS = 2_000;
    uint256 internal constant LAUNCH_INFLATION_BASE_SUPPLY = 3_000_000_000 ether;

    receive() external payable { }

    function setUp() public {
        vm.mockCall(address(0x66), bytes(""), hex"01");
    }

    function testLaunchAcceptance_InflationGoldIdsRewardSplitAndMigrationOff() public {
        (address validator, address consensusAddress, address creditAddress,) = _createValidator(2000 ether);
        address payable credit = payable(creditAddress);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();

        _configureLaunchGoldStaking(gold, LAUNCH_REWARD_SPLIT_BPS);
        _configureLaunchInflation();

        assertEq(gold.PAXG_TOKEN_ID(), 1, "PAXG-backed GOLD token ID must be 1");
        assertEq(gold.XAUT_TOKEN_ID(), 2, "XAUT-backed GOLD token ID must be 2");
        assertEq(stakeHub.stakeTokenBPrimaryId(), paxgTokenId, "wrong PAXG-backed staking ID");
        assertEq(stakeHub.stakeTokenBSecondaryId(), gold.XAUT_TOKEN_ID(), "wrong XAUT-backed staking ID");
        assertEq(stakeHub.stakeTokenB(), address(gold), "GOLD staking token must be configured");
        assertEq(stakeHub.tokenBRewardSplitBps(), LAUNCH_REWARD_SPLIT_BPS, "wrong GOLD reward split");
        assertFalse(stakeHub.ratioEnabled(), "ratio enforcement must be off at launch");
        assertEq(stakeHub.tokenBMigrationController(), address(0), "migration controller must be off at launch");
        assertEq(stakeHub.legacyStakeTokenB(), address(0), "legacy GOLD must be unset at launch");
        assertEq(stakeHub.tokenBCutoverVersion(), 0, "migration cutover must be unset at launch");
        assertTrue(stakeHub.inflationEnabled(), "GILT inflation must be enabled at launch");
        assertEq(stakeHub.inflationBaseSupply(), LAUNCH_INFLATION_BASE_SUPPLY, "wrong inflation base supply");
        assertGt(
            stakeHub.expectedInflationMintAmount(block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL()),
            0,
            "launch inflation amount must be non-zero"
        );

        vm.startPrank(GOV_HUB_ADDR);
        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "stakeTokenBPrimaryId", abi.encode(uint256(3)))
        );
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(3)));
        vm.stopPrank();

        _mintAndDelegateGold(gold, validator, delegator, paxgTokenId, 100 ether);

        uint256 pooledBefore = StakeCredit(credit).totalPooledGILT();
        uint256 goldBalanceBefore = gold.balanceOf(delegator, paxgTokenId);
        uint256 reward = 50 ether;
        uint256 expectedGoldStakingReward = reward * LAUNCH_REWARD_SPLIT_BPS / 10_000;
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(consensusAddress);

        assertEq(
            stakeHub.pendingTokenBReward(validator, delegator),
            expectedGoldStakingReward,
            "wrong GOLD staking reward split"
        );
        assertEq(
            StakeCredit(credit).totalPooledGILT(),
            pooledBefore + reward - expectedGoldStakingReward,
            "GILT staking side must receive the remaining reward"
        );
        assertEq(gold.balanceOf(delegator, paxgTokenId), goldBalanceBefore, "GOLD staking must not mint GOLD rewards");
    }

    function testLaunchAcceptance_OldGoldDoesNotEarnRewardAfterMigrationCutover() public {
        (address validator, address consensusAddress,,) = _createValidator(2000 ether);
        address legacyDelegator = _getNextUserAddress();
        address activeDelegator = _getNextUserAddress();
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        uint256 paxgTokenId = oldGold.PAXG_TOKEN_ID();

        _configureLaunchGoldStaking(oldGold, LAUNCH_REWARD_SPLIT_BPS);
        _mintAndDelegateGold(oldGold, validator, legacyDelegator, paxgTokenId, 100 ether);
        _activateGoldMigration(oldGold, newGold, reserveVault);

        _mintAndDelegateGold(newGold, validator, activeDelegator, paxgTokenId, 100 ether);

        uint256 reward = 50 ether;
        uint256 expectedGoldStakingReward = reward * LAUNCH_REWARD_SPLIT_BPS / 10_000;
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(consensusAddress);

        assertEq(
            stakeHub.pendingTokenBReward(validator, legacyDelegator),
            0,
            "old GOLD must not accrue rewards after migration cutover"
        );
        assertEq(
            stakeHub.pendingTokenBReward(validator, activeDelegator),
            expectedGoldStakingReward,
            "active GOLD should receive the full post-migration reward split"
        );
    }

    function testLaunchAcceptance_RouteLockAndBridgeClosurePreserveWithdraw() public {
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        address redeemer = address(0xCAFE);
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();

        gold.setBridgeDepositor(address(this));
        gold.setBridgeRoutePrecision(paxgTokenId, 18, 18, 1000, 1, 1);
        gold.finalizeBridgeRoutePrecision();
        assertTrue(gold.bridgeRoutePrecisionFinalized(), "route precision must be locked");

        vm.expectRevert("bridge route precision finalized");
        gold.setBridgeRoutePrecision(paxgTokenId, 18, 18, 2000, 1, 1);

        gold.deposit(redeemer, abi.encode(paxgTokenId, 1 ether));
        gold.closeBridgeDeposits();
        assertTrue(gold.bridgeDepositsClosed(), "bridge deposits must be closed");

        vm.expectRevert("bridge deposits closed");
        gold.deposit(redeemer, abi.encode(paxgTokenId, 1 ether));

        vm.prank(redeemer);
        gold.withdrawSingle(paxgTokenId, 1000 ether);
        assertEq(gold.balanceOf(redeemer, paxgTokenId), 0, "withdraw must remain open after bridge closure");
    }

    function _configureLaunchGoldStaking(
        PhysicalGold1155 gold,
        uint256 rewardSplitBps
    ) internal {
        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(gold.PAXG_TOKEN_ID()));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(gold.XAUT_TOKEN_ID()));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("tokenBRewardSplitBps", abi.encode(rewardSplitBps));
        vm.stopPrank();
    }

    function _configureLaunchInflation() internal {
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();
        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(LAUNCH_INFLATION_BASE_SUPPLY));
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        stakeHub.updateParam("inflationEnabled", hex"01");
        vm.stopPrank();
    }

    function _mintAndDelegateGold(
        PhysicalGold1155 gold,
        address validator,
        address delegator,
        uint256 tokenId,
        uint256 amount
    ) internal {
        _bridgeMintGold(gold, delegator, tokenId, amount);
        vm.startPrank(delegator);
        gold.setApprovalForAll(address(stakeHub), true);
        stakeHub.delegateTokenB1155(validator, tokenId, amount);
        vm.stopPrank();
    }

    function _bridgeMintGold(
        PhysicalGold1155 gold,
        address account,
        uint256 tokenId,
        uint256 amount
    ) internal {
        gold.setBridgeDepositor(address(this));
        if (!gold.bridgeRoutePrecisionFinalized()) {
            gold.finalizeBridgeRoutePrecision();
        }
        gold.deposit(account, abi.encode(tokenId, amount));
    }

    function _activateGoldMigration(
        PhysicalGold1155 oldGold,
        PhysicalGold1155 newGold,
        LegacyGoldReserveVault reserveVault
    ) internal returns (GoldMigrationController controller) {
        controller = new GoldMigrationController();
        newGold.setMigrationController(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(oldGold), address(newGold), address(reserveVault), address(stakeHub));
        controller.activateMigration();
        stakeHub.updateParam("tokenBMigrationController", abi.encodePacked(address(controller)));
        stakeHub.updateParam("activateTokenBMigration", abi.encode(address(newGold), address(reserveVault)));
        vm.stopPrank();
    }
}
