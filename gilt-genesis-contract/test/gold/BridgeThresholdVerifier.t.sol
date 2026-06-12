// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "bridge/shared/contracts/BridgeMessageLib.sol";
import "bridge/shared/contracts/BridgeThresholdVerifier.sol";

contract BridgeThresholdVerifierTest is Test {
    using BridgeMessageLib for BridgeMessageLib.BridgeMessage;

    uint256 signerKey1 = 0xA11CE;
    uint256 signerKey2 = 0xB0B;
    uint256 signerKey3 = 0xCAFE;
    uint256 outsiderKey = 0xD00D;

    function _sortedSigners() internal view returns (address[] memory signers) {
        signers = new address[](3);
        signers[0] = vm.addr(signerKey1);
        signers[1] = vm.addr(signerKey2);
        signers[2] = vm.addr(signerKey3);
        for (uint256 i = 0; i < signers.length; i++) {
            for (uint256 j = i + 1; j < signers.length; j++) {
                if (signers[j] < signers[i]) {
                    address tmp = signers[i];
                    signers[i] = signers[j];
                    signers[j] = tmp;
                }
            }
        }
    }

    function _keyFor(address signer) internal view returns (uint256) {
        if (signer == vm.addr(signerKey1)) return signerKey1;
        if (signer == vm.addr(signerKey2)) return signerKey2;
        if (signer == vm.addr(signerKey3)) return signerKey3;
        if (signer == vm.addr(outsiderKey)) return outsiderKey;
        revert("unknown signer");
    }

    function _message() internal pure returns (BridgeMessageLib.BridgeMessage memory message) {
        message.sourceChainId = 1;
        message.destinationChainId = 7777778;
        message.sourceBridge = address(0x1001);
        message.destinationBridge = address(0x2002);
        message.routeId = 1;
        message.token = address(0x3003);
        message.sender = address(0x4004);
        message.recipient = address(0x5005);
        message.amount = 100 ether;
        message.nonce = 7;
        message.sourceBlockNumber = 123456;
        message.txHash = keccak256("tx");
        message.logIndex = 2;
        message.direction = BridgeMessageLib.Direction.RootLockToChildMint;
    }

    function _sign(bytes32 digest, address[] memory selected) internal view returns (bytes[] memory signatures) {
        signatures = new bytes[](selected.length);
        for (uint256 i = 0; i < selected.length; i++) {
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(_keyFor(selected[i]), digest);
            signatures[i] = abi.encodePacked(r, s, v);
        }
    }

    function testThresholdVerifierAcceptsSortedThresholdSignatures() public {
        address[] memory signers = _sortedSigners();
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(address(this), signers, 2, 1 days);
        address[] memory selected = new address[](2);
        selected[0] = signers[0];
        selected[1] = signers[1];
        assertTrue(verifier.verify(_message().hash(), _sign(_message().hash(), selected)));
    }

    function testThresholdVerifierRejectsInsufficientSignatures() public {
        address[] memory signers = _sortedSigners();
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(address(this), signers, 2, 1 days);
        address[] memory selected = new address[](1);
        selected[0] = signers[0];
        vm.expectRevert(abi.encodeWithSelector(BridgeThresholdVerifier.InsufficientSignatures.selector, 1, 2));
        verifier.verify(_message().hash(), _sign(_message().hash(), selected));
    }

    function testThresholdVerifierRejectsNonSignerAndUnsortedDuplicates() public {
        address[] memory signers = _sortedSigners();
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(address(this), signers, 2, 1 days);

        address[] memory duplicate = new address[](2);
        duplicate[0] = signers[0];
        duplicate[1] = signers[0];
        vm.expectRevert(BridgeThresholdVerifier.DuplicateSigner.selector);
        verifier.verify(_message().hash(), _sign(_message().hash(), duplicate));

        address[] memory selected = new address[](2);
        selected[0] = signers[0];
        selected[1] = vm.addr(outsiderKey);
        if (selected[1] < selected[0]) {
            selected[0] = vm.addr(outsiderKey);
            selected[1] = signers[0];
        }
        vm.expectRevert();
        verifier.verify(_message().hash(), _sign(_message().hash(), selected));
    }

    function testBridgeMessageHashBindsEverySecurityCriticalField() public pure {
        BridgeMessageLib.BridgeMessage memory base = _message();
        bytes32 baseHash = base.hash();
        BridgeMessageLib.BridgeMessage memory changed = _message();
        changed.routeId = 2;
        assertTrue(changed.hash() != baseHash);
        changed = _message();
        changed.recipient = address(0x9999);
        assertTrue(changed.hash() != baseHash);
        changed = _message();
        changed.direction = BridgeMessageLib.Direction.ChildBurnToRootRelease;
        assertTrue(changed.hash() != baseHash);
    }


    function testVerifierGovernanceTransferIsTwoStep() public {
        address[] memory signers = _sortedSigners();
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(address(this), signers, 2, 1 days);
        address nextGovernance = address(0x1234);

        verifier.beginGovernanceTransfer(nextGovernance);
        vm.prank(address(0xBEEF));
        vm.expectRevert(BridgeThresholdVerifier.NotPendingGovernance.selector);
        verifier.acceptGovernance();

        vm.prank(nextGovernance);
        verifier.acceptGovernance();
        assertEq(verifier.governance(), nextGovernance);

        vm.expectRevert(BridgeThresholdVerifier.NotGovernance.selector);
        verifier.beginGovernanceTransfer(address(0x5678));
    }

    function testSignerSetUpdatesAreDelayedAndExact() public {
        address[] memory signers = _sortedSigners();
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(address(this), signers, 2, 1 days);

        address[] memory next = new address[](2);
        next[0] = signers[0];
        next[1] = signers[1];
        verifier.scheduleSignerSet(next, 1);

        vm.expectRevert();
        verifier.executeSignerSet(next, 1);

        address[] memory wrong = new address[](2);
        wrong[0] = signers[1];
        wrong[1] = signers[2];
        vm.warp(block.timestamp + 1 days);
        vm.expectRevert(BridgeThresholdVerifier.WrongSignerSet.selector);
        verifier.executeSignerSet(wrong, 1);

        verifier.executeSignerSet(next, 1);
        assertEq(verifier.threshold(), 1);
        assertTrue(verifier.isSigner(next[0]));
        assertTrue(verifier.isSigner(next[1]));
        assertFalse(verifier.isSigner(signers[2]));
    }

    function testSignerSetUpdateCanBeCancelled() public {
        address[] memory signers = _sortedSigners();
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(address(this), signers, 2, 1 days);
        verifier.scheduleSignerSet(signers, 1);
        verifier.cancelSignerSet();

        vm.warp(block.timestamp + 1 days);
        vm.expectRevert(BridgeThresholdVerifier.NoPendingSignerSet.selector);
        verifier.executeSignerSet(signers, 1);
    }

}
