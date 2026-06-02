pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../contracts/GoldMigrationController.sol";
import "../contracts/LegacyGoldReserveVault.sol";
import "../contracts/PhysicalGold1155.sol";

import "./utils/Deployer.sol";

interface IStakeCredit {
    function balanceOf(
        address account
    ) external view returns (uint256);
    function totalPooledGILT() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function getPooledGILTByShares(
        uint256 shares
    ) external view returns (uint256);
    function getSharesByPooledGILT(
        uint256 giltAmount
    ) external view returns (uint256);
}

contract RevertingReceiver {
    receive() external payable {
        revert("REJECT_SYSTEM_REWARD");
    }
}

contract StakeHubTest is Deployer {
    using RLPEncode for *;

    // Add NodeID related events and errors
    event NodeIDAdded(address indexed validator, bytes32 nodeID);
    event NodeIDRemoved(address indexed validator, bytes32 nodeID);

    error ExceedsMaxNodeIDs();
    error DuplicateNodeID();
    error InvalidNodeID();

    PhysicalGold1155 private _rewardOldGold;
    PhysicalGold1155 private _rewardNewGold;
    LegacyGoldReserveVault private _rewardReserveVault;
    address private _rewardValidator;
    address private _rewardConsensusAddress;
    address private _rewardDelegator;
    uint256 private _rewardPaxgTokenId;
    uint256 private _rewardTokenBAmount;
    uint256 private _rewardAmount;
    uint256 private _rewardExpectedTokenBReward;
    uint256 private _rewardStakeA;

    event ConsensusAddressEdited(address indexed operatorAddress, address indexed newAddress);
    event CommissionRateEdited(address indexed operatorAddress, uint64 commissionRate);
    event DescriptionEdited(address indexed operatorAddress);
    event VoteAddressEdited(address indexed operatorAddress, bytes newVoteAddress);
    event RewardDistributed(address indexed operatorAddress, uint256 reward);
    event RewardDistributeFailed(address indexed operatorAddress, bytes failReason);
    event ValidatorSlashed(address indexed operatorAddress, uint256 jailUntil, uint256 slashAmount, uint8 slashType);
    event ValidatorUnjailed(address indexed operatorAddress);
    event Claimed(address indexed operatorAddress, address indexed delegator, uint256 giltAmount);
    event TokenBDelegated(address indexed operatorAddress, address indexed delegator, uint256 tokenBAmount);
    event TokenBUndelegated(address indexed operatorAddress, address indexed delegator, uint256 tokenBAmount);
    event TokenBClaimed(address indexed operatorAddress, address indexed delegator, uint256 tokenBAmount);
    event TokenBSlashed(address indexed operatorAddress, uint256 tokenBAmount, uint8 slashType);
    event SlashReserveCredited(
        address indexed operatorAddress,
        StakeHub.SlashType slashType,
        uint256 indexed tokenId,
        uint256 amount,
        uint256 settlementEpoch
    );
    event SlashReserveSettled(
        address indexed recipient, uint256 indexed tokenId, uint256 amount, uint256 settlementEpoch
    );
    event SlashReserveMigratedFromSelf(address indexed vault, uint256 indexed tokenId, uint256 amount);
    event SlashReserveSelfMigrationFinalized(address indexed vault, uint256 migratedTokenCount);
    event TokenBRewardDistributed(address indexed operatorAddress, uint256 reward);
    event TokenBRewardClaimed(address indexed operatorAddress, address indexed delegator, uint256 reward);
    event TokenBMigrationProposed(
        uint256 indexed proposalId,
        address indexed proposer,
        address indexed legacyToken,
        address newToken,
        address reserveVault,
        uint256 requiredApprovals
    );
    event TokenBMigrationApproved(
        uint256 indexed proposalId, address indexed operatorAddress, uint256 approvalCount, uint256 requiredApprovals
    );
    event InflationMintRecorded(
        uint256 amount, uint256 inflationBps, uint256 totalMintedAmount, uint256 effectiveSupply
    );
    event InflationRecordedV2(
        uint256 mintedAmount,
        uint256 distributedAmount,
        uint256 redirectedAmount,
        uint256 pendingAmount,
        uint256 inflationBps,
        uint256 totalMintedAmount,
        uint256 effectiveSupply
    );
    event InflationIntervalRecorded(uint256 indexed dayIndex, address indexed consensusAddress, uint256 amount);
    event InflationRedirected(address indexed consensusAddress, address indexed operatorAddress, uint256 amount);
    event RewardForwardQueued(address indexed operatorAddress, uint256 amount, uint8 reasonCode, bytes failReason);
    event RewardForwardRetried(address indexed caller, uint256 amount, bool success, bytes failReason);
    event RewardForwardSwept(
        address indexed caller, address indexed recipient, uint256 amount, uint256 inflationAmount
    );
    event ConsensusEmergencyHalt(
        address indexed operatorAddress, address indexed consensusAddress, uint256 triggerBlock
    );
    event MigrateSuccess(
        address indexed operatorAddress, address indexed delegator, uint256 shares, uint256 giltAmount
    );
    event MigrateFailed(
        address indexed operatorAddress, address indexed delegator, uint256 giltAmount, StakeMigrationRespCode respCode
    );
    event AgentChanged(address indexed operatorAddress, address indexed oldAgent, address indexed newAgent);

    enum StakeMigrationRespCode {
        MIGRATE_SUCCESS,
        CLAIM_FUND_FAILED,
        VALIDATOR_NOT_EXISTED,
        VALIDATOR_JAILED
    }

    receive() external payable { }

    function setUp() public {
        vm.mockCall(address(0x66), bytes(""), hex"01");
    }

    function testLaunchState_UsesConfiguredInflationGoldAndMigrationDefaults() public {
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();

        assertTrue(stakeHub.inflationEnabled(), "GILT inflation should be enabled from launch");
        assertEq(stakeHub.inflationStartDayIndex(), dayIndex, "inflation should start from launch day");
        assertEq(stakeHub.inflationRateInitialBps(), 1_000, "wrong launch inflation initial bps");
        assertEq(stakeHub.inflationRateMinBps(), 150, "wrong launch inflation minimum bps");
        assertEq(stakeHub.inflationDecayBpsPerYear(), 1_500, "wrong launch inflation decay bps");
        assertEq(stakeHub.inflationBaseSupply(), 3_000_000_000 ether, "wrong launch inflation base supply");
        assertGt(stakeHub.expectedInflationMintAmount(dayIndex), 0, "inflation should mint from block 1 interval");

        assertEq(stakeHub.stakeTokenBPrimaryId(), 1, "PAXG-backed GOLD id must be 1");
        assertEq(stakeHub.stakeTokenBSecondaryId(), 2, "XAUT-backed GOLD id must be 2");
        assertEq(stakeHub.tokenBRewardSplitBps(), 2_000, "wrong GOLD reward split");

        assertEq(stakeHub.legacyStakeTokenB(), address(0), "migration legacy token should be off at launch");
        assertEq(stakeHub.tokenBCutoverVersion(), 0, "migration cutover should be off at launch");
        assertEq(stakeHub.tokenBMigrationController(), address(0), "migration controller should be unset at launch");
    }

    function _setActiveValidators(
        address[] memory operators,
        uint64[] memory votingPowers
    ) internal {
        address[] memory consensusAddrs = new address[](operators.length);
        bytes[] memory voteAddrs = new bytes[](operators.length);
        for (uint256 i; i < operators.length; ++i) {
            consensusAddrs[i] = stakeHub.getValidatorConsensusAddress(operators[i]);
            voteAddrs[i] = stakeHub.getValidatorVoteAddress(operators[i]);
        }

        vm.prank(block.coinbase);
        vm.txGasPrice(0);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);
    }

    function _configureGold1155(
        PhysicalGold1155 gold
    ) internal returns (LegacyGoldReserveVault reserveVault) {
        reserveVault = new LegacyGoldReserveVault();
        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("slashReserveVault", abi.encodePacked(address(reserveVault)));
        vm.stopPrank();
    }

    function _configureGold1155WithUnbond(
        PhysicalGold1155 gold,
        uint256 unbondPeriod_
    ) internal returns (LegacyGoldReserveVault reserveVault) {
        reserveVault = new LegacyGoldReserveVault();
        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("slashReserveVault", abi.encodePacked(address(reserveVault)));
        stakeHub.updateParam("unbondPeriod", abi.encode(unbondPeriod_));
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

    function _prepareMigrationController(
        PhysicalGold1155 oldGold,
        PhysicalGold1155 newGold,
        LegacyGoldReserveVault reserveVault
    ) internal returns (GoldMigrationController controller) {
        return _prepareMigrationControllerWithBindings(oldGold, newGold, reserveVault, address(stakeHub));
    }

    function _prepareMigrationControllerWithBindings(
        PhysicalGold1155 oldGold,
        PhysicalGold1155 newGold,
        LegacyGoldReserveVault reserveVault,
        address stakeMigrationCaller
    ) internal returns (GoldMigrationController controller) {
        controller = new GoldMigrationController();
        newGold.setMigrationController(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(oldGold), address(newGold), address(reserveVault), stakeMigrationCaller);
        controller.activateMigration();
        stakeHub.updateParam("tokenBMigrationController", abi.encodePacked(address(controller)));
        vm.stopPrank();
    }

    function testCreateValidator() public {
        // create validator success
        (address validator,,,) = _createValidator(2000 ether);
        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        bytes memory voteAddress = stakeHub.getValidatorVoteAddress(validator);

        address operatorAddress = _getNextUserAddress();
        vm.startPrank(operatorAddress);

        // create failed with duplicate consensus address
        uint256 delegation = 2000 ether;
        uint256 toLock = stakeHub.LOCK_AMOUNT();
        StakeHub.Commission memory commission = StakeHub.Commission({ rate: 10, maxRate: 100, maxChangeRate: 5 });
        StakeHub.Description memory description = StakeHub.Description({
            moniker: string.concat("T", vm.toString(uint24(uint160(operatorAddress)))),
            identity: vm.toString(operatorAddress),
            website: vm.toString(operatorAddress),
            details: vm.toString(operatorAddress)
        });
        bytes memory blsPubKey = bytes.concat(
            hex"00000000000000000000000000000000000000000000000000000000", abi.encodePacked(operatorAddress)
        );
        bytes memory blsProof = new bytes(96);

        vm.expectRevert(StakeHub.DuplicateConsensusAddress.selector);
        stakeHub.createValidator{ value: delegation + toLock }(
            consensusAddress, blsPubKey, blsProof, commission, description
        );

        // create failed with duplicate vote address
        consensusAddress = address(uint160(uint256(keccak256(blsPubKey))));
        vm.expectRevert(StakeHub.DuplicateVoteAddress.selector);
        stakeHub.createValidator{ value: delegation + toLock }(
            consensusAddress, voteAddress, blsProof, commission, description
        );

        // create failed with duplicate moniker
        description = stakeHub.getValidatorDescription(validator);
        vm.expectRevert(StakeHub.DuplicateMoniker.selector);
        stakeHub.createValidator{ value: delegation + toLock }(
            consensusAddress, blsPubKey, blsProof, commission, description
        );
    }

    function testEditValidator() public {
        // create validator
        (address validator,,,) = _createValidator(2000 ether);
        vm.startPrank(validator);

        // edit failed because of `UpdateTooFrequently`
        vm.expectRevert(StakeHub.UpdateTooFrequently.selector);
        stakeHub.editConsensusAddress(address(1));

        // edit consensus address
        vm.warp(block.timestamp + 1 days);
        address newConsensusAddress = address(0x1234);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit ConsensusAddressEdited(validator, newConsensusAddress);
        stakeHub.editConsensusAddress(newConsensusAddress);
        address realConsensusAddr = stakeHub.getValidatorConsensusAddress(validator);
        assertEq(realConsensusAddr, newConsensusAddress);

        // edit commission rate
        vm.warp(block.timestamp + 1 days);
        vm.expectRevert(StakeHub.InvalidCommission.selector);
        stakeHub.editCommissionRate(110);
        vm.expectRevert(StakeHub.InvalidCommission.selector);
        stakeHub.editCommissionRate(16);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit CommissionRateEdited(validator, 15);
        stakeHub.editCommissionRate(15);
        StakeHub.Commission memory realComm = stakeHub.getValidatorCommission(validator);
        assertEq(realComm.rate, 15);

        // edit description
        vm.warp(block.timestamp + 1 days);
        StakeHub.Description memory description = stakeHub.getValidatorDescription(validator);
        description.moniker = "Test";
        description.website = "Test";
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit DescriptionEdited(validator);
        stakeHub.editDescription(description);
        StakeHub.Description memory realDesc = stakeHub.getValidatorDescription(validator);
        assertNotEq(realDesc.moniker, "Test"); // edit moniker will be ignored
        assertEq(realDesc.website, "Test");

        // edit vote address
        vm.warp(block.timestamp + 1 days);
        bytes memory newVoteAddress =
            hex"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234";
        bytes memory blsProof = new bytes(96);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit VoteAddressEdited(validator, newVoteAddress);
        stakeHub.editVoteAddress(newVoteAddress, blsProof);
        bytes memory realVoteAddr = stakeHub.getValidatorVoteAddress(validator);
        assertEq(realVoteAddr, newVoteAddress);

        vm.stopPrank();
    }

    function testDelegate() public {
        address delegator = _getNextUserAddress();
        (address validator,, address credit,) = _createValidator(2000 ether);
        vm.startPrank(delegator);

        // failed with too small delegation amount
        vm.expectRevert(StakeHub.DelegationAmountTooSmall.selector);
        stakeHub.delegate{ value: 1 }(validator, false);

        // success case
        uint256 giltAmount = 100 ether;
        stakeHub.delegate{ value: giltAmount }(validator, false);
        uint256 shares = IStakeCredit(credit).balanceOf(delegator);
        assertEq(shares, giltAmount);
        uint256 pooledGILT = IStakeCredit(credit).getPooledGILTByShares(shares);
        assertEq(pooledGILT, giltAmount);

        vm.stopPrank();
    }

    function testUndelegate() public {
        address delegator = _getNextUserAddress();
        (address validator,, address credit,) = _createValidator(2000 ether);
        vm.startPrank(delegator);

        uint256 giltAmount = 100 ether;
        stakeHub.delegate{ value: giltAmount }(validator, false);
        uint256 shares = IStakeCredit(credit).balanceOf(delegator);

        // failed with not enough shares
        vm.expectRevert(StakeCredit.InsufficientBalance.selector);
        stakeHub.undelegate(validator, shares + 1);

        // success case
        stakeHub.undelegate(validator, shares / 2);

        // claim failed
        vm.expectRevert(StakeCredit.NoClaimableUnbondRequest.selector);
        stakeHub.claim(validator, 0);

        // claim success
        vm.warp(block.timestamp + 7 days);
        uint256 balanceBefore = delegator.balance;
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit Claimed(validator, delegator, giltAmount / 2);
        stakeHub.claim(validator, 0);
        uint256 balanceAfter = delegator.balance;
        assertEq(balanceAfter - balanceBefore, giltAmount / 2);

        vm.stopPrank();
    }

    function testUndelegateAll() public {
        uint256 selfDelegation = 2000 ether;
        uint256 toLock = stakeHub.LOCK_AMOUNT();
        (address validator,, address credit,) = _createValidator(selfDelegation);
        uint256 _totalShares = IStakeCredit(credit).totalSupply();
        assertEq(_totalShares, selfDelegation + toLock, "wrong total shares");
        uint256 _totalPooledGILT = IStakeCredit(credit).totalPooledGILT();
        assertEq(_totalPooledGILT, selfDelegation + toLock, "wrong total pooled GILT");

        vm.startPrank(validator);

        // 1. undelegate all
        stakeHub.undelegate(validator, selfDelegation);
        _totalShares = IStakeCredit(credit).totalSupply();
        assertEq(_totalShares, toLock, "wrong total shares");
        _totalPooledGILT = IStakeCredit(credit).totalPooledGILT();
        assertEq(_totalPooledGILT, toLock, "wrong total pooled GILT");

        // 2. delegate again
        stakeHub.delegate{ value: selfDelegation }(validator, false);
        _totalShares = IStakeCredit(credit).totalSupply();
        assertEq(_totalShares, selfDelegation + toLock, "wrong total shares");
        _totalPooledGILT = IStakeCredit(credit).totalPooledGILT();
        assertEq(_totalPooledGILT, selfDelegation + toLock, "wrong total pooled GILT");

        vm.stopPrank();
    }

    function testRedelegate() public {
        address delegator = _getNextUserAddress();
        (address validator1,, address credit1,) = _createValidator(2000 ether);
        (address validator2,, address credit2,) = _createValidator(2000 ether);
        vm.startPrank(delegator);

        uint256 giltAmount = 100 ether;
        stakeHub.delegate{ value: giltAmount }(validator1, false);
        uint256 oldShares = IStakeCredit(credit1).balanceOf(delegator);

        // failed with too small redelegation amount
        vm.expectRevert(StakeHub.DelegationAmountTooSmall.selector);
        stakeHub.redelegate(validator1, validator2, 1, false);

        // failed with not enough shares
        vm.expectRevert(StakeCredit.InsufficientBalance.selector);
        stakeHub.redelegate(validator1, validator2, oldShares + 1, false);

        // success case
        uint256 redelegateFeeRate = stakeHub.redelegateFeeRate();
        uint256 feeBase = stakeHub.REDELEGATE_FEE_RATE_BASE();
        uint256 redelegateFee = giltAmount * redelegateFeeRate / feeBase;
        uint256 expectedShares = (giltAmount - redelegateFee) * IStakeCredit(credit2).totalSupply()
            / (IStakeCredit(credit2).totalPooledGILT() + redelegateFee);
        stakeHub.redelegate(validator1, validator2, oldShares, false);
        uint256 newShares = IStakeCredit(credit2).balanceOf(delegator);
        assertEq(newShares, expectedShares);

        vm.stopPrank();

        // self redelegate failed because of `SelfDelegationNotEnough`
        uint256 selfDelegation = 2000 ether;
        vm.expectRevert(StakeHub.SelfDelegationNotEnough.selector);
        vm.prank(validator1);
        stakeHub.redelegate(validator1, validator2, selfDelegation, false);
    }

    function testDelegateGold1155AndUndelegateGold1155() public {
        (address validator,,,) = _createValidator(2000 ether);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();

        _configureGold1155WithUnbond(gold, 7 days);

        uint256 amount = 250 ether;
        _bridgeMintGold(gold, delegator, paxgTokenId, amount);

        vm.startPrank(delegator);
        gold.setApprovalForAll(address(stakeHub), true);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit TokenBDelegated(validator, delegator, amount);
        stakeHub.delegateTokenB1155(validator, paxgTokenId, amount);

        assertEq(stakeHub.getDelegatedTokenB(validator, delegator), amount, "wrong delegated tokenB amount");
        assertEq(stakeHub.totalDelegatedTokenB(validator), amount, "wrong validator total tokenB amount");

        uint256 undelegateAmt = 100 ether;
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit TokenBUndelegated(validator, delegator, undelegateAmt);
        stakeHub.undelegateTokenB1155(validator, paxgTokenId, undelegateAmt);

        assertEq(stakeHub.pendingTokenBUnbondRequest(validator, delegator), 1, "wrong pending unbond requests");
        (uint256 pendingAmt, uint256 unlockTime) = stakeHub.tokenBUnbondRequest(validator, delegator, 0);
        assertEq(pendingAmt, undelegateAmt, "wrong tokenB unbond amount");
        assertEq(unlockTime, block.timestamp + stakeHub.unbondPeriod(), "wrong tokenB unlock time");

        vm.expectRevert(StakeHub.InvalidRequest.selector);
        stakeHub.claimTokenB(validator, 0);

        vm.warp(block.timestamp + stakeHub.unbondPeriod());
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit TokenBClaimed(validator, delegator, undelegateAmt);
        stakeHub.claimTokenB(validator, 0);

        assertEq(stakeHub.getDelegatedTokenB(validator, delegator), amount - undelegateAmt, "wrong remaining tokenB");
        assertEq(stakeHub.totalDelegatedTokenB(validator), amount - undelegateAmt, "wrong remaining total tokenB");
        assertEq(stakeHub.pendingTokenBUnbondRequest(validator, delegator), 0, "wrong remaining tokenB requests");
        vm.stopPrank();
    }

    function testDelegateMixedGold1155AndUndelegateGold1155() public {
        (address validator,,,) = _createValidator(2000 ether);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();
        uint256 xautTokenId = gold.XAUT_TOKEN_ID();

        _configureGold1155WithUnbond(gold, 7 days);

        _bridgeMintGold(gold, delegator, paxgTokenId, 200 ether);
        _bridgeMintGold(gold, delegator, xautTokenId, 50 ether);

        vm.startPrank(delegator);
        gold.setApprovalForAll(address(stakeHub), true);
        stakeHub.delegateTokenB1155(validator, paxgTokenId, 200 ether);
        stakeHub.delegateTokenB1155(validator, xautTokenId, 50 ether);
        vm.stopPrank();

        assertEq(stakeHub.getDelegatedTokenB(validator, delegator), 250 ether, "wrong total delegated tokenB amount");
        assertEq(
            stakeHub.getDelegatedTokenBById(validator, delegator, paxgTokenId),
            200 ether,
            "wrong delegated PAXG-backed amount"
        );
        assertEq(
            stakeHub.getDelegatedTokenBById(validator, delegator, xautTokenId),
            50 ether,
            "wrong delegated XAUT-backed amount"
        );

        vm.prank(delegator);
        stakeHub.undelegateTokenB1155(validator, xautTokenId, 20 ether);

        assertEq(stakeHub.pendingTokenBUnbondRequest(validator, delegator), 1, "wrong pending ERC1155 unbond requests");
        (uint256 tokenId, uint256 pendingAmt, uint256 unlockTime) =
            stakeHub.tokenB1155UnbondRequest(validator, delegator, 0);
        assertEq(tokenId, xautTokenId, "wrong token id");
        assertEq(pendingAmt, 20 ether, "wrong token amount");
        assertEq(unlockTime, block.timestamp + stakeHub.unbondPeriod(), "wrong unlock time");

        vm.warp(block.timestamp + stakeHub.unbondPeriod());
        uint256 xautBefore = gold.balanceOf(delegator, xautTokenId);
        vm.prank(delegator);
        stakeHub.claimTokenB(validator, 0);
        assertEq(gold.balanceOf(delegator, xautTokenId) - xautBefore, 20 ether, "wrong XAUT claim amount");
        assertEq(stakeHub.getDelegatedTokenB(validator, delegator), 230 ether, "wrong remaining aggregate amount");
        assertEq(
            stakeHub.getDelegatedTokenBById(validator, delegator, xautTokenId),
            30 ether,
            "wrong remaining XAUT-backed amount"
        );
    }

    function testTokenBMigration1155_LegacyStakeMustUnstakeBeforeNewStake() public {
        (address validator,,,) = _createValidator(2000 ether);
        address[] memory activeValidators = new address[](1);
        activeValidators[0] = validator;
        uint64[] memory activeVotingPowers = new uint64[](1);
        activeVotingPowers[0] = 2001 * 1e8;
        _setActiveValidators(activeValidators, activeVotingPowers);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        uint256 paxgTokenId = oldGold.PAXG_TOKEN_ID();
        uint256 xautTokenId = oldGold.XAUT_TOKEN_ID();

        _configureGold1155WithUnbond(oldGold, 7 days);

        _bridgeMintGold(oldGold, delegator, paxgTokenId, 150 ether);
        _bridgeMintGold(oldGold, delegator, xautTokenId, 100 ether);
        vm.startPrank(delegator);
        oldGold.setApprovalForAll(address(stakeHub), true);
        stakeHub.delegateTokenB1155(validator, paxgTokenId, 150 ether);
        stakeHub.delegateTokenB1155(validator, xautTokenId, 100 ether);
        vm.stopPrank();

        _prepareMigrationController(oldGold, newGold, reserveVault);

        vm.prank(GOV_HUB_ADDR);
        stakeHub.updateParam("activateTokenBMigration", abi.encode(address(newGold), address(reserveVault)));
        assertEq(stakeHub.totalLegacyDelegatedTokenB(validator), 250 ether, "wrong snapped legacy amount");

        _bridgeMintGold(newGold, delegator, paxgTokenId, 100 ether);
        vm.startPrank(delegator);
        newGold.setApprovalForAll(address(stakeHub), true);
        vm.expectRevert(StakeHub.InvalidRequest.selector);
        stakeHub.delegateTokenB1155(validator, paxgTokenId, 100 ether);
        vm.stopPrank();

        vm.prank(delegator);
        stakeHub.undelegateTokenB1155(validator, paxgTokenId, 100 ether);

        assertEq(oldGold.balanceOf(address(reserveVault), paxgTokenId), 0, "legacy PAXG must not auto-move");
        assertEq(oldGold.balanceOf(address(reserveVault), xautTokenId), 0, "legacy XAUT must not auto-move");
        assertEq(stakeHub.totalLegacyDelegatedTokenB(validator), 150 ether, "legacy validator stake should reduce");
        assertEq(
            stakeHub.getLegacyDelegatedTokenBById(validator, delegator, paxgTokenId),
            50 ether,
            "wrong remaining legacy PAXG stake"
        );
        assertEq(
            stakeHub.getLegacyDelegatedTokenBById(validator, delegator, xautTokenId),
            100 ether,
            "wrong remaining legacy XAUT stake"
        );

        vm.warp(block.timestamp + stakeHub.unbondPeriod());
        uint256 oldGoldBefore = oldGold.balanceOf(delegator, paxgTokenId);
        vm.prank(delegator);
        stakeHub.claimTokenB(validator, 0);
        assertEq(
            oldGold.balanceOf(delegator, paxgTokenId) - oldGoldBefore,
            100 ether,
            "claim should return old PAXG-backed GOLD"
        );
        assertEq(stakeHub.getDelegatedTokenB(validator, delegator), 150 ether, "remaining stake should stay intact");
    }

    function testTokenBMigration1155_LegacyUnbondClaimsStayLegacy() public {
        (address validator,,,) = _createValidator(2000 ether);
        address[] memory activeValidators = new address[](1);
        activeValidators[0] = validator;
        uint64[] memory activeVotingPowers = new uint64[](1);
        activeVotingPowers[0] = 2001 * 1e8;
        _setActiveValidators(activeValidators, activeVotingPowers);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        uint256 paxgTokenId = oldGold.PAXG_TOKEN_ID();
        uint256 xautTokenId = oldGold.XAUT_TOKEN_ID();

        _configureGold1155WithUnbond(oldGold, 7 days);

        _bridgeMintGold(oldGold, delegator, paxgTokenId, 150 ether);
        _bridgeMintGold(oldGold, delegator, xautTokenId, 100 ether);
        vm.startPrank(delegator);
        oldGold.setApprovalForAll(address(stakeHub), true);
        stakeHub.delegateTokenB1155(validator, paxgTokenId, 150 ether);
        stakeHub.delegateTokenB1155(validator, xautTokenId, 100 ether);
        stakeHub.undelegateTokenB1155(validator, xautTokenId, 40 ether);
        vm.stopPrank();

        _prepareMigrationController(oldGold, newGold, reserveVault);

        vm.prank(GOV_HUB_ADDR);
        stakeHub.updateParam("activateTokenBMigration", abi.encode(address(newGold), address(reserveVault)));

        vm.warp(block.timestamp + stakeHub.unbondPeriod());
        uint256 oldGoldBefore = oldGold.balanceOf(delegator, xautTokenId);
        vm.prank(delegator);
        stakeHub.claimTokenB(validator, 0);

        assertEq(
            oldGold.balanceOf(delegator, xautTokenId) - oldGoldBefore, 40 ether, "legacy XAUT unbond should stay legacy"
        );
        assertEq(oldGold.balanceOf(address(reserveVault), paxgTokenId), 0, "remaining PAXG must not auto-move");
        assertEq(oldGold.balanceOf(address(reserveVault), xautTokenId), 0, "remaining XAUT must not auto-move");
        assertEq(stakeHub.totalLegacyDelegatedTokenB(validator), 210 ether, "legacy stake should remain staked");
        assertEq(stakeHub.getDelegatedTokenB(validator, delegator), 210 ether, "remaining stake should stay intact");
    }

    function testTokenBMigration1155_LegacyStakeStopsEarningAndFinalGoldEarnsAfterRestake() public {
        _setUpLegacyGoldRewardFreezeCase();
        _assertLegacyGoldRewardFreezeAndRestake();
    }

    function _setUpLegacyGoldRewardFreezeCase() internal {
        address credit;
        (_rewardValidator,, credit,) = _createValidator(2000 ether);
        _rewardDelegator = _getNextUserAddress();
        _rewardOldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        _rewardNewGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        _rewardReserveVault = new LegacyGoldReserveVault();
        _rewardPaxgTokenId = _rewardOldGold.PAXG_TOKEN_ID();
        _rewardTokenBAmount = 100 ether;
        _rewardAmount = 100 ether;
        _rewardExpectedTokenBReward = _rewardAmount * stakeHub.tokenBRewardSplitBps() / 10_000;

        _configureGold1155WithUnbond(_rewardOldGold, 7 days);
        _mintAndDelegateGold(
            _rewardOldGold, _rewardValidator, _rewardDelegator, _rewardPaxgTokenId, _rewardTokenBAmount
        );
        _rewardStakeA = IStakeCredit(credit).totalPooledGILT();
        _assertLegacyGoldCountsBeforeMigration();

        _rewardConsensusAddress = stakeHub.getValidatorConsensusAddress(_rewardValidator);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + _rewardAmount);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: _rewardAmount }(_rewardConsensusAddress);
        assertEq(
            stakeHub.pendingTokenBReward(_rewardValidator, _rewardDelegator),
            _rewardExpectedTokenBReward,
            "wrong pre-cutover GOLD reward"
        );
        _rewardStakeA = IStakeCredit(credit).totalPooledGILT();

        _activateRewardFreezeMigration();
    }

    function _assertLegacyGoldCountsBeforeMigration() internal view {
        (, uint256[] memory votingPowersBefore,,) = stakeHub.getValidatorElectionInfo(0, 0);
        assertGt(votingPowersBefore[0], _rewardStakeA, "legacy GOLD should count before migration cutover");
    }

    function _activateRewardFreezeMigration() internal {
        _prepareMigrationController(_rewardOldGold, _rewardNewGold, _rewardReserveVault);

        vm.prank(GOV_HUB_ADDR);
        stakeHub.updateParam(
            "activateTokenBMigration", abi.encode(address(_rewardNewGold), address(_rewardReserveVault))
        );
        assertEq(
            stakeHub.totalLegacyDelegatedTokenB(_rewardValidator), _rewardTokenBAmount, "legacy stake should be snapped"
        );

        (, uint256[] memory votingPowersAfterCutover,,) = stakeHub.getValidatorElectionInfo(0, 0);
        assertEq(votingPowersAfterCutover[0], _rewardStakeA, "legacy GOLD should not add power after cutover");
    }

    function _assertLegacyGoldRewardFreezeAndRestake() internal {
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + _rewardAmount);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: _rewardAmount }(_rewardConsensusAddress);
        assertEq(
            stakeHub.pendingTokenBReward(_rewardValidator, _rewardDelegator),
            _rewardExpectedTokenBReward,
            "legacy GOLD should not earn after cutover"
        );

        uint256 balanceBefore = _rewardDelegator.balance;
        vm.prank(_rewardDelegator);
        stakeHub.claimTokenBReward(_rewardValidator);
        assertEq(
            _rewardDelegator.balance - balanceBefore,
            _rewardExpectedTokenBReward,
            "claim should pay pre-cutover reward only"
        );
        assertEq(
            _rewardOldGold.balanceOf(address(_rewardReserveVault), _rewardPaxgTokenId),
            0,
            "legacy GOLD must not auto-move"
        );
        assertEq(
            _rewardNewGold.balanceOf(address(stakeHub), _rewardPaxgTokenId),
            0,
            "new GOLD must not appear without restake"
        );

        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + _rewardAmount);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: _rewardAmount }(_rewardConsensusAddress);
        assertEq(
            stakeHub.pendingTokenBReward(_rewardValidator, _rewardDelegator),
            0,
            "legacy GOLD should not earn future GILT rewards after claim"
        );

        vm.prank(_rewardDelegator);
        stakeHub.undelegateTokenB1155(_rewardValidator, _rewardPaxgTokenId, _rewardTokenBAmount);

        vm.warp(block.timestamp + stakeHub.unbondPeriod());
        uint256 oldGoldBefore = _rewardOldGold.balanceOf(_rewardDelegator, _rewardPaxgTokenId);
        vm.prank(_rewardDelegator);
        stakeHub.claimTokenB(_rewardValidator, 0);
        assertEq(
            _rewardOldGold.balanceOf(_rewardDelegator, _rewardPaxgTokenId) - oldGoldBefore,
            _rewardTokenBAmount,
            "withdrawal should return old GOLD after migration"
        );

        _mintAndDelegateGold(
            _rewardNewGold, _rewardValidator, _rewardDelegator, _rewardPaxgTokenId, _rewardTokenBAmount
        );
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + _rewardAmount);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: _rewardAmount }(_rewardConsensusAddress);
        assertEq(
            stakeHub.pendingTokenBReward(_rewardValidator, _rewardDelegator),
            _rewardExpectedTokenBReward,
            "new final GOLD should earn future GILT rewards after restake"
        );
    }

    function testTokenBMigration_GovernanceControlledAndControllerGated() public {
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        address validator1;
        address validator2;
        address validator3;
        uint64[] memory activeVotingPowers = new uint64[](3);
        address[] memory activeValidators = new address[](3);

        (validator1,,,) = _createValidator(2000 ether);
        (validator2,,,) = _createValidator(2000 ether);
        (validator3,,,) = _createValidator(2000 ether);
        activeValidators[0] = validator1;
        activeValidators[1] = validator2;
        activeValidators[2] = validator3;
        activeVotingPowers[0] = 2001 * 1e8;
        activeVotingPowers[1] = 2003 * 1e8;
        activeVotingPowers[2] = 2005 * 1e8;
        _setActiveValidators(activeValidators, activeVotingPowers);

        _configureGold1155(oldGold);

        vm.expectRevert();
        vm.prank(validator1);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        vm.expectRevert(StakeHub.TokenBMigrationNotAvailable.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        GoldMigrationController controller = new GoldMigrationController();
        newGold.setMigrationController(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(oldGold), address(newGold), address(reserveVault), address(stakeHub));
        stakeHub.updateParam("tokenBMigrationController", abi.encodePacked(address(controller)));
        vm.stopPrank();

        vm.expectRevert(StakeHub.TokenBMigrationNotAvailable.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activateMigration();
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));
        vm.stopPrank();

        assertEq(stakeHub.legacyStakeTokenB(), address(oldGold), "wrong legacy token");
        assertEq(stakeHub.stakeTokenB(), address(newGold), "wrong active token");
    }

    function testTokenBMigration_RejectsWrongControllerBindings() public {
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 otherOldGold = new PhysicalGold1155("ipfs://other-old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 otherNewGold = new PhysicalGold1155("ipfs://other-new/{id}.json", 1000, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        LegacyGoldReserveVault otherReserveVault = new LegacyGoldReserveVault();

        _configureGold1155(oldGold);

        _prepareMigrationControllerWithBindings(otherOldGold, newGold, reserveVault, address(stakeHub));
        vm.expectRevert(StakeHub.InvalidRequest.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        _prepareMigrationControllerWithBindings(oldGold, otherNewGold, reserveVault, address(stakeHub));
        vm.expectRevert(StakeHub.InvalidRequest.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        _prepareMigrationControllerWithBindings(oldGold, newGold, otherReserveVault, address(stakeHub));
        vm.expectRevert(StakeHub.InvalidRequest.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        _prepareMigrationControllerWithBindings(oldGold, newGold, reserveVault, address(this));
        vm.expectRevert(StakeHub.InvalidRequest.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        GoldMigrationController pausedController =
            _prepareMigrationControllerWithBindings(oldGold, newGold, reserveVault, address(stakeHub));
        vm.prank(GOV_HUB_ADDR);
        pausedController.setMigrationPaused(true);
        vm.expectRevert(StakeHub.TokenBMigrationNotAvailable.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));
    }

    function testTokenBMigration1155_MigrateLegacyStakeThroughController() public {
        (address validator,,,) = _createValidator(2000 ether);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        uint256 paxgTokenId = oldGold.PAXG_TOKEN_ID();
        uint256 xautTokenId = oldGold.XAUT_TOKEN_ID();
        uint256 paxgAmount = 150 ether;
        uint256 xautAmount = 100 ether;

        _configureGold1155WithUnbond(oldGold, 7 days);
        _mintAndDelegateGold(oldGold, validator, delegator, paxgTokenId, paxgAmount);
        _mintAndDelegateGold(oldGold, validator, delegator, xautTokenId, xautAmount);
        GoldMigrationController controller = _prepareMigrationController(oldGold, newGold, reserveVault);

        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        vm.prank(delegator);
        stakeHub.migrateLegacyTokenB(validator);

        assertEq(oldGold.balanceOf(address(reserveVault), paxgTokenId), paxgAmount, "legacy PAXG not captured");
        assertEq(oldGold.balanceOf(address(reserveVault), xautTokenId), xautAmount, "legacy XAUT not captured");
        assertEq(newGold.balanceOf(address(stakeHub), paxgTokenId), paxgAmount, "final PAXG not minted to StakeHub");
        assertEq(newGold.balanceOf(address(stakeHub), xautTokenId), xautAmount, "final XAUT not minted to StakeHub");
        assertEq(controller.legacyCapturedById(paxgTokenId), paxgAmount, "wrong captured PAXG counter");
        assertEq(controller.finalMintedById(xautTokenId), xautAmount, "wrong minted XAUT counter");
        assertEq(stakeHub.totalLegacyDelegatedTokenB(validator), 0, "legacy validator stake not cleared");
        assertEq(stakeHub.getLegacyDelegatedTokenB(validator, delegator), 0, "delegator still marked legacy");
        assertEq(
            stakeHub.getDelegatedTokenB(validator, delegator),
            paxgAmount + xautAmount,
            "delegated amount should remain staked"
        );

        _bridgeMintGold(newGold, delegator, paxgTokenId, 10 ether);
        vm.startPrank(delegator);
        newGold.setApprovalForAll(address(stakeHub), true);
        stakeHub.delegateTokenB1155(validator, paxgTokenId, 10 ether);
        vm.stopPrank();

        assertEq(stakeHub.getDelegatedTokenB(validator, delegator), paxgAmount + xautAmount + 10 ether);
    }

    function testTokenBMigration1155_BatchMigratesLegacyDelegators() public {
        (address validator,,,) = _createValidator(2000 ether);
        address delegator1 = _getNextUserAddress();
        address delegator2 = _getNextUserAddress();
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();
        uint256 paxgTokenId = oldGold.PAXG_TOKEN_ID();

        _configureGold1155WithUnbond(oldGold, 7 days);
        _mintAndDelegateGold(oldGold, validator, delegator1, paxgTokenId, 40 ether);
        _mintAndDelegateGold(oldGold, validator, delegator2, paxgTokenId, 60 ether);
        _prepareMigrationController(oldGold, newGold, reserveVault);

        vm.prank(GOV_HUB_ADDR);
        stakeHub.activateTokenBMigration(address(newGold), address(reserveVault));

        stakeHub.migrateLegacyTokenBDelegators(validator, 0, 0);

        assertEq(oldGold.balanceOf(address(reserveVault), paxgTokenId), 100 ether, "legacy GOLD not captured");
        assertEq(newGold.balanceOf(address(stakeHub), paxgTokenId), 100 ether, "final GOLD not minted to StakeHub");
        assertEq(stakeHub.totalLegacyDelegatedTokenB(validator), 0, "legacy validator stake not cleared");
        assertEq(stakeHub.getLegacyDelegatedTokenB(validator, delegator1), 0, "delegator1 still legacy");
        assertEq(stakeHub.getLegacyDelegatedTokenB(validator, delegator2), 0, "delegator2 still legacy");
    }

    function testUpdateParam_StakeTokenBIsLaunchOnlyAndMigrationActivationRequiresControllerState() public {
        PhysicalGold1155 oldGold = new PhysicalGold1155("ipfs://old/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 anotherGold = new PhysicalGold1155("ipfs://another/{id}.json", 1000, 1, address(this));
        PhysicalGold1155 newGold = new PhysicalGold1155("ipfs://new/{id}.json", 1000, 1, address(this));
        LegacyGoldReserveVault reserveVault = new LegacyGoldReserveVault();

        _configureGold1155(oldGold);

        vm.expectRevert();
        vm.prank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(anotherGold)));

        vm.expectRevert();
        vm.prank(GOV_HUB_ADDR);
        stakeHub.updateParam("activateTokenBMigration", abi.encode(address(newGold), address(reserveVault)));

        GoldMigrationController controller = new GoldMigrationController();
        newGold.setMigrationController(address(controller));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activatePrepare(address(oldGold), address(newGold), address(reserveVault), address(stakeHub));
        stakeHub.updateParam("tokenBMigrationController", abi.encodePacked(address(controller)));
        vm.stopPrank();

        vm.expectRevert(StakeHub.TokenBMigrationNotAvailable.selector);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.updateParam("activateTokenBMigration", abi.encode(address(newGold), address(reserveVault)));

        vm.startPrank(GOV_HUB_ADDR);
        controller.activateMigration();
        stakeHub.updateParam("activateTokenBMigration", abi.encode(address(newGold), address(reserveVault)));
        vm.stopPrank();

        assertEq(stakeHub.legacyStakeTokenB(), address(oldGold), "wrong legacy token");
        assertEq(stakeHub.stakeTokenB(), address(newGold), "wrong active token");
    }

    function testElectionPower_UsesWeightedAndCappedTokenB() public {
        (address validator,, address credit,) = _createValidator(2000 ether);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();

        _configureGold1155(gold);

        uint256 delegatedTokenB = 3000 ether;
        _mintAndDelegateGold(gold, validator, delegator, paxgTokenId, delegatedTokenB);

        (, uint256[] memory votingPowers,,) = stakeHub.getValidatorElectionInfo(0, 0);
        uint256 stakeA = IStakeCredit(credit).totalPooledGILT();
        uint256 weightedA = stakeA * stakeHub.stakeWeightA() / 10_000;
        uint256 weightedB = delegatedTokenB * stakeHub.stakeWeightB() / 10_000;
        uint256 maxB = weightedA * stakeHub.maxBPowerRatioBps() / 10_000;
        if (weightedB > maxB) {
            weightedB = maxB;
        }
        uint256 expected = weightedA + weightedB;

        assertEq(votingPowers[0], expected, "wrong effective power");
    }

    function testElectionPower_RatioEnabledBelowThresholdRemovesTokenBPower() public {
        (address validator,, address credit,) = _createValidator(2000 ether);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("ratioEnabled", hex"01");
        vm.stopPrank();

        // 100 tokenB against ~2001 tokenA is below the default 10% threshold.
        uint256 delegatedTokenB = 100 ether;
        _mintAndDelegateGold(gold, validator, delegator, paxgTokenId, delegatedTokenB);

        (, uint256[] memory votingPowers,,) = stakeHub.getValidatorElectionInfo(0, 0);
        uint256 stakeA = IStakeCredit(credit).totalPooledGILT();
        uint256 expected = stakeA * stakeHub.stakeWeightA() / 10_000;

        assertEq(votingPowers[0], expected, "tokenB power should be removed below active ratio");
    }

    function testUpdateParam_RatioBoundsValidation() public {
        vm.startPrank(GOV_HUB_ADDR);
        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "minBtoARatioBps", abi.encode(uint256(999)))
        );
        stakeHub.updateParam("minBtoARatioBps", abi.encode(uint256(999)));

        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "minBtoARatioBps", abi.encode(uint256(5001)))
        );
        stakeHub.updateParam("minBtoARatioBps", abi.encode(uint256(5001)));

        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "maxBPowerRatioBps", abi.encode(uint256(5001)))
        );
        stakeHub.updateParam("maxBPowerRatioBps", abi.encode(uint256(5001)));
        vm.stopPrank();
    }

    function testDowntimeSlash_TokenBFirstThenTokenA() public {
        uint256 selfDelegation = 2000 ether;
        (address validator,, address credit,) = _createValidator(selfDelegation);
        _createValidator(selfDelegation); // create 2 validator to avoid empty jail
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();

        LegacyGoldReserveVault reserveVault = _configureGold1155(gold);

        uint256 slashAmt = stakeHub.downtimeSlashAmount();
        uint256 tokenBStake = slashAmt + 1 ether;
        _mintAndDelegateGold(gold, validator, validator, paxgTokenId, tokenBStake);

        uint256 preValidatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(validator));
        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        uint256 slashTime = stakeHub.downtimeJailTime();

        vm.startPrank(SLASH_CONTRACT_ADDR);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit SlashReserveCredited(
            validator,
            StakeHub.SlashType.wrap(1),
            paxgTokenId,
            slashAmt,
            block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL()
        );
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit TokenBSlashed(validator, slashAmt, 1);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit ValidatorSlashed(validator, block.timestamp + slashTime, 0, 1);
        stakeHub.downtimeSlash(consensusAddress);
        vm.stopPrank();

        uint256 curValidatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(validator));
        assertApproxEqAbs(preValidatorBnbAmount, curValidatorBnbAmount, 1); // there may be 1 delta due to precision
        assertEq(stakeHub.getDelegatedTokenB(validator, validator), 1 ether, "wrong remaining self tokenB");
        assertEq(gold.balanceOf(address(reserveVault), paxgTokenId), slashAmt, "slash reserve should receive tokenB");
        assertEq(stakeHub.slashReserveAmountById(paxgTokenId), slashAmt, "slash reserve accounting mismatch");
    }

    function testReceiveBNB() public {
        // send to stakeHub directly
        (bool success,) = address(stakeHub).call{ value: 1 ether }("");
        assertTrue(!success);
        (success,) = address(stakeHub).call{ value: 1 ether }(hex"12");
        assertTrue(!success);

        // send to credit contract directly
        (,, address credit,) = _createValidator(2000 ether);
        (success,) = credit.call{ value: 1 ether }("");
        assertTrue(!success);
        (success,) = credit.call{ value: 1 ether }(hex"12");
        assertTrue(!success);

        // send to credit contract by stakeHub
        vm.deal(address(stakeHub), 1 ether);
        vm.prank(address(stakeHub));
        (success,) = credit.call{ value: 1 ether }("");
        assertTrue(success);
    }

    function testDistributeReward() public {
        address delegator = _getNextUserAddress();
        uint256 selfDelegation = 2000 ether;
        (address validator,, address credit,) = _createValidator(selfDelegation);

        // 1. delegate 100 GILT and get 100 * 1e18 shares
        uint256 delegation = 100 ether;
        vm.prank(delegator);
        stakeHub.delegate{ value: delegation }(validator, false);
        uint256 shares = IStakeCredit(credit).balanceOf(delegator);
        assertEq(shares, delegation);

        // 2. distribute reward
        uint256 reward = 100 ether;
        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit RewardDistributed(validator, reward);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(consensusAddress);

        // 3. check shares
        // reward: 100 ether
        // commissionToValidator: reward(100 ether) * commissionRate(10/10000) = 0.1 ether
        // preTotalPooledBNB: locked amount(1 ether) + selfDelegation(2000 ether) + delegation(100 ether) + (reward - commissionToValidator)(99.9 ether) = 2200.9 ether
        // preTotalShares: locked shares(1 ether) + selfDelegation(2000 ether) + delegation(100 ether)
        // curTotalShares: preTotalShares + commissionToValidator * preTotalShares  / preTotalPooledBNB = 2101095460947794084238
        // curTotalPooledBNB: preTotalPooledBNB + commissionToValidator = 2201 ether
        // expectedBnbAmount: shares(100 ether) * curTotalPooledBNB / curTotalShares
        uint256 _totalShares = IStakeCredit(credit).totalSupply();
        assertEq(_totalShares, 2101095460947794084238, "wrong total shares");
        uint256 expectedBnbAmount = shares * 2201 ether / uint256(2101095460947794084238);
        uint256 realGiltAmount = IStakeCredit(credit).getPooledGILTByShares(shares);
        assertEq(realGiltAmount, expectedBnbAmount, "wrong GILT amount");

        // 4. undelegate and submit new delegate
        vm.prank(delegator);
        stakeHub.undelegate(validator, shares);

        // totalShares: 2101095460947794084238 - 100 ether = 2001095460947794084238
        // totalPooledGILT: 2201 ether - (100 ether + 99.9 ether * 100 / 2101 ) = 2096245121370775821038
        // newShares: 100 ether * totalShares / totalPooledGILT
        uint256 _totalPooledGILT = IStakeCredit(credit).totalPooledGILT();
        assertEq(_totalPooledGILT, 2096245121370775821038, "wrong total pooled GILT");
        uint256 expectedShares = 100 ether * uint256(2001095460947794084238) / uint256(2096245121370775821038);
        address newDelegator = _getNextUserAddress();
        vm.prank(newDelegator);
        stakeHub.delegate{ value: delegation }(validator, false);
        uint256 newShares = IStakeCredit(credit).balanceOf(newDelegator);
        assertEq(newShares, expectedShares, "wrong new shares");
    }

    function testDistributeReward_TokenBRewardSplitAndClaim() public {
        (address validator,,,) = _createValidator(2000 ether);
        address delegator = _getNextUserAddress();
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("tokenBRewardSplitBps", abi.encode(uint256(2_000))); // 20%
        vm.stopPrank();

        uint256 tokenBAmount = 100 ether;
        _mintAndDelegateGold(gold, validator, delegator, paxgTokenId, tokenBAmount);

        uint256 reward = 50 ether;
        uint256 expectedTokenBReward = reward * 2_000 / 10_000;
        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);

        vm.startPrank(VALIDATOR_CONTRACT_ADDR);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit TokenBRewardDistributed(validator, expectedTokenBReward);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit RewardDistributed(validator, reward);
        stakeHub.distributeReward{ value: reward }(consensusAddress);
        vm.stopPrank();

        assertEq(
            stakeHub.pendingTokenBReward(validator, delegator), expectedTokenBReward, "wrong pending tokenB reward"
        );

        uint256 balanceBefore = delegator.balance;
        vm.prank(delegator);
        stakeHub.claimTokenBReward(validator);
        assertEq(delegator.balance - balanceBefore, expectedTokenBReward, "wrong claimed tokenB reward");
        assertEq(stakeHub.pendingTokenBReward(validator, delegator), 0, "pending tokenB reward should be zero");
    }

    function testInflationDecayCurveAndMintRecording() public {
        (, address consensusAddress,,) = _createValidator(2000 ether);
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(2_000_000 ether)));
        stakeHub.updateParam("inflationEnabled", hex"01");
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        stakeHub.updateParam("inflationRateInitialBps", abi.encode(uint256(1000))); // 10%
        stakeHub.updateParam("inflationRateMinBps", abi.encode(uint256(100))); // 1%
        stakeHub.updateParam("inflationDecayBpsPerYear", abi.encode(uint256(5000))); // 50% / year
        vm.stopPrank();

        assertEq(stakeHub.currentInflationBps(dayIndex), 1000, "wrong inflation bps at start");
        assertEq(stakeHub.currentInflationBps(dayIndex + 365), 500, "wrong inflation bps after 1 year");
        assertEq(stakeHub.currentInflationBps(dayIndex + 730), 250, "wrong inflation bps after 2 years");
        assertEq(stakeHub.currentInflationBps(dayIndex + 1095), 125, "wrong inflation bps after 3 years");
        assertEq(stakeHub.currentInflationBps(dayIndex + 1460), 100, "wrong inflation bps minimum bound");

        uint256 mintedAmount = stakeHub.expectedInflationMintAmount(dayIndex);
        assertGt(mintedAmount, 0, "expected inflation amount must be non-zero");
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + mintedAmount);
        vm.startPrank(VALIDATOR_CONTRACT_ADDR);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit InflationIntervalRecorded(dayIndex, consensusAddress, mintedAmount);
        vm.expectEmit(false, false, false, true, address(stakeHub));
        emit InflationMintRecorded(mintedAmount, 1000, mintedAmount, 2_000_000 ether + mintedAmount);
        stakeHub.recordInflationMint{ value: mintedAmount }(consensusAddress);
        vm.stopPrank();

        assertEq(stakeHub.inflationMintedAmount(), mintedAmount, "wrong minted inflation amount");
        assertEq(stakeHub.inflationDistributedAmount(), mintedAmount, "wrong distributed inflation amount");
        assertEq(
            stakeHub.inflationEffectiveSupply(), 2_000_000 ether + mintedAmount, "wrong effective inflation supply"
        );
        assertEq(stakeHub.inflationLastMintTimestamp(), block.timestamp, "wrong last mint timestamp");
        assertEq(stakeHub.inflationRecorderByDay(dayIndex), consensusAddress, "wrong inflation recorder by day");
    }

    function testRecordInflationMintRejectsNonCanonicalAmount() public {
        (, address consensusAddress,,) = _createValidator(2000 ether);
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(2_000_000 ether)));
        stakeHub.updateParam("inflationEnabled", hex"01");
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        vm.stopPrank();

        uint256 expectedAmount = stakeHub.expectedInflationMintAmount(dayIndex);
        assertGt(expectedAmount, 1, "expected inflation amount too small for test");

        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + expectedAmount);
        vm.startPrank(VALIDATOR_CONTRACT_ADDR);
        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidInflationMintAmount.selector, expectedAmount, expectedAmount - 1)
        );
        stakeHub.recordInflationMint{ value: expectedAmount - 1 }(consensusAddress);
        vm.stopPrank();
    }

    function testRecordInflationMintRejectsDuplicateInterval() public {
        (, address consensusAddress,,) = _createValidator(2000 ether);
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(2_000_000 ether)));
        stakeHub.updateParam("inflationEnabled", hex"01");
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        vm.stopPrank();

        uint256 expectedAmount = stakeHub.expectedInflationMintAmount(dayIndex);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + expectedAmount * 2);

        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.recordInflationMint{ value: expectedAmount }(consensusAddress);

        vm.startPrank(VALIDATOR_CONTRACT_ADDR);
        vm.expectRevert(abi.encodeWithSelector(StakeHub.InflationAlreadyRecorded.selector, dayIndex));
        stakeHub.recordInflationMint{ value: expectedAmount }(consensusAddress);
        vm.stopPrank();
    }

    function testUpdateParam_RewardAndInflationHardeningValidation() public {
        vm.startPrank(GOV_HUB_ADDR);
        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "tokenBRewardSplitBps", abi.encode(uint256(1000)))
        );
        stakeHub.updateParam("tokenBRewardSplitBps", abi.encode(uint256(1000)));

        vm.expectRevert(abi.encodeWithSelector(StakeHub.InvalidValue.selector, "inflationEnabled", hex"02"));
        stakeHub.updateParam("inflationEnabled", hex"02");

        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "inflationRateInitialBps", abi.encode(uint256(0)))
        );
        stakeHub.updateParam("inflationRateInitialBps", abi.encode(uint256(0)));

        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "inflationRateMinBps", abi.encode(uint256(0)))
        );
        stakeHub.updateParam("inflationRateMinBps", abi.encode(uint256(0)));

        vm.expectRevert(
            abi.encodeWithSelector(StakeHub.InvalidValue.selector, "inflationBaseSupply", abi.encode(uint256(0)))
        );
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(0)));
        vm.stopPrank();
    }

    function testTokenBReward_MultiDelegatorProRataAndDebtAccounting() public {
        (address validator,,,) = _createValidator(2000 ether);
        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        address delegator1 = _getNextUserAddress();
        address delegator2 = _getNextUserAddress();
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();
        uint256 xautTokenId = gold.XAUT_TOKEN_ID();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("tokenBRewardSplitBps", abi.encode(uint256(2_000))); // 20%
        vm.stopPrank();

        _mintAndDelegateGold(gold, validator, delegator1, paxgTokenId, 100 ether);
        _mintAndDelegateGold(gold, validator, delegator2, xautTokenId, 300 ether);

        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + 100 ether);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: 100 ether }(consensusAddress);

        uint256 d1PendingRound1 = stakeHub.pendingTokenBReward(validator, delegator1);
        uint256 d2PendingRound1 = stakeHub.pendingTokenBReward(validator, delegator2);
        assertGt(d1PendingRound1, 0, "d1 should have pending reward");
        assertGt(d2PendingRound1, d1PendingRound1, "d2 pending should be greater due to higher stake");

        uint256 d1BalanceBeforeClaim1 = delegator1.balance;
        vm.prank(delegator1);
        stakeHub.claimTokenBReward(validator);
        assertEq(delegator1.balance - d1BalanceBeforeClaim1, d1PendingRound1, "wrong d1 claim 1");
        assertEq(stakeHub.pendingTokenBReward(validator, delegator1), 0, "d1 pending should reset");

        vm.prank(delegator1);
        stakeHub.undelegateTokenB1155(validator, paxgTokenId, 50 ether);

        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + 100 ether);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: 100 ether }(consensusAddress);

        uint256 d1PendingRound2 = stakeHub.pendingTokenBReward(validator, delegator1);
        uint256 d2PendingRound2 = stakeHub.pendingTokenBReward(validator, delegator2);
        assertGt(d1PendingRound2, 0, "d1 should accrue reward after undelegation");
        assertGt(d2PendingRound2, d2PendingRound1, "d2 should continue accruing reward");
        assertGt(d2PendingRound2, d1PendingRound2, "d2 pending should remain greater than d1");

        uint256 d1BalanceBeforeClaim2 = delegator1.balance;
        vm.prank(delegator1);
        stakeHub.claimTokenBReward(validator);
        assertEq(delegator1.balance - d1BalanceBeforeClaim2, d1PendingRound2, "wrong d1 claim 2");

        uint256 d2BalanceBeforeClaim = delegator2.balance;
        vm.prank(delegator2);
        stakeHub.claimTokenBReward(validator);
        assertEq(delegator2.balance - d2BalanceBeforeClaim, d2PendingRound2, "wrong d2 claim");
    }

    function testInflationEnabledDoesNotPullSystemRewardDuringDistributeReward() public {
        (address validator,,,) = _createValidator(2000 ether);
        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(1_000 ether)));
        stakeHub.updateParam("inflationEnabled", hex"01");
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        stakeHub.updateParam("inflationRateInitialBps", abi.encode(uint256(1000)));
        stakeHub.updateParam("inflationRateMinBps", abi.encode(uint256(100)));
        stakeHub.updateParam("inflationDecayBpsPerYear", abi.encode(uint256(5000)));
        vm.stopPrank();

        vm.deal(address(systemReward), 100 ether);
        uint256 systemRewardBefore = address(systemReward).balance;

        uint256 reward = 10 ether;
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit RewardDistributed(validator, reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(consensusAddress);

        assertEq(address(systemReward).balance, systemRewardBefore, "system reward pool should not be touched");
    }

    function testDistributeReward_ForwardFailureQueuesAndRetries() public {
        uint256 reward = 5 ether;
        bytes memory systemRewardCode = vm.getDeployedCode("SystemReward.sol:SystemReward");
        RevertingReceiver revertingReceiver = new RevertingReceiver();
        vm.etch(SYSTEM_REWARD_ADDR, address(revertingReceiver).code);

        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.startPrank(VALIDATOR_CONTRACT_ADDR);
        vm.expectEmit(true, false, false, false, address(stakeHub));
        emit RewardDistributeFailed(address(0), "INVALID_VALIDATOR");
        vm.expectEmit(true, false, false, false, address(stakeHub));
        emit RewardForwardQueued(address(0), reward, 1, "");
        stakeHub.distributeReward{ value: reward }(address(0xBEEF));
        vm.stopPrank();

        assertEq(stakeHub.pendingSystemReward(), reward, "forward failure should queue reward");

        vm.etch(SYSTEM_REWARD_ADDR, systemRewardCode);
        vm.startPrank(GOV_HUB_ADDR);
        vm.expectEmit(true, false, false, false, address(stakeHub));
        emit RewardForwardRetried(GOV_HUB_ADDR, reward, true, "");
        stakeHub.retryPendingSystemReward(0);
        vm.stopPrank();
        assertEq(stakeHub.pendingSystemReward(), 0, "pending system reward should be cleared");
    }

    function testInflationRedirectForJailedValidatorTracksBuckets() public {
        (address validator, address consensusAddress,,) = _createValidator(2000 ether);
        _createValidator(2000 ether);
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(2_000_000 ether)));
        stakeHub.updateParam("inflationEnabled", hex"01");
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        vm.stopPrank();

        vm.prank(SLASH_CONTRACT_ADDR);
        stakeHub.downtimeSlash(consensusAddress);

        bytes memory systemRewardCode = vm.getDeployedCode("SystemReward.sol:SystemReward");
        RevertingReceiver revertingReceiver = new RevertingReceiver();
        vm.etch(SYSTEM_REWARD_ADDR, address(revertingReceiver).code);

        uint256 inflationAmount = stakeHub.expectedInflationMintAmount(dayIndex);
        assertGt(inflationAmount, 0, "expected inflation amount must be non-zero");
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + inflationAmount);
        vm.startPrank(VALIDATOR_CONTRACT_ADDR);
        vm.expectEmit(true, true, false, false, address(stakeHub));
        emit InflationRedirected(consensusAddress, validator, inflationAmount);
        vm.expectEmit(true, false, false, false, address(stakeHub));
        emit RewardForwardQueued(validator, inflationAmount, 2, "");
        stakeHub.recordInflationMint{ value: inflationAmount }(consensusAddress);
        vm.stopPrank();

        assertEq(stakeHub.inflationMintedAmount(), inflationAmount, "minted inflation mismatch");
        assertEq(stakeHub.inflationPendingAmount(), inflationAmount, "inflation pending bucket mismatch");
        assertEq(stakeHub.pendingInflationSystemReward(), inflationAmount, "pending inflation forward mismatch");
        assertEq(stakeHub.pendingSystemReward(), inflationAmount, "pending system reward mismatch");

        vm.etch(SYSTEM_REWARD_ADDR, systemRewardCode);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.retryPendingSystemReward(0);

        assertEq(stakeHub.pendingSystemReward(), 0, "pending reward should clear after retry");
        assertEq(stakeHub.inflationPendingAmount(), 0, "inflation pending should clear after retry");
        assertEq(stakeHub.inflationRedirectedAmount(), inflationAmount, "inflation redirected bucket mismatch");
    }

    function testPendingSystemRewardCanBeSweptByGovernance() public {
        uint256 reward = 2 ether;
        RevertingReceiver revertingReceiver = new RevertingReceiver();
        vm.etch(SYSTEM_REWARD_ADDR, address(revertingReceiver).code);

        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(address(0xCAFE));
        assertEq(stakeHub.pendingSystemReward(), reward, "pending reward should be queued");

        address recipient = _getNextUserAddress();
        uint256 recipientBefore = recipient.balance;
        vm.prank(GOV_HUB_ADDR);
        stakeHub.sweepPendingSystemReward(recipient, reward);

        assertEq(stakeHub.pendingSystemReward(), 0, "pending reward should clear after sweep");
        assertEq(recipient.balance - recipientBefore, reward, "sweep recipient amount mismatch");
    }

    function testSlashWithSelfVaultRevertsBeforeStateMutation() public {
        uint256 selfDelegation = 2000 ether;
        (address validator, address consensusAddress,,) = _createValidator(selfDelegation);
        _createValidator(selfDelegation); // avoid emergency-halt single-validator edge path

        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();
        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        vm.stopPrank();

        uint256 tokenBStake = stakeHub.downtimeSlashAmount() + 1 ether;
        _mintAndDelegateGold(gold, validator, validator, paxgTokenId, tokenBStake);
        uint256 delegatedBefore = stakeHub.getDelegatedTokenB(validator, validator);

        vm.prank(SLASH_CONTRACT_ADDR);
        vm.expectRevert(StakeHub.SlashReserveNotConfigured.selector);
        stakeHub.downtimeSlash(consensusAddress);

        assertEq(stakeHub.getDelegatedTokenB(validator, validator), delegatedBefore, "slash mutated tokenB stake");
    }

    function testSettleSlashReserve1155TransfersAndUpdatesAccounting() public {
        uint256 selfDelegation = 2000 ether;
        (address validator, address consensusAddress,,) = _createValidator(selfDelegation);
        _createValidator(selfDelegation); // avoid emergency-halt single-validator edge path

        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1000, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();
        address reserveVault = _getNextUserAddress();
        address recipient = _getNextUserAddress();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("slashReserveVault", abi.encodePacked(reserveVault));
        vm.stopPrank();

        uint256 slashAmt = stakeHub.downtimeSlashAmount();
        _mintAndDelegateGold(gold, validator, validator, paxgTokenId, slashAmt + 1 ether);

        vm.prank(SLASH_CONTRACT_ADDR);
        stakeHub.downtimeSlash(consensusAddress);
        assertEq(stakeHub.slashReserveAmountById(paxgTokenId), slashAmt, "reserve accounting mismatch after slash");

        vm.prank(reserveVault);
        gold.setApprovalForAll(address(stakeHub), true);

        vm.expectEmit(true, true, false, true, address(stakeHub));
        uint256 settlementEpoch = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();
        emit SlashReserveSettled(recipient, paxgTokenId, slashAmt, settlementEpoch);
        vm.prank(GOV_HUB_ADDR);
        stakeHub.settleSlashReserve1155(recipient, paxgTokenId, slashAmt);

        assertEq(gold.balanceOf(recipient, paxgTokenId), slashAmt, "settled reserve amount mismatch");
        assertEq(stakeHub.slashReserveAmountById(paxgTokenId), 0, "reserve accounting should be decremented");
    }

    function testMigrateSelfCustodiedSlashReserveOneTime() public {
        uint256 selfDelegation = 2000 ether;
        (address validator, address consensusAddress,,) = _createValidator(selfDelegation);
        _createValidator(selfDelegation); // avoid emergency-halt single-validator edge path

        PhysicalGold1155 gold = new PhysicalGold1155("ipfs://gold/{id}.json", 1, 1, address(this));
        uint256 paxgTokenId = gold.PAXG_TOKEN_ID();
        address reserveVault = _getNextUserAddress();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("stakeTokenBPrimaryId", abi.encode(uint256(1)));
        stakeHub.updateParam("stakeTokenBSecondaryId", abi.encode(uint256(2)));
        stakeHub.updateParam("stakeTokenB", abi.encodePacked(address(gold)));
        stakeHub.updateParam("slashReserveVault", abi.encodePacked(reserveVault));
        vm.stopPrank();

        uint256 slashAmt = stakeHub.downtimeSlashAmount();
        _mintAndDelegateGold(gold, validator, validator, paxgTokenId, slashAmt + 1 ether);
        vm.prank(SLASH_CONTRACT_ADDR);
        stakeHub.downtimeSlash(consensusAddress);
        assertEq(stakeHub.slashReserveAmountById(paxgTokenId), slashAmt, "reserve accounting mismatch after slash");

        // Simulate legacy self-custodied slash inventory that must be migrated to the configured vault.
        _bridgeMintGold(gold, address(stakeHub), paxgTokenId, slashAmt);

        uint256[] memory tokenIds = new uint256[](1);
        uint256[] memory amounts = new uint256[](1);
        tokenIds[0] = paxgTokenId;
        amounts[0] = slashAmt;

        vm.prank(GOV_HUB_ADDR);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit SlashReserveMigratedFromSelf(reserveVault, paxgTokenId, slashAmt);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit SlashReserveSelfMigrationFinalized(reserveVault, 1);
        stakeHub.migrateSelfCustodiedSlashReserve(tokenIds, amounts);

        assertEq(
            gold.balanceOf(address(stakeHub), paxgTokenId),
            1 ether,
            "self-custodied reserve should be migrated without moving active stake"
        );
        assertEq(gold.balanceOf(reserveVault, paxgTokenId), slashAmt * 2, "vault should include slashed and migrated");
        assertTrue(stakeHub.slashReserveSelfMigrationCompleted(), "migration flag should be finalized");

        vm.prank(GOV_HUB_ADDR);
        vm.expectRevert(StakeHub.InvalidRequest.selector);
        stakeHub.migrateSelfCustodiedSlashReserve(tokenIds, amounts);
    }

    function testLastValidatorSlashTriggersConsensusEmergencyHalt() public {
        (address validator, address consensusAddress,,) = _createValidator(2000 ether);

        vm.prank(SLASH_CONTRACT_ADDR);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit ConsensusEmergencyHalt(validator, consensusAddress, block.number);
        stakeHub.downtimeSlash(consensusAddress);

        (, bool jailed,) = stakeHub.getValidatorBasicInfo(validator);
        assertTrue(jailed, "validator should be jailed");
        assertTrue(giltValidatorSet.consensusEmergencyHalt(), "validator set should enter emergency halt");
        assertEq(giltValidatorSet.getValidators().length, 0, "halted validator set should have no active validators");
    }

    function testDowntimeSlash() public {
        // totalShares: 2100095458884494749761
        // totalPooledGILT: 2200 ether
        uint256 selfDelegation = 2000 ether;
        uint256 reward = 100 ether;
        (address validator,, address credit,) = _createValidator(selfDelegation);
        _createValidator(selfDelegation); // create 2 validator to avoid empty jail

        address delegator = _getNextUserAddress();
        vm.prank(delegator);
        stakeHub.delegate{ value: 100 ether }(validator, false);

        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(consensusAddress);

        uint256 preDelegatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(delegator));
        uint256 preValidatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(validator));

        vm.startPrank(SLASH_CONTRACT_ADDR);

        // downtime slash type: 1
        uint256 slashAmt = stakeHub.downtimeSlashAmount();
        uint256 slashTime = stakeHub.downtimeJailTime();
        vm.expectEmit(true, false, false, false, address(stakeHub));
        emit ValidatorSlashed(validator, block.timestamp + slashTime, slashAmt, 1);
        stakeHub.downtimeSlash(consensusAddress);
        uint256 curValidatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(validator));
        assertApproxEqAbs(preValidatorBnbAmount, curValidatorBnbAmount + slashAmt, 1); // there may be 1 delta due to the precision

        // check delegator's share
        uint256 curDelegatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(delegator));
        assertApproxEqAbs(preDelegatorBnbAmount, curDelegatorBnbAmount, 1); // there may be 1 delta due to the precision

        // unjail
        (, bool jailed,) = stakeHub.getValidatorBasicInfo(validator);
        assertEq(jailed, true);
        vm.expectRevert();
        stakeHub.unjail(validator);
        vm.warp(block.timestamp + slashTime + 1);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit ValidatorUnjailed(validator);
        stakeHub.unjail(validator);
        (, jailed,) = stakeHub.getValidatorBasicInfo(validator);
        assertEq(jailed, false);

        vm.stopPrank();
    }

    function testDoubleSignSlash() public {
        // totalShares: 2100095458884494749761
        // totalPooledGILT: 2200 ether
        uint256 selfDelegation = 2000 ether;
        uint256 reward = 100 ether;
        (address validator,, address credit,) = _createValidator(selfDelegation);

        address delegator = _getNextUserAddress();
        vm.prank(delegator);
        stakeHub.delegate{ value: 100 ether }(validator, false);

        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(consensusAddress);

        uint256 preDelegatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(delegator));

        vm.startPrank(SLASH_CONTRACT_ADDR);

        // double sign slash type: 0
        vm.expectEmit(true, false, false, false, address(stakeHub)); // as slash amount may vary by 1, we don't check the event data
        emit ValidatorSlashed(validator, 0, 0, 0);
        stakeHub.doubleSignSlash(consensusAddress);

        // check delegator's share
        uint256 curDelegatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(delegator));
        assertApproxEqAbs(preDelegatorBnbAmount, curDelegatorBnbAmount, 1); // there may be 1 delta due to the precision
    }

    function testMaliciousVoteSlash() public {
        // totalShares: 2100095458884494749761
        // totalPooledGILT: 2200 ether
        uint256 selfDelegation = 2000 ether;
        uint256 reward = 100 ether;
        (address validator,, address credit,) = _createValidator(selfDelegation);

        address delegator = _getNextUserAddress();
        vm.prank(delegator);
        stakeHub.delegate{ value: 100 ether }(validator, false);

        address consensusAddress = stakeHub.getValidatorConsensusAddress(validator);
        bytes memory voteAddr = stakeHub.getValidatorVoteAddress(validator);
        vm.deal(VALIDATOR_CONTRACT_ADDR, VALIDATOR_CONTRACT_ADDR.balance + reward);
        vm.prank(VALIDATOR_CONTRACT_ADDR);
        stakeHub.distributeReward{ value: reward }(consensusAddress);

        uint256 preDelegatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(delegator));

        // malicious vote slash type: 2
        vm.expectEmit(true, false, false, false, address(stakeHub)); // as slash amount may vary by 1, we don't check the event data
        emit ValidatorSlashed(validator, 0, 0, 2);
        vm.prank(SLASH_CONTRACT_ADDR);
        stakeHub.maliciousVoteSlash(voteAddr);

        // check delegator's share
        uint256 curDelegatorBnbAmount =
            IStakeCredit(credit).getPooledGILTByShares(IStakeCredit(credit).balanceOf(delegator));
        assertApproxEqAbs(preDelegatorBnbAmount, curDelegatorBnbAmount, 1); // there may be 1 delta due to the precision
    }

    function testUpdateValidatorSetV2() public {
        uint256 length = stakeHub.maxElectedValidators();
        address[] memory newConsensusAddrs = new address[](length);
        uint64[] memory newVotingPower = new uint64[](length);
        bytes[] memory newVoteAddrs = new bytes[](length);
        address operatorAddress;
        address consensusAddress;
        uint64 votingPower;
        bytes memory voteAddress;
        for (uint256 i; i < length; ++i) {
            votingPower = (2000 + uint64(i) * 2 + 1) * 1e8;
            (operatorAddress,,,) = _createValidator(uint256(votingPower) * 1e10);
            consensusAddress = stakeHub.getValidatorConsensusAddress(operatorAddress);
            voteAddress = stakeHub.getValidatorVoteAddress(operatorAddress);
            newConsensusAddrs[length - i - 1] = consensusAddress;
            newVotingPower[length - i - 1] = votingPower;
            newVoteAddrs[length - i - 1] = voteAddress;
        }
        vm.prank(block.coinbase);
        vm.txGasPrice(0);
        giltValidatorSet.updateValidatorSetV2(newConsensusAddrs, newVotingPower, newVoteAddrs);
    }

    function testEncodeLegacyBytes() public {
        address[] memory cAddresses = new address[](56);
        bytes[] memory vAddresses = new bytes[](34);

        cAddresses[0] = 0x295e26495CEF6F69dFA69911d9D8e4F3bBadB89B;
        cAddresses[1] = 0x72b61c6014342d914470eC7aC2975bE345796c2b;
        cAddresses[2] = 0x2465176C461AfB316ebc773C61fAEe85A6515DAA;
        cAddresses[3] = 0x7AE2F5B9e386cd1B50A4550696D957cB4900f03a;
        cAddresses[4] = 0xb4dd66D7c2C7E57F628210187192fb89d4b99dD4;
        cAddresses[5] = 0xE9AE3261a475a27Bb1028f140bc2a7c843318afD;
        cAddresses[6] = 0xee226379dB83CfFC681495730c11fDDE79BA4c0C;
        cAddresses[7] = 0x3f349bBaFEc1551819B8be1EfEA2fC46cA749aA1;
        cAddresses[8] = 0x8b6C8fd93d6F4CeA42Bbb345DBc6F0DFdb5bEc73;
        cAddresses[9] = 0xEF0274E31810C9Df02F98FAFDe0f841F4E66a1Cd;
        cAddresses[10] = 0xa6f79B60359f141df90A0C745125B131cAAfFD12;
        cAddresses[11] = 0xe2d3A739EFFCd3A99387d015E260eEFAc72EBea1;
        cAddresses[12] = 0x61Dd481A114A2E761c554B641742C973867899D3;
        cAddresses[13] = 0xCc8E6d00C17eB431350C6c50d8b8F05176b90b11;
        cAddresses[14] = 0xea0A6E3c511bbD10f4519EcE37Dc24887e11b55d;
        cAddresses[15] = 0x2D4C407BBe49438ED859fe965b140dcF1aaB71a9;
        cAddresses[16] = 0x685B1ded8013785d6623CC18D214320b6Bb64759;
        cAddresses[17] = 0xD1d6bF74282782B0b3eb1413c901D6eCF02e8e28;
        cAddresses[18] = 0x70F657164e5b75689b64B7fd1fA275F334f28e18;
        cAddresses[19] = 0xBe807Dddb074639cD9fA61b47676c064fc50D62C;
        cAddresses[20] = 0xb218C5D6aF1F979aC42BC68d98A5A0D796C6aB01;
        cAddresses[21] = 0x9F8cCdaFCc39F3c7D6EBf637c9151673CBc36b88;
        cAddresses[22] = 0xd93DbfB27e027F5e9e6Da52B9E1C413CE35ADC11;
        cAddresses[23] = 0xce2FD7544e0B2Cc94692d4A704deBEf7bcB61328;
        cAddresses[24] = 0x0BAC492386862aD3dF4B666Bc096b0505BB694Da;
        cAddresses[25] = 0x733fdA7714a05960B7536330Be4DBB135bef0Ed6;
        cAddresses[26] = 0x35EBb5849518aFF370cA25E19e1072cC1a9FAbCa;
        cAddresses[27] = 0xeBE0B55aD7Bb78309180Cada12427d120fdBcc3a;
        cAddresses[28] = 0x6488Aa4D1955Ee33403f8ccB1d4dE5Fb97C7ade2;
        cAddresses[29] = 0x4396e28197653d0C244D95f8C1E57da902A72b4e;
        cAddresses[30] = 0x702Be18040aA2a9b1af9219941469f1a435854fC;
        cAddresses[31] = 0x12D810C13e42811E9907c02e02d1faD46cfA18BA;
        cAddresses[32] = 0x2a7cdd959bFe8D9487B2a43B33565295a698F7e2;
        cAddresses[33] = 0xB8f7166496996A7da21cF1f1b04d9B3E26a3d077;
        cAddresses[34] = 0x9bB832254BAf4E8B4cc26bD2B52B31389B56E98B;
        cAddresses[35] = 0x4430b3230294D12c6AB2aAC5C2cd68E80B16b581;
        cAddresses[36] = 0xc2Be4EC20253B8642161bC3f444F53679c1F3D47;
        cAddresses[37] = 0xEe01C3b1283AA067C58eaB4709F85e99D46de5FE;
        cAddresses[38] = 0x9ef9f4360c606c7AB4db26b016007d3ad0aB86a0;
        cAddresses[39] = 0x2f7bE8361C80A4c1e7e9aAF001d0877F1CFdE218;
        cAddresses[40] = 0x35E7a025f4da968De7e4D7E4004197917F4070F1;
        cAddresses[41] = 0xd6caA02BBebaEbB5d7e581e4B66559e635F805fF;
        cAddresses[42] = 0x8c4D90829CE8F72D0163c1D5Cf348a862d550630;
        cAddresses[43] = 0x68Bf0B8b6FB4E317a0f9D6F03eAF8CE6675BC60D;
        cAddresses[44] = 0x82012708DAfC9E1B880fd083B32182B869bE8E09;
        cAddresses[45] = 0x6BBad7Cf34b5fA511d8e963dbba288B1960E75D6;
        cAddresses[46] = 0x22B81f8E175FFde54d797FE11eB03F9E3BF75F1d;
        cAddresses[47] = 0x78f3aDfC719C99674c072166708589033e2d9afe;
        cAddresses[48] = 0x29a97C6EfFB8A411DABc6aDEEfaa84f5067C8bbe;
        cAddresses[49] = 0xAAcF6a8119F7e11623b5A43DA638e91F669A130f;
        cAddresses[50] = 0x2b3A6c089311b478Bf629C29D790A7A6db3fc1b9;
        cAddresses[51] = 0xFE6E72b223f6d6Cf4edc6bFf92f30e84b8258249;
        cAddresses[52] = 0xa6503279E8B5c7Bb5CF4deFD3ec8ABf3e009a80b;
        cAddresses[53] = 0x4ee63a09170C3f2207aeCa56134Fc2Bee1b28e3C;
        cAddresses[54] = 0xac0E15a038eedfc68ba3C35c73feD5bE4A07afB5;
        cAddresses[55] = 0x69C77a677C40C7FBeA129d4b171a39B7A8DDaBfA;

        vAddresses[0] =
        hex"977cf58294f7239d515e15b24cfeb82494056cf691eaf729b165f32c9757c429dba5051155903067e56ebe3698678e91";
        vAddresses[1] =
        hex"81db0422a5fd08e40db1fc2368d2245e4b18b1d0b85c921aaaafd2e341760e29fc613edd39f71254614e2055c3287a51";
        vAddresses[2] =
        hex"8a923564c6ffd37fb2fe9f118ef88092e8762c7addb526ab7eb1e772baef85181f892c731be0c1891a50e6b06262c816";
        vAddresses[3] =
        hex"b84f83ff2df44193496793b847f64e9d6db1b3953682bb95edd096eb1e69bbd357c200992ca78050d0cbe180cfaa018e";
        vAddresses[4] =
        hex"b0de8472be0308918c8bdb369bf5a67525210daffa053c52224c1d2ef4f5b38e4ecfcd06a1cc51c39c3a7dccfcb6b507";
        vAddresses[5] =
        hex"ae7bc6faa3f0cc3e6093b633fd7ee4f86970926958d0b7ec80437f936acf212b78f0cd095f4565fff144fd458d233a5b";
        vAddresses[6] =
        hex"84248a459464eec1a21e7fc7b71a053d9644e9bb8da4853b8f872cd7c1d6b324bf1922829830646ceadfb658d3de009a";
        vAddresses[7] =
        hex"a8a257074e82b881cfa06ef3eb4efeca060c2531359abd0eab8af1e3edfa2025fca464ac9c3fd123f6c24a0d78869485";
        vAddresses[8] =
        hex"98cbf822e4bc29f1701ac0350a3d042cd0756e9f74822c6481773ceb000641c51b870a996fe0f6a844510b1061f38cd0";
        vAddresses[9] =
        hex"b772e180fbf38a051c97dabc8aaa0126a233a9e828cdafcc7422c4bb1f4030a56ba364c54103f26bad91508b5220b741";
        vAddresses[10] =
        hex"956c470ddff48cb49300200b5f83497f3a3ccb3aeb83c5edd9818569038e61d197184f4aa6939ea5e9911e3e98ac6d21";
        vAddresses[11] =
        hex"8a80967d39e406a0a9642d41e9007a27fc1150a267d143a9f786cd2b5eecbdcc4036273705225b956d5e2f8f5eb95d25";
        vAddresses[12] =
        hex"b3a3d4feb825ae9702711566df5dbf38e82add4dd1b573b95d2466fa6501ccb81e9d26a352b96150ccbf7b697fd0a419";
        vAddresses[13] =
        hex"b2d4c6283c44a1c7bd503aaba7666e9f0c830e0ff016c1c750a5e48757a713d0836b1cabfd5c281b1de3b77d1c192183";
        vAddresses[14] =
        hex"93c1f7f6929d1fe2a17b4e14614ef9fc5bdc713d6631d675403fbeefac55611bf612700b1b65f4744861b80b0f7d6ab0";
        vAddresses[15] =
        hex"8a60f82a7bcf74b4cb053b9bfe83d0ed02a84ebb10865dfdd8e26e7535c43a1cccd268e860f502216b379dfc9971d358";
        vAddresses[16] =
        hex"939e8fb41b682372335be8070199ad3e8621d1743bcac4cc9d8f0f6e10f41e56461385c8eb5daac804fe3f2bca6ce739";
        vAddresses[17] =
        hex"96a26afa1295da81418593bd12814463d9f6e45c36a0e47eb4cd3e5b6af29c41e2a3a5636430155a466e216585af3ba7";
        vAddresses[18] =
        hex"b1f2c71577def3144fabeb75a8a1c8cb5b51d1d1b4a05eec67988b8685008baa17459ec425dbaebc852f496dc92196cd";
        vAddresses[19] =
        hex"b659ad0fbd9f515893fdd740b29ba0772dbde9b4635921dd91bd2963a0fc855e31f6338f45b211c4e9dedb7f2eb09de7";
        vAddresses[20] =
        hex"8819ec5ec3e97e1f03bbb4bb6055c7a5feac8f4f259df58349a32bb5cb377e2cb1f362b77f1dd398cfd3e9dba46138c3";
        vAddresses[21] =
        hex"b313f9cba57c63a84edb4079140e6dbd7829e5023c9532fce57e9fe602400a2953f4bf7dab66cca16e97be95d4de7044";
        vAddresses[22] =
        hex"b64abe25614c9cfd32e456b4d521f29c8357f4af4606978296c9be93494072ac05fa86e3d27cc8d66e65000f8ba33fbb";
        vAddresses[23] =
        hex"b0bec348681af766751cb839576e9c515a09c8bffa30a46296ccc56612490eb480d03bf948e10005bbcc0421f90b3d4e";
        vAddresses[24] =
        hex"b0245c33bc556cfeb013cd3643b30dbdef6df61a0be3ba00cae104b3c587083852e28f8911689c7033f7021a8a1774c9";
        vAddresses[25] =
        hex"a7f3e2c0b4b16ad183c473bafe30a36e39fa4a143657e229cd23c77f8fbc8e4e4e241695dd3d248d1e51521eee661914";
        vAddresses[26] =
        hex"8fdf49777b22f927d460fa3fcdd7f2ba0cf200634a3dfb5197d7359f2f88aaf496ef8c93a065de0f376d164ff2b6db9a";
        vAddresses[27] =
        hex"8ab17a9148339ef40aed8c177379c4db0bb5efc6f5c57a5d1a6b58b84d4b562e227196c79bda9a136830ed0c09f37813";
        vAddresses[28] =
        hex"8dd20979bd63c14df617a6939c3a334798149151577dd3f1fadb2bd1c1b496bf84c25c879da5f0f9dfdb88c6dd17b1e6";
        vAddresses[29] =
        hex"b679cbab0276ac30ff5f198e5e1dedf6b84959129f70fe7a07fcdf13444ba45b5dbaa7b1f650adf8b0acbecd04e2675b";
        vAddresses[30] =
        hex"8974616fe8ab950a3cded19b1d16ff49c97bf5af65154b3b097d5523eb213f3d35fc5c57e7276c7f2d83be87ebfdcdf9";
        vAddresses[31] =
        hex"ab764a39ff81dad720d5691b852898041a3842e09ecbac8025812d51b32223d8420e6ae51a01582220a10f7722de67c1";
        vAddresses[32] =
        hex"9025b6715c8eaabac0bfccdb2f25d651c9b69b0a184011a4a486b0b2080319d2396e7ca337f2abdf01548b2de1b3ba06";
        vAddresses[33] =
        hex"b2317f59d86abfaf690850223d90e9e7593d91a29331dfc2f84d5adecc75fc39ecab4632c1b4400a3dd1e1298835bcca";

        bytes memory cBz = abi.encode(cAddresses);
        bytes memory vBz = abi.encode(vAddresses);
        emit log_named_bytes("consensus address bytes", cBz);
        emit log_named_bytes("vote address bytes", vBz);
    }

    function _encodeValidatorSetUpdatePack(
        address[] memory valSet,
        uint64[] memory votingPowers,
        bytes[] memory voteAddrs
    ) internal pure returns (bytes memory) {
        bytes[] memory elements = new bytes[](2);
        elements[0] = uint8(0).encodeUint();

        bytes[] memory vals = new bytes[](valSet.length);
        for (uint256 i; i < valSet.length; ++i) {
            bytes[] memory tmp = new bytes[](5);
            tmp[0] = valSet[i].encodeAddress();
            tmp[1] = valSet[i].encodeAddress();
            tmp[2] = valSet[i].encodeAddress();
            tmp[3] = votingPowers[i].encodeUint();
            tmp[4] = voteAddrs[i].encodeBytes();
            vals[i] = tmp.encodeList();
        }

        elements[1] = vals.encodeList();
        return elements.encodeList();
    }

    function testAgent() external {
        // create validator
        (address validator,,,) = _createValidator(2000 ether);
        vm.startPrank(validator);

        // edit failed because of `UpdateTooFrequently`
        vm.expectRevert(StakeHub.UpdateTooFrequently.selector);
        stakeHub.editConsensusAddress(address(1));

        // update agent
        address newAgent = validator;
        vm.expectRevert(StakeHub.InvalidAgent.selector);
        stakeHub.updateAgent(newAgent);

        newAgent = address(0x1234);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit AgentChanged(validator, address(0), newAgent);
        stakeHub.updateAgent(newAgent);

        vm.stopPrank();

        vm.startPrank(newAgent);
        // edit consensus address
        vm.warp(block.timestamp + 1 days);
        address newConsensusAddress = address(0x1234);
        vm.expectEmit(true, true, false, true, address(stakeHub));
        emit ConsensusAddressEdited(validator, newConsensusAddress);
        stakeHub.editConsensusAddress(newConsensusAddress);
        address realConsensusAddr = stakeHub.getValidatorConsensusAddress(validator);
        assertEq(realConsensusAddr, newConsensusAddress);

        // edit commission rate
        vm.warp(block.timestamp + 1 days);
        vm.expectRevert(StakeHub.InvalidCommission.selector);
        stakeHub.editCommissionRate(110);
        vm.expectRevert(StakeHub.InvalidCommission.selector);
        stakeHub.editCommissionRate(16);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit CommissionRateEdited(validator, 15);
        stakeHub.editCommissionRate(15);
        StakeHub.Commission memory realComm = stakeHub.getValidatorCommission(validator);
        assertEq(realComm.rate, 15);

        // edit description
        vm.warp(block.timestamp + 1 days);
        StakeHub.Description memory description = stakeHub.getValidatorDescription(validator);
        description.moniker = "Test";
        description.website = "Test";
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit DescriptionEdited(validator);
        stakeHub.editDescription(description);
        StakeHub.Description memory realDesc = stakeHub.getValidatorDescription(validator);
        assertNotEq(realDesc.moniker, "Test"); // edit moniker will be ignored
        assertEq(realDesc.website, "Test");

        // edit vote address
        vm.warp(block.timestamp + 1 days);
        bytes memory newVoteAddress =
            hex"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234";
        bytes memory blsProof = new bytes(96);
        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit VoteAddressEdited(validator, newVoteAddress);
        stakeHub.editVoteAddress(newVoteAddress, blsProof);
        bytes memory realVoteAddr = stakeHub.getValidatorVoteAddress(validator);
        assertEq(realVoteAddr, newVoteAddress);

        vm.stopPrank();
    }

    function testGetNodeIDs() public {
        // Set maxNodeIDs through governance
        uint256 currentMaxNodeIDs = stakeHub.maxNodeIDs();
        if (currentMaxNodeIDs != 5) {
            vm.prank(GOV_HUB_ADDR);
            stakeHub.updateParam("maxNodeIDs", abi.encode(uint256(5)));
        }

        // Create two validators
        (address validator1,,,) = _createValidator(2000 ether);
        (address validator2,,,) = _createValidator(2000 ether);

        // Add NodeIDs to validator1
        bytes32[] memory nodeIDs1 = new bytes32[](2);
        nodeIDs1[0] = bytes32(0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef);
        nodeIDs1[1] = bytes32(0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890);
        vm.startPrank(validator1);
        stakeHub.addNodeIDs(nodeIDs1);
        vm.stopPrank();

        // Add NodeIDs to validator2
        bytes32[] memory nodeIDs2 = new bytes32[](2);
        nodeIDs2[0] = bytes32(0x1111111111111111111111111111111111111111111111111111111111111111);
        nodeIDs2[1] = bytes32(0x2222222222222222222222222222222222222222222222222222222222222222);
        vm.startPrank(validator2);
        stakeHub.addNodeIDs(nodeIDs2);
        vm.stopPrank();

        // Test getNodeIDs with both validators
        address[] memory validatorsToQuery = new address[](2);
        validatorsToQuery[0] = validator1;
        validatorsToQuery[1] = validator2;

        (address[] memory consensusAddresses, bytes32[][] memory result) = stakeHub.getNodeIDs(validatorsToQuery);
        assertEq(result.length, 2, "Should return results for both validators");
        assertEq(consensusAddresses.length, 2, "Should return consensus addresses for both validators");
        assertEq(result[0].length, 2, "Validator1 should have 2 NodeIDs");
        assertEq(result[1].length, 2, "Validator2 should have 2 NodeIDs");
        assertEq(result[0][0], nodeIDs1[0], "First NodeID of validator1 should match");
        assertEq(result[0][1], nodeIDs1[1], "Second NodeID of validator1 should match");
        assertEq(result[1][0], nodeIDs2[0], "First NodeID of validator2 should match");
        assertEq(result[1][1], nodeIDs2[1], "Second NodeID of validator2 should match");
    }

    function testRemoveNodeIDs() public {
        // Set maxNodeIDs through governance
        uint256 currentMaxNodeIDs = stakeHub.maxNodeIDs();
        if (currentMaxNodeIDs != 5) {
            vm.prank(GOV_HUB_ADDR);
            stakeHub.updateParam("maxNodeIDs", abi.encode(uint256(5)));
        }

        // Create a validator
        (address validator,,,) = _createValidator(2000 ether);

        // Add initial NodeIDs
        bytes32[] memory initialNodeIDs = new bytes32[](3);
        initialNodeIDs[0] = bytes32(0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef);
        initialNodeIDs[1] = bytes32(0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890);
        initialNodeIDs[2] = bytes32(0x1111111111111111111111111111111111111111111111111111111111111111);
        vm.startPrank(validator);
        stakeHub.addNodeIDs(initialNodeIDs);

        // Remove some NodeIDs
        bytes32[] memory nodeIDsToRemove = new bytes32[](2);
        nodeIDsToRemove[0] = initialNodeIDs[0];
        nodeIDsToRemove[1] = initialNodeIDs[2];

        // Test event emissions
        vm.expectEmit(true, true, false, false);
        emit NodeIDRemoved(validator, initialNodeIDs[0]);
        vm.expectEmit(true, true, false, false);
        emit NodeIDRemoved(validator, initialNodeIDs[2]);

        stakeHub.removeNodeIDs(nodeIDsToRemove);

        // Verify the removal
        address[] memory validatorsToQuery = new address[](1);
        validatorsToQuery[0] = validator;
        (, bytes32[][] memory result) = stakeHub.getNodeIDs(validatorsToQuery);

        assertEq(result[0].length, 1, "Should have 1 remaining NodeID");
        assertEq(result[0][0], initialNodeIDs[1], "Remaining NodeID should match");

        // Test removing all NodeIDs
        bytes32[] memory removeAll = new bytes32[](0);
        vm.expectEmit(true, true, false, false);
        emit NodeIDRemoved(validator, initialNodeIDs[1]);
        stakeHub.removeNodeIDs(removeAll);

        // Verify all NodeIDs are removed
        (, result) = stakeHub.getNodeIDs(validatorsToQuery);
        assertEq(result[0].length, 0, "Should have no NodeIDs remaining");
    }

    function testAddNodeIDs() public {
        // Set maxNodeIDs through governance
        uint256 currentMaxNodeIDs = stakeHub.maxNodeIDs();
        if (currentMaxNodeIDs != 5) {
            vm.prank(GOV_HUB_ADDR);
            stakeHub.updateParam("maxNodeIDs", abi.encode(uint256(5)));
        }

        // Create a validator
        (address validator,,,) = _createValidator(2000 ether);

        // Add initial NodeIDs to reach exactly 5
        bytes32[] memory initialNodeIDs = new bytes32[](5);
        initialNodeIDs[0] = bytes32(0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef);
        initialNodeIDs[1] = bytes32(0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890);
        initialNodeIDs[2] = bytes32(0x1111111111111111111111111111111111111111111111111111111111111111);
        initialNodeIDs[3] = bytes32(0x2222222222222222222222222222222222222222222222222222222222222222);
        initialNodeIDs[4] = bytes32(0x3333333333333333333333333333333333333333333333333333333333333333);

        // Test event emissions
        vm.startPrank(validator);
        vm.expectEmit(true, true, false, false);
        emit NodeIDAdded(validator, initialNodeIDs[0]);
        vm.expectEmit(true, true, false, false);
        emit NodeIDAdded(validator, initialNodeIDs[1]);
        vm.expectEmit(true, true, false, false);
        emit NodeIDAdded(validator, initialNodeIDs[2]);
        vm.expectEmit(true, true, false, false);
        emit NodeIDAdded(validator, initialNodeIDs[3]);
        vm.expectEmit(true, true, false, false);
        emit NodeIDAdded(validator, initialNodeIDs[4]);

        stakeHub.addNodeIDs(initialNodeIDs);

        // Verify the addition
        address[] memory validatorsToQuery = new address[](1);
        validatorsToQuery[0] = validator;
        (, bytes32[][] memory result) = stakeHub.getNodeIDs(validatorsToQuery);

        assertEq(result[0].length, 5, "Should have 5 NodeIDs");
        assertEq(result[0][0], initialNodeIDs[0], "First NodeID should match");
        assertEq(result[0][1], initialNodeIDs[1], "Second NodeID should match");
        assertEq(result[0][2], initialNodeIDs[2], "Third NodeID should match");
        assertEq(result[0][3], initialNodeIDs[3], "Fourth NodeID should match");
        assertEq(result[0][4], initialNodeIDs[4], "Fifth NodeID should match");

        // Test error cases
        // Test with too many NodeIDs - use unique NodeIDs to avoid DuplicateNodeID error
        bytes32[] memory tooManyNodeIDs = new bytes32[](1);
        tooManyNodeIDs[0] = bytes32(0x4444444444444444444444444444444444444444444444444444444444444444);
        vm.expectRevert(ExceedsMaxNodeIDs.selector);
        stakeHub.addNodeIDs(tooManyNodeIDs);
    }
}
