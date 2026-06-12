// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

library BridgeMessageLib {
    enum Direction {
        RootLockToChildMint,
        ChildBurnToRootRelease
    }

    struct BridgeMessage {
        uint256 sourceChainId;
        uint256 destinationChainId;
        address sourceBridge;
        address destinationBridge;
        uint256 routeId;
        address token;
        address sender;
        address recipient;
        uint256 amount;
        uint256 nonce;
        uint256 sourceBlockNumber;
        uint256 signerSetVersion;
        bytes32 txHash;
        uint256 logIndex;
        Direction direction;
    }

    bytes32 internal constant BRIDGE_MESSAGE_TYPEHASH = keccak256(
        "GoldBridgeMessage:v1(uint256 sourceChainId,uint256 destinationChainId,address sourceBridge,address destinationBridge,uint256 routeId,address token,address sender,address recipient,uint256 amount,uint256 nonce,uint256 sourceBlockNumber,uint256 signerSetVersion,bytes32 txHash,uint256 logIndex,uint8 direction)"
    );

    function hash(BridgeMessage memory message) internal pure returns (bytes32) {
        return keccak256(abi.encode(BRIDGE_MESSAGE_TYPEHASH, _hashRoute(message), _hashTransfer(message), _hashSource(message), uint8(message.direction)));
    }

    function _hashRoute(BridgeMessage memory message) private pure returns (bytes32) {
        return keccak256(abi.encode(message.sourceChainId, message.destinationChainId, message.sourceBridge, message.destinationBridge, message.routeId, message.token));
    }

    function _hashTransfer(BridgeMessage memory message) private pure returns (bytes32) {
        return keccak256(abi.encode(message.sender, message.recipient, message.amount, message.nonce));
    }

    function _hashSource(BridgeMessage memory message) private pure returns (bytes32) {
        return keccak256(abi.encode(message.sourceBlockNumber, message.signerSetVersion, message.txHash, message.logIndex));
    }
}
