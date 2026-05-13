pragma solidity 0.6.12;

import {RLPReader} from "./utils/RLPReader.sol";
import {System} from "./System.sol";
import {IStateReceiver} from "./IStateReceiver.sol";

contract StateReceiver is System {
  using RLPReader for bytes;
  using RLPReader for RLPReader.RLPItem;

  uint256 public lastStateId;

  bytes32 public failedStateSyncsRoot;
  mapping(bytes32 => bool) public nullifier;

  mapping(uint256 => bytes) public failedStateSyncs;
  mapping(uint256 => uint8) public failedStateSyncReasons;

  address public rootSetter;
  address public bridgeOperator;
  uint256 public leafCount;
  uint256 public replayCount;
  uint256 public constant TREE_DEPTH = 16;
  uint8 public constant FAILURE_NONE = 0;
  uint8 public constant FAILURE_NON_CONTRACT_RECEIVER = 1;
  uint8 public constant FAILURE_RECEIVER_REVERTED = 2;

  event StateCommitted(uint256 indexed stateId, bool success);
  event StateSyncReplay(uint256 indexed stateId);
  event StateSyncFailureRecorded(uint256 indexed stateId, address indexed receiver, uint8 reason);
  event StateSyncReplayAttempt(uint256 indexed stateId, address indexed receiver, bool historic);
  event StateSyncReplayResult(uint256 indexed stateId, address indexed receiver, bool historic, bool success);
  event RootSetterUpdated(address indexed previousRootSetter, address indexed newRootSetter);
  event BridgeOperatorUpdated(address indexed previousBridgeOperator, address indexed newBridgeOperator);
  event HistoricRootConfigured(bytes32 indexed root, uint256 leafCount, address indexed setter);

  constructor(address _rootSetter) public {
    rootSetter = _rootSetter;
    bridgeOperator = _rootSetter;
  }

  modifier onlyBridgeOperator() {
    require(msg.sender == bridgeOperator, "!bridgeOperator");
    _;
  }

  modifier onlyRootSetter() {
    require(msg.sender == rootSetter, "!rootSetter");
    _;
  }

  function commitState(uint256 syncTime, bytes calldata recordBytes) external onlySystem returns (bool success) {
    // parse state data
    RLPReader.RLPItem[] memory dataList = recordBytes.toRlpItem().toList();
    uint256 stateId = dataList[0].toUint();
    require(lastStateId + 1 == stateId, "StateIds are not sequential");
    lastStateId++;
    address receiver = dataList[1].toAddress();
    bytes memory stateData = dataList[2].toBytes();
    // notify state receiver contract, in a non-revert manner
    if (!isContract(receiver)) {
      failedStateSyncs[stateId] = abi.encode(receiver, stateData);
      failedStateSyncReasons[stateId] = FAILURE_NON_CONTRACT_RECEIVER;
      emit StateCommitted(stateId, false);
      emit StateSyncFailureRecorded(stateId, receiver, FAILURE_NON_CONTRACT_RECEIVER);
      return false;
    }

    uint256 txGas = 5000000;
    bytes memory data = abi.encodeWithSignature("onStateReceive(uint256,bytes)", stateId, stateData);
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      success := call(txGas, receiver, 0, add(data, 0x20), mload(data), 0, 0)
    }
    emit StateCommitted(stateId, success);
    if (!success) {
      failedStateSyncs[stateId] = abi.encode(receiver, stateData);
      failedStateSyncReasons[stateId] = FAILURE_RECEIVER_REVERTED;
      emit StateSyncFailureRecorded(stateId, receiver, FAILURE_RECEIVER_REVERTED);
    }
  }

  function replayFailedStateSync(uint256 stateId) external onlyBridgeOperator {
    bytes memory stateSyncData = failedStateSyncs[stateId];
    require(stateSyncData.length != 0, "!found");

    (address receiver, bytes memory stateData) = abi.decode(stateSyncData, (address, bytes));
    emit StateSyncReplayAttempt(stateId, receiver, false);

    try IStateReceiver(receiver).onStateReceive(stateId, stateData) {
      delete failedStateSyncs[stateId];
      delete failedStateSyncReasons[stateId];
      emit StateSyncReplay(stateId);
      emit StateSyncReplayResult(stateId, receiver, false, true);
    } catch {
      emit StateSyncReplayResult(stateId, receiver, false, false);
    }
  }

  function setRootSetter(address newRootSetter) external onlyRootSetter {
    require(newRootSetter != address(0), "badRootSetter");
    address previousRootSetter = rootSetter;
    rootSetter = newRootSetter;
    emit RootSetterUpdated(previousRootSetter, newRootSetter);
  }

  function setBridgeOperator(address newBridgeOperator) external onlyRootSetter {
    require(newBridgeOperator != address(0), "badBridgeOperator");
    address previousBridgeOperator = bridgeOperator;
    bridgeOperator = newBridgeOperator;
    emit BridgeOperatorUpdated(previousBridgeOperator, newBridgeOperator);
  }

  function setRootAndLeafCount(bytes32 _root, uint256 _leafCount) external onlyRootSetter {
    require(failedStateSyncsRoot == bytes32(0), "!zero");
    failedStateSyncsRoot = _root;
    leafCount = _leafCount;
    emit HistoricRootConfigured(_root, _leafCount, msg.sender);
  }

  function replayHistoricFailedStateSync(
    bytes32[TREE_DEPTH] calldata proof,
    uint256 leafIndex,
    uint256 stateId,
    address receiver,
    bytes calldata data
  ) external onlyBridgeOperator {
    require(leafIndex < 2 ** TREE_DEPTH, "invalid leafIndex");
    require(++replayCount <= leafCount, "end");
    bytes32 root = failedStateSyncsRoot;
    require(root != bytes32(0), "!root");

    bytes32 leafHash = keccak256(abi.encode(stateId, receiver, data));
    bytes32 zeroHash = 0x28cf91ac064e179f8a42e4b7a20ba080187781da55fd4f3f18870b7a25bacb55; // keccak256(abi.encode(uint256(0), address(0), new bytes(0)));
    require(leafHash != zeroHash && !nullifier[leafHash], "used");
    nullifier[leafHash] = true;

    require(root == _getRoot(proof, leafIndex, leafHash), "!proof");

    emit StateSyncReplayAttempt(stateId, receiver, true);
    try IStateReceiver(receiver).onStateReceive(stateId, data) {
      emit StateSyncReplay(stateId);
      emit StateSyncReplayResult(stateId, receiver, true, true);
    } catch {
      nullifier[leafHash] = false;
      replayCount--;
      emit StateSyncReplayResult(stateId, receiver, true, false);
    }
  }

  function _getRoot(bytes32[TREE_DEPTH] memory proof, uint256 index, bytes32 leafHash) private pure returns (bytes32) {
    bytes32 node = leafHash;

    for (uint256 height = 0; height < TREE_DEPTH; height++) {
      if (((index >> height) & 1) == 1) node = keccak256(abi.encodePacked(proof[height], node));
      else node = keccak256(abi.encodePacked(node, proof[height]));
    }

    return node;
  }

  // check if address is contract
  function isContract(address _addr) private view returns (bool) {
    uint32 size;
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      size := extcodesize(_addr)
    }
    return (size > 0);
  }
}
