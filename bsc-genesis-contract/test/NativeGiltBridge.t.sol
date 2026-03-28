pragma solidity ^0.8.10;

import "./utils/Deployer.sol";

contract NativeGiltBridgeTest is Deployer {
    event ChildChainManagerUpdated(address indexed childChainManager);
    event NativeGiltDeposited(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function testOnlyGovernorCanSetChildChainManager() public {
        vm.expectRevert();
        nativeGiltBridge.setChildChainManager(address(0x1234));

        vm.expectEmit(true, false, false, true);
        emit ChildChainManagerUpdated(address(0x1234));
        vm.prank(GOVERNOR_ADDR);
        nativeGiltBridge.setChildChainManager(address(0x1234));

        assertEq(nativeGiltBridge.childChainManager(), address(0x1234));
    }

    function testDepositRequiresConfiguredChildChainManager() public {
        vm.prank(GOVERNOR_ADDR);
        nativeGiltBridge.setChildChainManager(address(0x1234));

        vm.expectRevert(NativeGiltBridge.OnlyChildChainManager.selector);
        nativeGiltBridge.deposit(address(0xBEEF), abi.encode(1 ether));

        vm.expectEmit(true, false, false, true);
        emit NativeGiltDeposited(address(0xBEEF), 1 ether);
        vm.prank(address(0x1234));
        nativeGiltBridge.deposit(address(0xBEEF), abi.encode(1 ether));
    }

    function testWithdrawEmitsBurnTransfer() public {
        address user = address(0xBEEF);
        vm.deal(user, 10 ether);

        vm.expectEmit(true, true, false, true);
        emit Transfer(user, address(0), 3 ether);
        vm.prank(user);
        nativeGiltBridge.withdraw(3 ether);
    }

    function testWithdrawRevertsWithoutEnoughBalance() public {
        address user = address(0xCAFE);
        vm.expectRevert(NativeGiltBridge.InsufficientBalance.selector);
        vm.prank(user);
        nativeGiltBridge.withdraw(1 ether);
    }
}
