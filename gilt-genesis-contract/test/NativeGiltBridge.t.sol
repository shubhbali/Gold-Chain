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

    function testGovHubCanUpdateChildChainManagerParam() public {
        bytes memory value = abi.encodePacked(address(0x5678));

        vm.expectRevert();
        nativeGiltBridge.updateParam("childChainManager", value);

        vm.expectEmit(true, false, false, true);
        emit ChildChainManagerUpdated(address(0x5678));
        vm.prank(GOV_HUB_ADDR);
        nativeGiltBridge.updateParam("childChainManager", value);

        assertEq(nativeGiltBridge.childChainManager(), address(0x5678));
    }

    function testDepositRequiresConfiguredChildChainManager() public {
        vm.prank(GOVERNOR_ADDR);
        nativeGiltBridge.setChildChainManager(address(0x1234));

        vm.expectRevert(NativeGiltBridge.OnlyChildChainManager.selector);
        nativeGiltBridge.deposit(address(0xBEEF), abi.encode(1 ether));

        vm.deal(address(nativeGiltBridge), 2 ether);
        uint256 beforeBalance = address(0xBEEF).balance;
        vm.expectEmit(true, false, false, true);
        emit NativeGiltDeposited(address(0xBEEF), 1 ether);
        vm.prank(address(0x1234));
        nativeGiltBridge.deposit(address(0xBEEF), abi.encode(1 ether));
        assertEq(address(0xBEEF).balance, beforeBalance + 1 ether);
    }

    function testWithdrawLocksNativeValueAndEmitsTransfer() public {
        address user = address(0xBEEF);
        vm.deal(user, 10 ether);

        uint256 bridgeBefore = address(nativeGiltBridge).balance;
        vm.expectEmit(true, true, false, true);
        emit Transfer(user, address(0), 3 ether);
        vm.prank(user);
        nativeGiltBridge.withdraw{value: 3 ether}(3 ether);
        assertEq(address(nativeGiltBridge).balance, bridgeBefore + 3 ether);
    }

    function testWithdrawRevertsOnWrongMsgValue() public {
        address user = address(0xCAFE);
        vm.deal(user, 1 ether);
        vm.expectRevert(NativeGiltBridge.InvalidMsgValue.selector);
        vm.prank(user);
        nativeGiltBridge.withdraw(1 ether);
    }

    function testDepositRevertsIfBridgeLiquidityIsMissing() public {
        vm.prank(GOVERNOR_ADDR);
        nativeGiltBridge.setChildChainManager(address(0x1234));

        vm.expectRevert(NativeGiltBridge.InsufficientBalance.selector);
        vm.prank(address(0x1234));
        nativeGiltBridge.deposit(address(0xBEEF), abi.encode(1 ether));
    }
}
