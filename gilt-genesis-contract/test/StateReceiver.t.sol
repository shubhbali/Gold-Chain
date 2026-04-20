pragma solidity 0.8.17;

import "forge-std/Test.sol";

interface IStateReceiverTest {
    function lastStateId() external view returns (uint256);
    function rootSetter() external view returns (address);
    function failedStateSyncs(uint256 stateId) external view returns (bytes memory);
    function commitState(uint256 syncTime, bytes calldata recordBytes) external returns (bool success);
    function replayFailedStateSync(uint256 stateId) external;
}

contract TestStateReceiverSink {
    uint256 public lastId;
    bytes public lastData;
    bool public shouldRevert;

    function setShouldRevert(bool value) external {
        shouldRevert = value;
    }

    function onStateReceive(uint256 stateId, bytes calldata stateData) external {
        if (shouldRevert) revert("sink revert");
        lastId = stateId;
        lastData = stateData;
    }
}

contract StateReceiverTest is Test {
    address internal constant SYSTEM_ADDRESS = 0xffffFFFfFFffffffffffffffFfFFFfffFFFfFFfE;
    address internal constant GOV_HUB_ADDR = 0x0000000000000000000000000000000000001007;
    uint8 internal constant LIST_SHORT_START = 0xc0;

    IStateReceiverTest internal stateReceiver;
    TestStateReceiverSink internal sink;

    function setUp() public {
        stateReceiver = IStateReceiverTest(deployCode("out/StateReceiver.sol/StateReceiver.json"));
        sink = new TestStateReceiverSink();
    }

    function testDeploymentDefaults() public {
        assertEq(stateReceiver.rootSetter(), GOV_HUB_ADDR);
        assertEq(stateReceiver.lastStateId(), 0);
    }

    function testRevertCommitStateOnlySystem() public {
        vm.expectRevert(bytes("the msg sender must be system"));
        stateReceiver.commitState(0, "");
    }

    function testRevertCommitStateStateIdsAreSequential() public {
        bytes memory recordBytes = _encodeRecord(2, address(sink), hex"");
        vm.prank(SYSTEM_ADDRESS);
        vm.expectRevert(bytes("StateIds are not sequential"));
        stateReceiver.commitState(0, recordBytes);
    }

    function testCommitStateSuccess() public {
        bytes memory stateData = bytes("gold bridge");
        bytes memory recordBytes = _encodeRecord(1, address(sink), stateData);

        vm.prank(SYSTEM_ADDRESS);
        assertTrue(stateReceiver.commitState(0, recordBytes));

        assertEq(stateReceiver.lastStateId(), 1);
        assertEq(sink.lastId(), 1);
        assertEq(sink.lastData(), stateData);
    }

    function testCommitStateFailureAndReplay() public {
        bytes memory stateData = bytes("retry me");
        bytes memory recordBytes = _encodeRecord(1, address(sink), stateData);

        sink.setShouldRevert(true);
        vm.prank(SYSTEM_ADDRESS);
        assertFalse(stateReceiver.commitState(0, recordBytes));
        assertEq(stateReceiver.lastStateId(), 1);
        assertEq(stateReceiver.failedStateSyncs(1), abi.encode(address(sink), stateData));

        sink.setShouldRevert(false);
        stateReceiver.replayFailedStateSync(1);

        assertEq(sink.lastId(), 1);
        assertEq(sink.lastData(), stateData);
        assertEq(stateReceiver.failedStateSyncs(1).length, 0);
    }

    function _encodeRecord(
        uint256 stateId,
        address receiver,
        bytes memory stateData
    ) internal pure returns (bytes memory recordBytes) {
        return abi.encodePacked(LIST_SHORT_START, _rlpEncodeUint(stateId), _rlpEncodeAddress(receiver), _rlpEncodeBytes(stateData));
    }

    function _rlpEncodeUint(uint256 value) internal pure returns (bytes memory) {
        if (value == 0) {
            return hex"80";
        }
        return _rlpEncodeBytes(_toBinary(value));
    }

    function _rlpEncodeAddress(address value) internal pure returns (bytes memory) {
        return _rlpEncodeBytes(abi.encodePacked(value));
    }

    function _rlpEncodeBytes(bytes memory value) internal pure returns (bytes memory) {
        if (value.length == 1 && uint8(value[0]) < 0x80) {
            return value;
        }
        require(value.length < 56, "test encoder only supports short strings");
        return abi.encodePacked(bytes1(uint8(0x80 + value.length)), value);
    }

    function _toBinary(uint256 value) internal pure returns (bytes memory out) {
        uint256 length = 0;
        uint256 tmp = value;
        while (tmp != 0) {
            length++;
            tmp >>= 8;
        }
        out = new bytes(length);
        for (uint256 i = length; i > 0; i--) {
            out[i - 1] = bytes1(uint8(value));
            value >>= 8;
        }
    }
}
