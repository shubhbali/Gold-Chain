// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "bridge/ethereum/contracts/GoldRootCustody.sol";
import "bridge/gold-chain/contracts/GoldChildBridge.sol";
import "bridge/shared/contracts/BridgeMessageLib.sol";
import "bridge/shared/contracts/BridgeThresholdVerifier.sol";

contract NonReturningERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external {
        allowance[msg.sender][spender] = amount;
    }

    function transfer(address to, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }

    function transferFrom(address from, address to, uint256 amount) external {
        require(balanceOf[from] >= amount, "balance");
        require(allowance[from][msg.sender] >= amount, "allowance");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}

contract BoolERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "balance");
        require(allowance[from][msg.sender] >= amount, "allowance");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}


contract FeeOnTransferERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public immutable fee;

    constructor(uint256 fee_) {
        fee = fee_;
    }

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "balance");
        uint256 received = amount - fee;
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += received;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "balance");
        require(allowance[from][msg.sender] >= amount, "allowance");
        uint256 received = amount - fee;
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += received;
        return true;
    }
}

contract BridgeMinterMock is IGoldBridgeMinter {
    mapping(uint256 => mapping(address => uint256)) public balanceOf;
    mapping(bytes32 => bool) public finalizedDeposits;
    bytes32 public lastDepositId;
    uint256 public lastRouteId;
    address public lastRecipient;
    uint256 public lastAmount;

    function mint(address to, uint256 routeId, uint256 amount) external {
        balanceOf[routeId][to] += amount;
    }

    function finalizeDeposit(bytes32 depositId, uint256 routeId, uint256 amount, address recipient) external {
        require(!finalizedDeposits[depositId], "deposit replay");
        finalizedDeposits[depositId] = true;
        balanceOf[routeId][recipient] += amount;
        lastDepositId = depositId;
        lastRouteId = routeId;
        lastRecipient = recipient;
        lastAmount = amount;
    }

    function burnForWithdrawal(address account, uint256 routeId, uint256 amount) external {
        require(balanceOf[routeId][account] >= amount, "insufficient");
        balanceOf[routeId][account] -= amount;
    }
}

