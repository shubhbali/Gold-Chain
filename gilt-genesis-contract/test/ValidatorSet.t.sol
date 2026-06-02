pragma solidity ^0.8.10;

import "./utils/Deployer.sol";

contract ValidatorSetTest is Deployer {
    using RLPEncode for *;

    event validatorSetUpdated();
    event systemTransfer(uint256 amount);
    event RewardDistributed(address indexed operatorAddress, uint256 reward);
    event deprecatedDeposit(address indexed validator, uint256 amount);
    event validatorDeposit(address indexed validator, uint256 amount);
    event inflationRewardDeposit(address indexed validator, uint256 amount);
    event failReasonWithStr(string message);
    event finalityRewardDeposit(address indexed validator, uint256 amount);
    event deprecatedFinalityRewardDeposit(address indexed validator, uint256 amount);
    event deprecatedInflationRewardDeposit(address indexed validator, uint256 amount);
    event ConsensusEmergencyHalt(address indexed validator, uint256 haltTimestamp);
    event RecoveryValidatorSetApplied(address indexed operator, uint256 validatorCount);
    event ConsensusRecovered(address indexed operator, uint256 validatorCount);
    event unsupportedPackage(uint64 indexed packageSequence, uint8 indexed channelId, bytes payload);

    uint256 public totalInComing;
    uint256 public burnRatio;
    uint256 public burnRatioScale;
    uint256 public maxNumOfWorkingCandidates;
    uint256 public numOfCabinets;
    uint256 public systemRewardBaseRatio;
    uint256 public systemRewardRatioScale;

    address public coinbase;
    address public validator0;
    mapping(address => bool) public cabinets;

    function setUp() public {
        // add operator
        bytes memory key = "addOperator";
        bytes memory valueBytes = abi.encodePacked(address(giltValidatorSet));
        vm.expectEmit(false, false, false, true, address(systemReward));
        emit paramChange(string(key), valueBytes);
        _updateParamByGovHub(key, valueBytes, address(systemReward));
        assertTrue(systemReward.isOperator(address(giltValidatorSet)));

        burnRatio =
            giltValidatorSet.isSystemRewardIncluded() ? giltValidatorSet.burnRatio() : giltValidatorSet.INIT_BURN_RATIO();
        burnRatioScale = giltValidatorSet.BLOCK_FEES_RATIO_SCALE();
        systemRewardBaseRatio = giltValidatorSet.isSystemRewardIncluded()
            ? giltValidatorSet.systemRewardBaseRatio()
            : giltValidatorSet.INIT_SYSTEM_REWARD_RATIO();
        systemRewardRatioScale = giltValidatorSet.BLOCK_FEES_RATIO_SCALE();
        totalInComing = giltValidatorSet.totalInComing();
        maxNumOfWorkingCandidates = giltValidatorSet.maxNumOfWorkingCandidates();
        numOfCabinets = giltValidatorSet.numOfCabinets();

        address[] memory validators = giltValidatorSet.getValidators();
        validator0 = validators[0];

        coinbase = block.coinbase;
        vm.deal(coinbase, 100 ether);

        // set gas price to zero to send system slash tx
        vm.txGasPrice(0);
        vm.mockCall(address(0x66), bytes(""), hex"01");
    }

    function testDeposit(uint256 amount) public {
        vm.assume(amount >= 1e16);
        vm.assume(amount <= 1e19);

        vm.expectRevert("the message sender must be the block producer");
        giltValidatorSet.deposit{ value: amount }(validator0);

        vm.startPrank(coinbase);
        vm.expectRevert("deposit value is zero");
        giltValidatorSet.deposit(validator0);

        uint256 realAmount0 = _calcIncoming(amount);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit validatorDeposit(validator0, realAmount0);
        giltValidatorSet.deposit{ value: amount }(validator0);

        vm.stopPrank();
        assertEq(giltValidatorSet.getTurnLength(), 16);
        bytes memory key = "turnLength";
        bytes memory value = bytes(hex"0000000000000000000000000000000000000000000000000000000000000005"); // 5
        _updateParamByGovHub(key, value, address(giltValidatorSet));
        assertEq(giltValidatorSet.getTurnLength(), 5);

        key = "systemRewardAntiMEVRatio";
        value = bytes(hex"0000000000000000000000000000000000000000000000000000000000000200"); // 512
        _updateParamByGovHub(key, value, address(giltValidatorSet));
        assertEq(giltValidatorSet.systemRewardAntiMEVRatio(), 512);
        vm.startPrank(coinbase);

        uint256 realAmount1 = _calcIncoming(amount);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit validatorDeposit(validator0, realAmount1);
        giltValidatorSet.deposit{ value: amount }(validator0);

        address newAccount = _getNextUserAddress();
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit deprecatedDeposit(newAccount, realAmount1);
        giltValidatorSet.deposit{ value: amount }(newAccount);

        assertEq(giltValidatorSet.totalInComing(), totalInComing + realAmount0 + realAmount1);
        vm.stopPrank();
    }

    function testGov() public {
        bytes memory key = "maxNumOfWorkingCandidates";
        bytes memory value = bytes(hex"0000000000000000000000000000000000000000000000000000000000000015"); // 21
        vm.expectEmit(false, false, false, true, address(govHub));
        emit failReasonWithStr("the maxNumOfWorkingCandidates must be not greater than maxNumOfCandidates");
        _updateParamByGovHub(key, value, address(giltValidatorSet));
        assertEq(giltValidatorSet.maxNumOfWorkingCandidates(), maxNumOfWorkingCandidates);

        value = bytes(hex"000000000000000000000000000000000000000000000000000000000000000a"); // 10
        _updateParamByGovHub(key, value, address(giltValidatorSet));
        assertEq(giltValidatorSet.maxNumOfWorkingCandidates(), 10);

        key = "maxNumOfCandidates";
        value = bytes(hex"0000000000000000000000000000000000000000000000000000000000000005"); // 5
        _updateParamByGovHub(key, value, address(giltValidatorSet));
        assertEq(giltValidatorSet.maxNumOfCandidates(), 5);
        assertEq(giltValidatorSet.maxNumOfWorkingCandidates(), 5);

        key = "systemRewardBaseRatio";
        value = bytes(hex"0000000000000000000000000000000000000000000000000000000000000400"); // 1024
        _updateParamByGovHub(key, value, address(giltValidatorSet));
        assertEq(giltValidatorSet.systemRewardBaseRatio(), 1024);
    }

    function testDepositInflationBypassesFeeSkims() public {
        (address operatorAddress, address consensusAddress,, bytes memory voteAddress) = _createValidator(2000 ether);
        address[] memory consensusAddrs = new address[](1);
        uint64[] memory votingPowers = new uint64[](1);
        bytes[] memory voteAddrs = new bytes[](1);
        consensusAddrs[0] = consensusAddress;
        votingPowers[0] = 2000 * 1e8;
        voteAddrs[0] = voteAddress;

        vm.prank(coinbase);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

        uint256 amount;
        uint256 systemRewardBefore = address(systemReward).balance;
        uint256 burnBefore = address(0x000000000000000000000000000000000000dEaD).balance;
        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();

        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(2_000_000 ether)));
        stakeHub.updateParam("inflationEnabled", hex"01");
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        amount = stakeHub.expectedInflationMintAmount(dayIndex);
        assertGt(amount, 0, "expected inflation amount must be non-zero");
        vm.stopPrank();

        vm.deal(coinbase, coinbase.balance + amount);
        vm.startPrank(coinbase);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit inflationRewardDeposit(consensusAddress, amount);
        giltValidatorSet.depositInflation{ value: amount }(consensusAddress);
        vm.stopPrank();

        assertEq(operatorAddress, stakeHub.consensusToOperator(consensusAddress), "validator must exist in stake hub");
        assertEq(giltValidatorSet.getIncoming(consensusAddress), 0, "inflation should not sit in validator incoming");
        assertEq(giltValidatorSet.totalInComing(), totalInComing, "inflation should not change validator incoming totals");
        assertEq(address(systemReward).balance, systemRewardBefore, "inflation should not fund system reward");
        assertEq(address(0x000000000000000000000000000000000000dEaD).balance, burnBefore, "inflation should not burn");
        assertEq(stakeHub.inflationMintedAmount(), amount, "wrong minted inflation amount");
        assertEq(stakeHub.inflationDistributedAmount(), amount, "inflation should be distributed immediately");
    }

    function testDepositInflationRejectsNonCanonicalAmount() public {
        (, address consensusAddress,, bytes memory voteAddress) = _createValidator(2000 ether);
        address[] memory consensusAddrs = new address[](1);
        uint64[] memory votingPowers = new uint64[](1);
        bytes[] memory voteAddrs = new bytes[](1);
        consensusAddrs[0] = consensusAddress;
        votingPowers[0] = 2000 * 1e8;
        voteAddrs[0] = voteAddress;

        vm.prank(coinbase);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

        uint256 dayIndex = block.timestamp / stakeHub.BREATHE_BLOCK_INTERVAL();
        vm.startPrank(GOV_HUB_ADDR);
        stakeHub.updateParam("inflationBaseSupply", abi.encode(uint256(2_000_000 ether)));
        stakeHub.updateParam("inflationEnabled", hex"01");
        stakeHub.updateParam("inflationStartDayIndex", abi.encode(dayIndex));
        uint256 expectedAmount = stakeHub.expectedInflationMintAmount(dayIndex);
        assertGt(expectedAmount, 1, "expected inflation amount too small for mismatch test");
        vm.stopPrank();

        vm.deal(coinbase, coinbase.balance + expectedAmount);
        vm.startPrank(coinbase);
        vm.expectRevert("invalid inflation amount");
        giltValidatorSet.depositInflation{ value: expectedAmount - 1 }(consensusAddress);
        vm.stopPrank();
    }

    function testConsensusEmergencyHaltAndGovernanceRecovery() public {
        (, address consensusAddress,, bytes memory voteAddress) = _createValidator(2000 ether);
        address[] memory consensusAddrs = new address[](1);
        uint64[] memory votingPowers = new uint64[](1);
        bytes[] memory voteAddrs = new bytes[](1);
        consensusAddrs[0] = consensusAddress;
        votingPowers[0] = 2000 * 1e8;
        voteAddrs[0] = voteAddress;

        vm.prank(coinbase);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

        vm.prank(STAKE_HUB_ADDR);
        giltValidatorSet.activateConsensusEmergencyHalt(consensusAddress);
        assertTrue(giltValidatorSet.consensusEmergencyHalt(), "consensus halt should be active");
        assertEq(giltValidatorSet.getValidators().length, 0, "halt should remove active producers");
        assertEq(giltValidatorSet.getWorkingValidatorCount(), 0, "working validator count should be zero in halt");

        vm.prank(GOV_HUB_ADDR);
        giltValidatorSet.recoverConsensus(consensusAddrs, votingPowers, voteAddrs);

        assertFalse(giltValidatorSet.consensusEmergencyHalt(), "consensus halt should clear after recovery");
        address[] memory activeValidators = giltValidatorSet.getValidators();
        assertEq(activeValidators.length, 1, "recovery should restore validator set");
        assertEq(activeValidators[0], consensusAddress, "wrong recovered validator");
    }

    function testValidateSetChange() public {
        for (uint256 i; i < 5; ++i) {
            (, address[] memory consensusAddrs, uint64[] memory votingPowers, bytes[] memory voteAddrs) =
                _batchCreateValidators(5);
            vm.prank(coinbase);
            giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

            address[] memory valSet = giltValidatorSet.getValidators();
            for (uint256 j; j < 5; ++j) {
                assertEq(valSet[j], consensusAddrs[j], "consensus address not equal");
                assertTrue(giltValidatorSet.isCurrentValidator(consensusAddrs[j]), "the address should be a validator");
            }
        }
    }

    function testGetMiningValidatorsWith41Vals() public {
        (, address[] memory consensusAddrs, uint64[] memory votingPowers, bytes[] memory voteAddrs) =
            _batchCreateValidators(41);
        vm.prank(coinbase);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

        address[] memory vals = giltValidatorSet.getValidators();
        (address[] memory miningVals,) = giltValidatorSet.getMiningValidators();

        uint256 count;
        uint256 _numOfCabinets;
        uint256 _maxNumOfWorkingCandidates = maxNumOfWorkingCandidates;
        if (numOfCabinets == 0) {
            _numOfCabinets = giltValidatorSet.INIT_NUM_OF_CABINETS();
        } else {
            _numOfCabinets = numOfCabinets;
        }
        if ((vals.length - _numOfCabinets) < _maxNumOfWorkingCandidates) {
            _maxNumOfWorkingCandidates = vals.length - _numOfCabinets;
        }

        for (uint256 i; i < _numOfCabinets; ++i) {
            cabinets[vals[i]] = true;
        }
        for (uint256 i; i < _numOfCabinets; ++i) {
            if (!cabinets[miningVals[i]]) {
                ++count;
            }
        }
        assertGe(_maxNumOfWorkingCandidates, count);
        assertGe(count, 0);
    }

    function testDistributeAlgorithm() public {
        (
            address[] memory operatorAddrs,
            address[] memory consensusAddrs,
            uint64[] memory votingPowers,
            bytes[] memory voteAddrs
        ) = _batchCreateValidators(1);

        vm.startPrank(coinbase);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

        address val = consensusAddrs[0];
        address deprecated = _getNextUserAddress();
        vm.deal(address(giltValidatorSet), 0);

        for (uint256 i; i < 5; ++i) {
            giltValidatorSet.deposit{ value: 1 ether }(val);
            giltValidatorSet.deposit{ value: 1 ether }(deprecated);
            giltValidatorSet.deposit{ value: 0.1 ether }(val);
            giltValidatorSet.deposit{ value: 0.1 ether }(deprecated);
        }

        uint256 expectedBalance = _calcIncoming(11 ether);
        uint256 expectedIncoming = _calcIncoming(5.5 ether);
        uint256 balance = address(giltValidatorSet).balance;
        uint256 incoming = giltValidatorSet.totalInComing();
        assertEq(balance, expectedBalance);
        assertEq(incoming, expectedIncoming);

        vm.expectEmit(true, false, false, true, address(stakeHub));
        emit RewardDistributed(operatorAddrs[0], expectedIncoming);
        vm.expectEmit(false, false, false, true, address(giltValidatorSet));
        emit systemTransfer(expectedBalance - expectedIncoming);
        vm.expectEmit(false, false, false, false, address(giltValidatorSet));
        emit validatorSetUpdated();
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

        vm.stopPrank();
    }

    function testMassiveDistribute() public {
        (
            address[] memory operatorAddrs,
            address[] memory consensusAddrs,
            uint64[] memory votingPowers,
            bytes[] memory voteAddrs
        ) = _batchCreateValidators(41);

        vm.startPrank(coinbase);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);

        for (uint256 i; i < 41; ++i) {
            giltValidatorSet.deposit{ value: 1 ether }(consensusAddrs[i]);
        }
        vm.stopPrank();

        (operatorAddrs, consensusAddrs, votingPowers, voteAddrs) = _batchCreateValidators(41);
        vm.prank(coinbase);
        giltValidatorSet.updateValidatorSetV2(consensusAddrs, votingPowers, voteAddrs);
    }

    function testDistributeFinalityReward() public {
        address[] memory addrs = new address[](20);
        uint256[] memory weights = new uint256[](20);
        address[] memory vals = giltValidatorSet.getValidators();
        for (uint256 i; i < 10; ++i) {
            addrs[i] = vals[i];
            weights[i] = 1;
        }

        for (uint256 i = 10; i < 20; ++i) {
            vals[i] = _getNextUserAddress();
            weights[i] = 1;
        }

        // failed case
        uint256 ceil = giltValidatorSet.MAX_SYSTEM_REWARD_BALANCE();
        vm.deal(address(systemReward), ceil - 1);
        vm.expectRevert(bytes("the message sender must be the block producer"));
        giltValidatorSet.distributeFinalityReward(addrs, weights);

        vm.startPrank(coinbase);
        giltValidatorSet.distributeFinalityReward(addrs, weights);
        vm.expectRevert(bytes("can not do this twice in one block"));
        giltValidatorSet.distributeFinalityReward(addrs, weights);

        // success case
        // balanceOfSystemReward > MAX_SYSTEM_REWARD_BALANCE
        uint256 reward = 1 ether;
        vm.deal(address(systemReward), ceil + reward);
        vm.roll(block.number + 1);

        uint256 expectReward = reward / 20;
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit finalityRewardDeposit(addrs[0], expectReward);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit finalityRewardDeposit(addrs[9], expectReward);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit deprecatedFinalityRewardDeposit(addrs[10], expectReward);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit deprecatedFinalityRewardDeposit(addrs[19], expectReward);
        giltValidatorSet.distributeFinalityReward(addrs, weights);
        assertEq(address(systemReward).balance, ceil);

        // cannot exceed MAX_REWARDS
        uint256 cap = systemReward.MAX_REWARDS();
        vm.deal(address(systemReward), ceil + cap * 2);
        vm.roll(block.number + 1);

        expectReward = cap / 20;
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit finalityRewardDeposit(addrs[0], expectReward);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit finalityRewardDeposit(addrs[9], expectReward);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit deprecatedFinalityRewardDeposit(addrs[10], expectReward);
        vm.expectEmit(true, false, false, true, address(giltValidatorSet));
        emit deprecatedFinalityRewardDeposit(addrs[19], expectReward);
        giltValidatorSet.distributeFinalityReward(addrs, weights);
        assertEq(address(systemReward).balance, ceil + cap);

        vm.stopPrank();
    }

    function _calcIncoming(uint256 value) internal view returns (uint256 incoming) {
        uint256 turnLength = giltValidatorSet.getTurnLength();
        uint256 systemRewardAntiMEVRatio = giltValidatorSet.systemRewardAntiMEVRatio();
        uint256 systemRewardRatio = systemRewardBaseRatio;
        if (turnLength > 1 && systemRewardAntiMEVRatio > 0) {
            systemRewardRatio += systemRewardAntiMEVRatio * (block.number % turnLength) / (turnLength - 1);
        }
        uint256 toSystemReward = (value * systemRewardRatio) / systemRewardRatioScale;
        uint256 toBurn = (value * burnRatio) / burnRatioScale;
        incoming = value - toSystemReward - toBurn;
    }
}
