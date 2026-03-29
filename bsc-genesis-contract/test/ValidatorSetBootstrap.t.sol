pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "./utils/interface/IBSCValidatorSet.sol";

contract ValidatorSetBootstrapTest is Test {
    address payable internal constant VALIDATOR_SET_ADDR = payable(0x0000000000000000000000000000000000001000);

    BSCValidatorSet internal validatorSet;

    function setUp() public {
        bytes memory deployedCode = vm.getDeployedCode("BSCValidatorSet.sol:BSCValidatorSet");
        vm.etch(VALIDATOR_SET_ADDR, deployedCode);
        validatorSet = BSCValidatorSet(VALIDATOR_SET_ADDR);
    }

    function testBootstrapValidatorsAvailableBeforeInit() public view {
        address[] memory validators = validatorSet.getValidators();
        assertGt(validators.length, 0, "bootstrap validator set should not be empty");
        assertTrue(validatorSet.isCurrentValidator(validators[0]), "bootstrap validator should be active");

        (address[] memory miningValidators, bytes[] memory voteAddrs) = validatorSet.getMiningValidators();
        assertEq(miningValidators.length, validators.length, "bootstrap mining validator count mismatch");
        assertEq(miningValidators[0], validators[0], "wrong bootstrap mining validator");
        assertEq(voteAddrs.length, miningValidators.length, "bootstrap vote address count mismatch");
        assertEq(validatorSet.getTurnLength(), 1, "bootstrap turn length should fall back to 1");
    }

    function testInitPreservesBootstrapValidatorSet() public {
        address[] memory bootstrapValidators = validatorSet.getValidators();
        validatorSet.init();

        address[] memory validators = validatorSet.getValidators();
        assertEq(validators.length, bootstrapValidators.length, "wrong initialized validator count");
        assertEq(validators[0], bootstrapValidators[0], "wrong initialized validator");
        assertTrue(validatorSet.isCurrentValidator(bootstrapValidators[0]), "initialized validator should be active");
        assertGt(validatorSet.getTurnLength(), 0, "turn length should be initialized");
    }
}