contract BridgeCustodyHardeningTest is Test {
    address governance = address(0xA11CE);
    address finalizer = address(0xB0B);
    address user = address(0xCAFE);
    address recipient = address(0xD00D);
    address rootCustodyAddress = address(0x1001);
    address childBridgeAddress = address(0x2002);
    address paxgRootToken = address(0x123);
    address xautRootToken = address(0x456);
    uint256 constant PAXG = 1;
    uint256 constant XAUT = 2;
    uint256 constant ETHEREUM_CHAIN_ID = 1;
    uint256 constant GOLD_CHAIN_ID = 7777778;
    uint256 signerKey = 0xA11CE123;

    function _verifier() internal returns (BridgeThresholdVerifier verifier) {
        address[] memory signers = new address[](1);
        signers[0] = vm.addr(signerKey);
        verifier = new BridgeThresholdVerifier(governance, signers, 1, 1 days);
    }

    function _rootCustody(BridgeThresholdVerifier verifier) internal returns (GoldRootCustody custody) {
        custody = new GoldRootCustody(governance, verifier, GOLD_CHAIN_ID, childBridgeAddress);
    }

    function _childBridge(BridgeMinterMock minter, BridgeThresholdVerifier verifier) internal returns (GoldChildBridge bridge) {
        bridge = new GoldChildBridge(IGoldBridgeMinter(address(minter)), governance, finalizer, verifier, ETHEREUM_CHAIN_ID, rootCustodyAddress, paxgRootToken, xautRootToken);
    }

    function _oneSig(bytes32 digest) internal view returns (bytes[] memory signatures) {
        signatures = new bytes[](1);
        (uint8 v, bytes32 r, bytes32 sigS) = vm.sign(signerKey, digest);
        signatures[0] = abi.encodePacked(r, sigS, v);
    }

    function _withdrawalProof(GoldRootCustody custody, BridgeThresholdVerifier verifier, address token, bytes32 withdrawalId, address account, address ethRecipient, uint256 amount) internal view returns (GoldRootCustody.WithdrawalProof memory proof) {
        BridgeMessageLib.BridgeMessage memory message = BridgeMessageLib.BridgeMessage({
            sourceChainId: GOLD_CHAIN_ID,
            destinationChainId: block.chainid,
            sourceBridge: childBridgeAddress,
            destinationBridge: address(custody),
            routeId: PAXG,
            token: token,
            sender: account,
            recipient: ethRecipient,
            amount: amount,
            nonce: uint256(withdrawalId),
            sourceBlockNumber: 100,
            signerSetVersion: verifier.signerSetVersion(),
            txHash: keccak256("withdraw-tx"),
            logIndex: 1,
            direction: BridgeMessageLib.Direction.ChildBurnToRootRelease
        });
        proof = GoldRootCustody.WithdrawalProof({
            account: account,
            sourceBlockNumber: 100,
            txHash: keccak256("withdraw-tx"),
            logIndex: 1,
            signerSetVersion: verifier.signerSetVersion(),
            signatures: _oneSig(BridgeMessageLib.hash(message))
        });
    }

    function _depositProof(GoldChildBridge bridge, BridgeThresholdVerifier verifier, address rootToken, bytes32 depositId, address from, address goldRecipient, uint256 amount) internal view returns (GoldChildBridge.DepositProof memory proof) {
        proof = _depositProofForRoute(bridge, verifier, PAXG, rootToken, depositId, from, goldRecipient, amount);
    }

    function _depositProofForRoute(GoldChildBridge bridge, BridgeThresholdVerifier verifier, uint256 routeId, address rootToken, bytes32 depositId, address from, address goldRecipient, uint256 amount) internal view returns (GoldChildBridge.DepositProof memory proof) {
        BridgeMessageLib.BridgeMessage memory message = BridgeMessageLib.BridgeMessage({
            sourceChainId: ETHEREUM_CHAIN_ID,
            destinationChainId: block.chainid,
            sourceBridge: rootCustodyAddress,
            destinationBridge: address(bridge),
            routeId: routeId,
            token: rootToken,
            sender: from,
            recipient: goldRecipient,
            amount: amount,
            nonce: uint256(depositId),
            sourceBlockNumber: 200,
            signerSetVersion: verifier.signerSetVersion(),
            txHash: keccak256("deposit-tx"),
            logIndex: 2,
            direction: BridgeMessageLib.Direction.RootLockToChildMint
        });
        proof = GoldChildBridge.DepositProof({
            rootToken: rootToken,
            from: from,
            sourceBlockNumber: 200,
            txHash: keccak256("deposit-tx"),
            logIndex: 2,
            signerSetVersion: verifier.signerSetVersion(),
            signatures: _oneSig(BridgeMessageLib.hash(message))
        });
    }
    function _fundedRootCustody(uint256 lockedAmount)
        internal
        returns (NonReturningERC20 token, BridgeThresholdVerifier verifier, GoldRootCustody custody)
    {
        token = new NonReturningERC20();
        verifier = _verifier();
        custody = _rootCustody(verifier);

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, true);

        token.mint(user, 100 ether);
        vm.prank(user);
        token.approve(address(custody), 100 ether);
        vm.prank(user);
        custody.deposit(PAXG, lockedAmount, recipient);
    }


    function testRootCustodyRejectsUnsupportedRouteId() public {
        BoolERC20 token = new BoolERC20();
        GoldRootCustody custody = _rootCustody(_verifier());

        vm.prank(governance);
        vm.expectRevert(GoldRootCustody.InvalidRoute.selector);
        custody.setRoute(999, address(token), true, true, false);
    }

    function testRootCustodyRejectsFeeOnTransferShortReceipt() public {
        FeeOnTransferERC20 token = new FeeOnTransferERC20(1 ether);
        GoldRootCustody custody = _rootCustody(_verifier());

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, false);

        token.mint(user, 10 ether);
        vm.prank(user);
        token.approve(address(custody), 10 ether);

        vm.prank(user);
        vm.expectRevert(abi.encodeWithSelector(GoldRootCustody.TransferAmountMismatch.selector, 10 ether, 9 ether));
        custody.deposit(PAXG, 10 ether, recipient);
        assertEq(custody.lockedByRoute(PAXG), 0);
        assertEq(token.balanceOf(address(custody)), 0);
    }

    function testRootCustodyAcceptsNonReturningErc20AndFinalizesWithdrawals() public {
        NonReturningERC20 token = new NonReturningERC20();
        GoldRootCustody custody = _rootCustody(_verifier());

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, true);

        token.mint(user, 100 ether);
        vm.prank(user);
        token.approve(address(custody), 100 ether);

        vm.prank(user);
        bytes32 depositId = custody.deposit(PAXG, 25 ether, recipient);
        assertTrue(depositId != bytes32(0));
        assertEq(custody.lockedByRoute(PAXG), 25 ether);
        assertEq(token.balanceOf(address(custody)), 25 ether);

        bytes32 withdrawalId = keccak256("w1");
        GoldRootCustody.WithdrawalProof memory wProof = _withdrawalProof(custody, custody.verifier(), address(token), withdrawalId, recipient, user, 5 ether);
        vm.prank(finalizer);
        custody.finalizeWithdrawal(withdrawalId, PAXG, user, 5 ether, wProof);
        assertEq(custody.lockedByRoute(PAXG), 20 ether);
        assertEq(token.balanceOf(user), 80 ether);
    }

    function testPermissionlessWithdrawalReleaseWithValidThresholdProof() public {
        (NonReturningERC20 token, BridgeThresholdVerifier verifier, GoldRootCustody custody) = _fundedRootCustody(25 ether);

        bytes32 withdrawalId = keccak256("permissionless-w");
        GoldRootCustody.WithdrawalProof memory wProof = _withdrawalProof(custody, verifier, address(token), withdrawalId, recipient, user, 5 ether);

        address keeper = address(0xBEEF);
        vm.prank(keeper);
        custody.finalizeWithdrawal(withdrawalId, PAXG, user, 5 ether, wProof);

        assertTrue(custody.finalizedWithdrawals(withdrawalId));
        assertEq(custody.lockedByRoute(PAXG), 20 ether);
        assertEq(token.balanceOf(user), 80 ether);
    }

    function testPermissionlessWithdrawalRejectsForgedProof() public {
        (NonReturningERC20 token, BridgeThresholdVerifier verifier, GoldRootCustody custody) = _fundedRootCustody(25 ether);
        bytes32 withdrawalId = keccak256("forged-w");
        GoldRootCustody.WithdrawalProof memory wProof = _withdrawalProof(custody, verifier, address(token), withdrawalId, recipient, user, 5 ether);
        wProof.signatures = new bytes[](0);

        vm.prank(address(0xBEEF));
        vm.expectRevert();
        custody.finalizeWithdrawal(withdrawalId, PAXG, user, 5 ether, wProof);
        assertEq(custody.lockedByRoute(PAXG), 25 ether);
        assertEq(token.balanceOf(user), 75 ether);
    }

    function testPermissionlessWithdrawalRejectsWrongRecipientOrAmount() public {
        (NonReturningERC20 token, BridgeThresholdVerifier verifier, GoldRootCustody custody) = _fundedRootCustody(25 ether);
        bytes32 withdrawalId = keccak256("wrong-recipient-w");
        GoldRootCustody.WithdrawalProof memory wProof = _withdrawalProof(custody, verifier, address(token), withdrawalId, recipient, user, 5 ether);

        vm.prank(address(0xBEEF));
        vm.expectRevert();
        custody.finalizeWithdrawal(withdrawalId, PAXG, address(0xEeee), 5 ether, wProof);

        vm.prank(address(0xBEEF));
        vm.expectRevert();
        custody.finalizeWithdrawal(withdrawalId, PAXG, user, 6 ether, wProof);
        assertEq(custody.lockedByRoute(PAXG), 25 ether);
        assertEq(token.balanceOf(user), 75 ether);
    }

    function testPermissionlessWithdrawalRejectsReplayFromDifferentCaller() public {
        (NonReturningERC20 token, BridgeThresholdVerifier verifier, GoldRootCustody custody) = _fundedRootCustody(25 ether);
        bytes32 withdrawalId = keccak256("replay-w");
        GoldRootCustody.WithdrawalProof memory wProof = _withdrawalProof(custody, verifier, address(token), withdrawalId, recipient, user, 5 ether);

        vm.prank(address(0xBEEF));
        custody.finalizeWithdrawal(withdrawalId, PAXG, user, 5 ether, wProof);

        vm.prank(address(0xCA11));
        vm.expectRevert(GoldRootCustody.AlreadyFinalized.selector);
        custody.finalizeWithdrawal(withdrawalId, PAXG, user, 5 ether, wProof);
        assertEq(custody.lockedByRoute(PAXG), 20 ether);
        assertEq(token.balanceOf(user), 80 ether);
    }

    function testPermissionlessWithdrawalStillRespectsPauseAndRouteDisable() public {
        (NonReturningERC20 token, BridgeThresholdVerifier verifier, GoldRootCustody custody) = _fundedRootCustody(25 ether);
        bytes32 pausedWithdrawalId = keccak256("paused-w");
        GoldRootCustody.WithdrawalProof memory pausedProof = _withdrawalProof(custody, verifier, address(token), pausedWithdrawalId, recipient, user, 5 ether);

        vm.prank(governance);
        custody.pause();
        vm.prank(address(0xBEEF));
        vm.expectRevert(GoldRootCustody.PausedError.selector);
        custody.finalizeWithdrawal(pausedWithdrawalId, PAXG, user, 5 ether, pausedProof);

        vm.prank(governance);
        custody.unpause();
        vm.prank(governance);
        custody.setWithdrawalsEnabled(PAXG, false);

        bytes32 disabledWithdrawalId = keccak256("disabled-w");
        GoldRootCustody.WithdrawalProof memory disabledProof = _withdrawalProof(custody, verifier, address(token), disabledWithdrawalId, recipient, user, 5 ether);
        vm.prank(address(0xBEEF));
        vm.expectRevert(GoldRootCustody.WithdrawalsDisabled.selector);
        custody.finalizeWithdrawal(disabledWithdrawalId, PAXG, user, 5 ether, disabledProof);
        assertEq(custody.lockedByRoute(PAXG), 25 ether);
        assertEq(token.balanceOf(user), 75 ether);
    }

    function testRootCustodyFinalizedRouteCannotChangeTokenButCanCloseDeposits() public {
        BoolERC20 token = new BoolERC20();
        BoolERC20 replacement = new BoolERC20();
        GoldRootCustody custody = _rootCustody(_verifier());

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, true);

        vm.prank(governance);
        vm.expectRevert(GoldRootCustody.RouteFinalized.selector);
        custody.setRoute(PAXG, address(replacement), true, true, true);

        vm.prank(governance);
        custody.setDepositsEnabled(PAXG, false);

        token.mint(user, 10 ether);
        vm.startPrank(user);
        token.approve(address(custody), 10 ether);
        vm.expectRevert(GoldRootCustody.DepositsDisabled.selector);
        custody.deposit(PAXG, 1 ether, recipient);
        vm.stopPrank();
    }

    function testRootCustodyPauseAndTwoStepGovernance() public {
        BoolERC20 token = new BoolERC20();
        GoldRootCustody custody = _rootCustody(_verifier());
        address newGovernance = address(0x1234);

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, false);
        vm.prank(governance);
        custody.pause();

        token.mint(user, 10 ether);
        vm.startPrank(user);
        token.approve(address(custody), 10 ether);
        vm.expectRevert(GoldRootCustody.PausedError.selector);
        custody.deposit(PAXG, 1 ether, recipient);
        vm.stopPrank();

        vm.prank(governance);
        custody.beginGovernanceTransfer(newGovernance);
        vm.prank(user);
        vm.expectRevert(GoldRootCustody.NotPendingGovernance.selector);
        custody.acceptGovernance();
        vm.prank(newGovernance);
        custody.acceptGovernance();
        assertEq(custody.governance(), newGovernance);
    }

    function testThresholdProofsRejectForgedSingleFinalizerActions() public {
        NonReturningERC20 token = new NonReturningERC20();
        BridgeThresholdVerifier verifier = _verifier();
        GoldRootCustody custody = _rootCustody(verifier);
        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, true);

        token.mint(user, 10 ether);
        vm.prank(user);
        token.approve(address(custody), 10 ether);
        vm.prank(user);
        custody.deposit(PAXG, 10 ether, recipient);

        bytes32 withdrawalId = keccak256("bad-w");
        GoldRootCustody.WithdrawalProof memory wProof = _withdrawalProof(custody, verifier, address(token), withdrawalId, recipient, user, 5 ether);
        wProof.signatures = new bytes[](0);
        vm.prank(finalizer);
        vm.expectRevert();
        custody.finalizeWithdrawal(withdrawalId, PAXG, user, 5 ether, wProof);

        BridgeMinterMock minter = new BridgeMinterMock();
        GoldChildBridge bridge = _childBridge(minter, verifier);
        bytes32 depositId = keccak256("bad-d");
        GoldChildBridge.DepositProof memory dProof = _depositProof(bridge, verifier, paxgRootToken, depositId, recipient, user, 10 ether);
        dProof.signatures = new bytes[](0);
        vm.prank(finalizer);
        vm.expectRevert();
        bridge.finalizeDeposit(depositId, PAXG, 10 ether, user, dProof);
    }

    function testChildBridgePauseReplayAndTwoStepGovernance() public {
        BridgeMinterMock minter = new BridgeMinterMock();
        BridgeThresholdVerifier verifier = _verifier();
        GoldChildBridge bridge = _childBridge(minter, verifier);
        bytes32 depositId = keccak256("deposit-1");
        address newGovernance = address(0x4567);

        GoldChildBridge.DepositProof memory dProof = _depositProof(bridge, verifier, paxgRootToken, depositId, recipient, user, 10 ether);
        vm.prank(finalizer);
        bridge.finalizeDeposit(depositId, PAXG, 10 ether, user, dProof);
        assertEq(minter.balanceOf(PAXG, user), 10 ether);

        vm.prank(finalizer);
        vm.expectRevert(GoldChildBridge.AlreadyFinalized.selector);
        bridge.finalizeDeposit(depositId, PAXG, 10 ether, user, dProof);

        vm.prank(governance);
        bridge.pause();
        vm.prank(user);
        vm.expectRevert(GoldChildBridge.PausedError.selector);
        bridge.withdraw(PAXG, 1 ether, recipient);

        vm.prank(governance);
        bridge.beginGovernanceTransfer(newGovernance);
        vm.prank(newGovernance);
        bridge.acceptGovernance();
        assertEq(bridge.governance(), newGovernance);
    }


    function testChildBridgeRejectsRouteTokenMismatch() public {
        BridgeMinterMock minter = new BridgeMinterMock();
        BridgeThresholdVerifier verifier = _verifier();
        GoldChildBridge bridge = _childBridge(minter, verifier);

        bytes32 paxgDeposit = keccak256("paxg-route-xaut-token");
        GoldChildBridge.DepositProof memory wrongPaxgProof = _depositProofForRoute(bridge, verifier, PAXG, xautRootToken, paxgDeposit, recipient, user, 10 ether);
        vm.prank(finalizer);
        vm.expectRevert(GoldChildBridge.InvalidProof.selector);
        bridge.finalizeDeposit(paxgDeposit, PAXG, 10 ether, user, wrongPaxgProof);

        bytes32 xautDeposit = keccak256("xaut-route-paxg-token");
        GoldChildBridge.DepositProof memory wrongXautProof = _depositProofForRoute(bridge, verifier, XAUT, paxgRootToken, xautDeposit, recipient, user, 10 ether);
        vm.prank(finalizer);
        vm.expectRevert(GoldChildBridge.InvalidProof.selector);
        bridge.finalizeDeposit(xautDeposit, XAUT, 10 ether, user, wrongXautProof);

        bytes32 unsupportedDeposit = keccak256("unsupported-route");
        GoldChildBridge.DepositProof memory unsupportedProof = _depositProofForRoute(bridge, verifier, 999, paxgRootToken, unsupportedDeposit, recipient, user, 10 ether);
        vm.prank(finalizer);
        vm.expectRevert(GoldChildBridge.InvalidProof.selector);
        bridge.finalizeDeposit(unsupportedDeposit, 999, 10 ether, user, unsupportedProof);

        bytes32 validXautDeposit = keccak256("valid-xaut");
        GoldChildBridge.DepositProof memory validXautProof = _depositProofForRoute(bridge, verifier, XAUT, xautRootToken, validXautDeposit, recipient, user, 10 ether);
        vm.prank(finalizer);
        bridge.finalizeDeposit(validXautDeposit, XAUT, 10 ether, user, validXautProof);
        assertEq(minter.balanceOf(XAUT, user), 10 ether);
    }

}
