// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "bridge/shared/contracts/BridgeMessageLib.sol";
import "bridge/shared/contracts/BridgeThresholdVerifier.sol";

interface IERC20Minimal {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract GoldRootCustody {
    uint256 public constant PAXG_ROUTE_ID = 1;
    uint256 public constant XAUT_ROUTE_ID = 2;

    address public governance;
    address public pendingGovernance;
    BridgeThresholdVerifier public immutable verifier;
    uint256 public immutable goldChainChainId;
    address public immutable childBridge;
    bool public paused;
    uint256 public nextDepositNonce;
    uint256 private _reentrancyLock = 1;

    struct Route {
        address token;
        bool depositsEnabled;
        bool withdrawalsEnabled;
        bool finalized;
    }

    mapping(uint256 => Route) public routes;
    mapping(uint256 => uint256) public lockedByRoute;
    mapping(bytes32 => bool) public finalizedWithdrawals;

    event GovernanceTransferStarted(address indexed currentGovernance, address indexed pendingGovernance);
    event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);
    event Paused(address indexed account);
    event Unpaused(address indexed account);
    event RouteSet(uint256 indexed routeId, address indexed token, bool depositsEnabled, bool withdrawalsEnabled, bool finalized);
    event DepositsEnabledSet(uint256 indexed routeId, bool enabled);
    event WithdrawalsEnabledSet(uint256 indexed routeId, bool enabled);
    event Deposited(bytes32 indexed depositId, uint256 indexed routeId, address indexed from, address goldRecipient, uint256 amount);
    event WithdrawalFinalized(bytes32 indexed withdrawalId, uint256 indexed routeId, address indexed recipient, uint256 amount);

    error NotGovernance();
    error NotPendingGovernance();
    error InvalidRoute();
    error InvalidAmount();
    error InvalidRecipient();
    error DepositsDisabled();
    error WithdrawalsDisabled();
    error AlreadyFinalized();
    error RouteFinalized();
    error PausedError();
    error Reentrancy();
    error TransferFailed();
    error TransferAmountMismatch(uint256 expected, uint256 received);
    error InvalidProof();

    struct WithdrawalProof {
        address account;
        uint256 sourceBlockNumber;
        bytes32 txHash;
        uint256 logIndex;
        uint256 signerSetVersion;
        bytes[] signatures;
    }

    modifier onlyGovernance() {
        if (msg.sender != governance) revert NotGovernance();
        _;
    }

    modifier whenNotPaused() {
        if (paused) revert PausedError();
        _;
    }

    modifier nonReentrant() {
        if (_reentrancyLock != 1) revert Reentrancy();
        _reentrancyLock = 2;
        _;
        _reentrancyLock = 1;
    }

    constructor(address governance_, BridgeThresholdVerifier verifier_, uint256 goldChainChainId_, address childBridge_) {
        require(governance_ != address(0), "invalid governance");
        require(address(verifier_) != address(0), "invalid verifier");
        require(goldChainChainId_ != 0, "invalid source chain");
        require(childBridge_ != address(0), "invalid child bridge");
        governance = governance_;
        verifier = verifier_;
        goldChainChainId = goldChainChainId_;
        childBridge = childBridge_;
    }

