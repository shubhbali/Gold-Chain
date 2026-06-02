pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "./utils/interface/IGiltValidatorSet.sol";

contract ValidatorSetBootstrapTest is Test {
    address payable internal constant VALIDATOR_SET_ADDR = payable(0x0000000000000000000000000000000000001000);
    address internal constant STAKE_HUB_ADDR = 0x0000000000000000000000000000000000002002;
    address internal constant LAUNCH_CONSENSUS = 0x225D6AF01985dd4f627abbe1ee0062Fce8C3f5D0;
    address internal constant LAUNCH_FEE = 0x225D6AF01985dd4f627abbe1ee0062Fce8C3f5D0;
    bytes32 internal constant LAUNCH_BOOTSTRAP_HASH =
        0x8d4c749d7fa4f4bd8346eb81b45bcdaf701db25a47b3dc6111f6e4eccd618b82;

    uint256 internal constant SLOT_ALREADY_INIT = 0;
    uint256 internal constant SLOT_CURRENT_VALIDATOR_SET = 1;
    uint256 internal constant SLOT_CURRENT_VALIDATOR_SET_MAP = 4;
    uint256 internal constant SLOT_MAX_NUM_OF_MAINTAINING = 8;
    uint256 internal constant SLOT_MAINTAIN_SLASH_SCALE = 10;
    uint256 internal constant SLOT_VALIDATOR_EXTRA_SET = 11;
    uint256 internal constant SLOT_MAX_NUM_OF_CANDIDATES = 13;
    uint256 internal constant SLOT_PREVIOUS_VOTE_ADDR_FULL_SET = 18;
    uint256 internal constant SLOT_CURRENT_VOTE_ADDR_FULL_SET = 19;
    uint256 internal constant SLOT_TURN_LENGTH = 23;
    uint256 internal constant SLOT_VALIDATOR_BOOTSTRAP_HASH = 28;

    GiltValidatorSet internal validatorSet;

    function setUp() public {
        bytes memory deployedCode = vm.getDeployedCode("GiltValidatorSet.sol:GiltValidatorSet");
        vm.etch(VALIDATOR_SET_ADDR, deployedCode);
        validatorSet = GiltValidatorSet(VALIDATOR_SET_ADDR);
    }

    function testInitRejectsMissingGeneratedBootstrapState() public {
        vm.expectRevert("missing genesis validators");
        validatorSet.init();
    }

    function testDeprecatedCrossChainHandlerSelectorsAreAbsent() public {
        _assertSelectorAbsent("handleSynPackage(uint8,bytes)");
        _assertSelectorAbsent("handleAckPackage(uint8,bytes)");
        _assertSelectorAbsent("handleFailAckPackage(uint8,bytes)");
    }

    function testDeprecatedTmpMigrationSurfaceIsInert() public {
        vm.prank(STAKE_HUB_ADDR);
        vm.expectRevert("deprecated");
        validatorSet.removeTmpMigratedValidator(LAUNCH_CONSENSUS);
    }

    function testGeneratedBootstrapValidatorsAvailableBeforeInit() public {
        _seedGeneratedBootstrapState();

        assertFalse(validatorSet.alreadyInit(), "generated state should still require init validation");
        address[] memory validators = validatorSet.getValidators();
        assertEq(validators.length, 1, "generated bootstrap validator set should not be empty");
        assertEq(validators[0], LAUNCH_CONSENSUS, "wrong generated bootstrap validator");
        assertTrue(validatorSet.isCurrentValidator(LAUNCH_CONSENSUS), "generated bootstrap validator should be active");

        (address[] memory miningValidators, bytes[] memory voteAddrs) = validatorSet.getMiningValidators();
        assertEq(miningValidators.length, validators.length, "bootstrap mining validator count mismatch");
        assertEq(miningValidators[0], LAUNCH_CONSENSUS, "wrong bootstrap mining validator");
        assertEq(voteAddrs.length, miningValidators.length, "bootstrap vote address count mismatch");
        assertEq(voteAddrs[0], _launchVoteAddress(), "wrong generated bootstrap vote address");
        assertEq(validatorSet.getTurnLength(), 16, "bootstrap turn length should come from generated state");

        (address consensusAddress, address payable feeAddress, address giltFeeAddress, uint64 votingPower,,) =
            validatorSet.currentValidatorSet(0);
        assertEq(consensusAddress, LAUNCH_CONSENSUS, "wrong generated consensus address");
        assertEq(feeAddress, payable(LAUNCH_FEE), "wrong generated fee address");
        assertEq(giltFeeAddress, LAUNCH_FEE, "wrong generated GILT fee address");
        assertEq(votingPower, 100, "wrong generated voting power");
    }

    function testInitPreservesGeneratedBootstrapValidatorSet() public {
        _seedGeneratedBootstrapState();
        address[] memory bootstrapValidators = validatorSet.getValidators();
        validatorSet.init();

        address[] memory validators = validatorSet.getValidators();
        assertEq(validators.length, bootstrapValidators.length, "wrong initialized validator count");
        assertEq(validators[0], bootstrapValidators[0], "wrong initialized validator");
        assertTrue(validatorSet.isCurrentValidator(bootstrapValidators[0]), "initialized validator should be active");
        assertEq(validatorSet.validatorBootstrapHash(), LAUNCH_BOOTSTRAP_HASH, "wrong bootstrap hash");
        assertTrue(validatorSet.alreadyInit(), "validator set should be initialized after validation");
        assertGt(validatorSet.getTurnLength(), 0, "turn length should be initialized");
    }

    function _seedGeneratedBootstrapState() internal {
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_CURRENT_VALIDATOR_SET), _word(1));
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_VALIDATOR_EXTRA_SET), _word(1));
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_PREVIOUS_VOTE_ADDR_FULL_SET), _word(1));
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_CURRENT_VOTE_ADDR_FULL_SET), _word(1));

        uint256 validatorBase = uint256(keccak256(abi.encode(SLOT_CURRENT_VALIDATOR_SET)));
        vm.store(VALIDATOR_SET_ADDR, _slot(validatorBase), _word(uint160(LAUNCH_CONSENSUS)));
        vm.store(VALIDATOR_SET_ADDR, _slot(validatorBase + 1), _word(uint160(LAUNCH_FEE)));
        vm.store(VALIDATOR_SET_ADDR, _slot(validatorBase + 2), _word(uint160(LAUNCH_FEE) + (uint256(100) << 160)));
        vm.store(VALIDATOR_SET_ADDR, _slot(validatorBase + 3), _word(0));

        vm.store(VALIDATOR_SET_ADDR, keccak256(abi.encode(LAUNCH_CONSENSUS, SLOT_CURRENT_VALIDATOR_SET_MAP)), _word(1));

        uint256 validatorExtraBase = uint256(keccak256(abi.encode(SLOT_VALIDATOR_EXTRA_SET)));
        bytes memory launchVoteAddress = _launchVoteAddress();
        _storeDynamicBytes(validatorExtraBase + 2, launchVoteAddress);
        _storeDynamicBytes(uint256(keccak256(abi.encode(SLOT_PREVIOUS_VOTE_ADDR_FULL_SET))), launchVoteAddress);
        _storeDynamicBytes(uint256(keccak256(abi.encode(SLOT_CURRENT_VOTE_ADDR_FULL_SET))), launchVoteAddress);

        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_MAX_NUM_OF_MAINTAINING), _word(3));
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_MAINTAIN_SLASH_SCALE), _word(2));
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_MAX_NUM_OF_CANDIDATES), _word(15));
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_TURN_LENGTH), _word(16));
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_VALIDATOR_BOOTSTRAP_HASH), LAUNCH_BOOTSTRAP_HASH);
        vm.store(VALIDATOR_SET_ADDR, _slot(SLOT_ALREADY_INIT), _word(0));
    }

    function _assertSelectorAbsent(
        string memory signature
    ) internal {
        (bool ok, bytes memory response) =
            address(validatorSet).call(abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), uint8(0), bytes("")));
        assertFalse(ok, signature);
        assertEq(response.length, 0, signature);
    }

    function _storeDynamicBytes(
        uint256 slotNumber,
        bytes memory value
    ) internal {
        require(value.length == 48, "vote address fixture must be 48 bytes");
        vm.store(VALIDATOR_SET_ADDR, _slot(slotNumber), _word(value.length * 2 + 1));

        uint256 dataSlot = uint256(keccak256(abi.encode(slotNumber)));
        bytes32 firstWord;
        bytes32 secondWord;
        assembly {
            firstWord := mload(add(value, 32))
            secondWord := mload(add(value, 64))
        }
        vm.store(VALIDATOR_SET_ADDR, _slot(dataSlot), firstWord);
        vm.store(VALIDATOR_SET_ADDR, _slot(dataSlot + 1), secondWord);
    }

    function _launchVoteAddress() internal pure returns (bytes memory) {
        return hex"81c0ae1ad54aeaea61d454dbfc58e5268e659b46ccd5099b31c5167698af671f709484b753b84c99ed0b8f2a83a8c1a9";
    }

    function _slot(
        uint256 slotNumber
    ) internal pure returns (bytes32) {
        return bytes32(slotNumber);
    }

    function _word(
        uint256 value
    ) internal pure returns (bytes32) {
        return bytes32(value);
    }
}
