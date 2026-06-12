// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

contract BridgeThresholdVerifier {
    uint256 private constant SECP256K1N_DIV_2 = 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0;

    address public governance;
    address public pendingGovernance;
    uint256 public immutable signerSetDelay;
    uint256 public threshold;
    uint256 public signerSetVersion;
    bytes32 public pendingSignerSetHash;
    uint256 public pendingSignerSetEta;

    mapping(address => bool) public isSigner;
    address[] public signers;

    event GovernanceTransferStarted(address indexed currentGovernance, address indexed pendingGovernance);
    event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);
    event SignerSetUpdateScheduled(bytes32 indexed updateHash, uint256 eta, uint256 threshold, address[] signers);
    event SignerSetUpdateCancelled(bytes32 indexed updateHash);
    event SignerSetUpdated(uint256 indexed version, uint256 threshold, address[] signers);

    error NotGovernance();
    error NotPendingGovernance();
    error InvalidThreshold();
    error InvalidSigner();
    error DuplicateSigner();
    error UnsortedSigner();
    error BadSignature();
    error NonSigner(address signer);
    error InsufficientSignatures(uint256 provided, uint256 required);
    error NoPendingSignerSet();
    error WrongSignerSet();
    error SignerSetDelayNotElapsed(uint256 eta);

    modifier onlyGovernance() {
        if (msg.sender != governance) revert NotGovernance();
        _;
    }

    constructor(address governance_, address[] memory signers_, uint256 threshold_, uint256 signerSetDelay_) {
        if (governance_ == address(0)) revert InvalidSigner();
        governance = governance_;
        signerSetDelay = signerSetDelay_;
        _setSignerSet(signers_, threshold_);
    }

    function beginGovernanceTransfer(address newGovernance) external onlyGovernance {
        if (newGovernance == address(0)) revert InvalidSigner();
        pendingGovernance = newGovernance;
        emit GovernanceTransferStarted(governance, newGovernance);
    }

    function acceptGovernance() external {
        if (msg.sender != pendingGovernance) revert NotPendingGovernance();
        address previous = governance;
        governance = msg.sender;
        pendingGovernance = address(0);
        emit GovernanceTransferred(previous, msg.sender);
    }

    function scheduleSignerSet(address[] calldata signers_, uint256 threshold_) external onlyGovernance {
        _validateSignerSet(signers_, threshold_);
        bytes32 updateHash = keccak256(abi.encode(signers_, threshold_));
        pendingSignerSetHash = updateHash;
        pendingSignerSetEta = block.timestamp + signerSetDelay;
        emit SignerSetUpdateScheduled(updateHash, pendingSignerSetEta, threshold_, signers_);
    }

    function executeSignerSet(address[] calldata signers_, uint256 threshold_) external onlyGovernance {
        if (pendingSignerSetHash == bytes32(0)) revert NoPendingSignerSet();
        bytes32 updateHash = keccak256(abi.encode(signers_, threshold_));
        if (updateHash != pendingSignerSetHash) revert WrongSignerSet();
        if (block.timestamp < pendingSignerSetEta) revert SignerSetDelayNotElapsed(pendingSignerSetEta);
        pendingSignerSetHash = bytes32(0);
        pendingSignerSetEta = 0;
        _setSignerSet(signers_, threshold_);
    }

    function cancelSignerSet() external onlyGovernance {
        bytes32 old = pendingSignerSetHash;
        pendingSignerSetHash = bytes32(0);
        pendingSignerSetEta = 0;
        emit SignerSetUpdateCancelled(old);
    }

    function verify(bytes32 digest, bytes[] calldata signatures) external view returns (bool) {
        _verify(digest, signatures);
        return true;
    }

    function recoverSigner(bytes32 digest, bytes memory signature) public pure returns (address) {
        if (signature.length != 65) revert BadSignature();
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }
        if (v != 27 && v != 28) revert BadSignature();
        if (uint256(s) > SECP256K1N_DIV_2) revert BadSignature();
        address recovered = ecrecover(digest, v, r, s);
        if (recovered == address(0)) revert BadSignature();
        return recovered;
    }

    function _verify(bytes32 digest, bytes[] calldata signatures) internal view {
        if (signatures.length < threshold) revert InsufficientSignatures(signatures.length, threshold);
        address previous = address(0);
        for (uint256 i = 0; i < signatures.length; i++) {
            address recovered = recoverSigner(digest, signatures[i]);
            if (recovered == previous) revert DuplicateSigner();
            if (recovered < previous) revert UnsortedSigner();
            if (!isSigner[recovered]) revert NonSigner(recovered);
            previous = recovered;
        }
    }

    function _validateSignerSet(address[] memory signers_, uint256 threshold_) internal pure {
        if (threshold_ == 0 || threshold_ > signers_.length) revert InvalidThreshold();
        address previous = address(0);
        for (uint256 i = 0; i < signers_.length; i++) {
            address signer = signers_[i];
            if (signer == address(0)) revert InvalidSigner();
            if (signer < previous) revert UnsortedSigner();
            if (signer == previous) revert DuplicateSigner();
            previous = signer;
        }
    }

    function _setSignerSet(address[] memory signers_, uint256 threshold_) internal {
        _validateSignerSet(signers_, threshold_);
        for (uint256 i = 0; i < signers.length; i++) {
            isSigner[signers[i]] = false;
        }
        delete signers;
        for (uint256 i = 0; i < signers_.length; i++) {
            isSigner[signers_[i]] = true;
            signers.push(signers_[i]);
        }
        threshold = threshold_;
        signerSetVersion += 1;
        emit SignerSetUpdated(signerSetVersion, threshold_, signers_);
    }
}