    function beginGovernanceTransfer(address newGovernance) external onlyGovernance {
        require(newGovernance != address(0), "invalid governance");
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

    function pause() external onlyGovernance {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyGovernance {
        paused = false;
        emit Unpaused(msg.sender);
    }

    function setRoute(uint256 routeId, address token, bool depositsEnabled, bool withdrawalsEnabled, bool finalized) external onlyGovernance {
        _requireSupportedRoute(routeId);
        if (token == address(0)) revert InvalidRoute();
        if (routes[routeId].finalized) revert RouteFinalized();
        routes[routeId] = Route(token, depositsEnabled, withdrawalsEnabled, finalized);
        emit RouteSet(routeId, token, depositsEnabled, withdrawalsEnabled, finalized);
    }

    function setDepositsEnabled(uint256 routeId, bool enabled) external onlyGovernance {
        _requireSupportedRoute(routeId);
        Route storage route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        route.depositsEnabled = enabled;
        emit DepositsEnabledSet(routeId, enabled);
    }

    function setWithdrawalsEnabled(uint256 routeId, bool enabled) external onlyGovernance {
        _requireSupportedRoute(routeId);
        Route storage route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        route.withdrawalsEnabled = enabled;
        emit WithdrawalsEnabledSet(routeId, enabled);
    }


    function deposit(uint256 routeId, uint256 amount, address goldRecipient) external nonReentrant whenNotPaused returns (bytes32 depositId) {
        _requireSupportedRoute(routeId);
        Route memory route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        if (!route.depositsEnabled) revert DepositsDisabled();
        if (amount == 0) revert InvalidAmount();
        if (goldRecipient == address(0)) revert InvalidRecipient();

        depositId = keccak256(abi.encodePacked(block.chainid, address(this), routeId, msg.sender, goldRecipient, amount, nextDepositNonce++));
        uint256 beforeBalance = _balanceOf(route.token, address(this));
        _safeTransferFrom(route.token, msg.sender, address(this), amount);
        uint256 afterBalance = _balanceOf(route.token, address(this));
        uint256 received = afterBalance - beforeBalance;
        if (received != amount) revert TransferAmountMismatch(amount, received);
        lockedByRoute[routeId] += received;
        emit Deposited(depositId, routeId, msg.sender, goldRecipient, received);
    }

    function finalizeWithdrawal(bytes32 withdrawalId, uint256 routeId, address recipient, uint256 amount, WithdrawalProof calldata proof)
        external
        nonReentrant
        whenNotPaused
    {
        _requireSupportedRoute(routeId);
        Route memory route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        if (!route.withdrawalsEnabled) revert WithdrawalsDisabled();
        if (finalizedWithdrawals[withdrawalId]) revert AlreadyFinalized();
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        if (lockedByRoute[routeId] < amount) revert InvalidAmount();
        _verifyWithdrawal(withdrawalId, routeId, route.token, recipient, amount, proof);

        finalizedWithdrawals[withdrawalId] = true;
        lockedByRoute[routeId] -= amount;
        _safeTransfer(route.token, recipient, amount);
        emit WithdrawalFinalized(withdrawalId, routeId, recipient, amount);
    }

    function _verifyWithdrawal(bytes32 withdrawalId, uint256 routeId, address token, address recipient, uint256 amount, WithdrawalProof calldata proof) private view {
        if (proof.account == address(0) || proof.sourceBlockNumber == 0 || proof.txHash == bytes32(0)) revert InvalidProof();
        if (proof.signerSetVersion != verifier.signerSetVersion()) revert InvalidProof();
        BridgeMessageLib.BridgeMessage memory message = BridgeMessageLib.BridgeMessage({
            sourceChainId: goldChainChainId,
            destinationChainId: block.chainid,
            sourceBridge: childBridge,
            destinationBridge: address(this),
            routeId: routeId,
            token: token,
            sender: proof.account,
            recipient: recipient,
            amount: amount,
            nonce: uint256(withdrawalId),
            sourceBlockNumber: proof.sourceBlockNumber,
            signerSetVersion: proof.signerSetVersion,
            txHash: proof.txHash,
            logIndex: proof.logIndex,
            direction: BridgeMessageLib.Direction.ChildBurnToRootRelease
        });
        verifier.verify(BridgeMessageLib.hash(message), proof.signatures);
    }

    function _requireSupportedRoute(uint256 routeId) private pure {
        if (routeId != PAXG_ROUTE_ID && routeId != XAUT_ROUTE_ID) revert InvalidRoute();
    }

    function _safeTransferFrom(address token, address from, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20Minimal.transferFrom.selector, from, to, amount));
        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TransferFailed();
    }

    function _safeTransfer(address token, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20Minimal.transfer.selector, to, amount));
        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TransferFailed();
    }

    function _balanceOf(address token, address account) private view returns (uint256 balance) {
        (bool success, bytes memory data) = token.staticcall(abi.encodeWithSelector(IERC20Minimal.balanceOf.selector, account));
        if (!success || data.length < 32) revert TransferFailed();
        balance = abi.decode(data, (uint256));
    }
}
