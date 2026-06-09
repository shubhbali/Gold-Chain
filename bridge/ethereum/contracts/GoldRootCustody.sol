// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IERC20Minimal {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract GoldRootCustody {
    address public governance;
    address public pendingGovernance;
    address public withdrawalFinalizer;
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
    event WithdrawalFinalizerSet(address indexed previousFinalizer, address indexed newFinalizer);
    event Paused(address indexed account);
    event Unpaused(address indexed account);
    event RouteSet(uint256 indexed routeId, address indexed token, bool depositsEnabled, bool withdrawalsEnabled, bool finalized);
    event DepositsEnabledSet(uint256 indexed routeId, bool enabled);
    event WithdrawalsEnabledSet(uint256 indexed routeId, bool enabled);
    event Deposited(bytes32 indexed depositId, uint256 indexed routeId, address indexed from, address goldRecipient, uint256 amount);
    event WithdrawalFinalized(bytes32 indexed withdrawalId, uint256 indexed routeId, address indexed recipient, uint256 amount);

    error NotGovernance();
    error NotPendingGovernance();
    error NotFinalizer();
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

    modifier onlyGovernance() {
        if (msg.sender != governance) revert NotGovernance();
        _;
    }

    modifier onlyFinalizer() {
        if (msg.sender != withdrawalFinalizer) revert NotFinalizer();
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

    constructor(address governance_, address withdrawalFinalizer_) {
        require(governance_ != address(0), "invalid governance");
        require(withdrawalFinalizer_ != address(0), "invalid finalizer");
        governance = governance_;
        withdrawalFinalizer = withdrawalFinalizer_;
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
        if (routeId == 0 || token == address(0)) revert InvalidRoute();
        if (routes[routeId].finalized) revert RouteFinalized();
        routes[routeId] = Route(token, depositsEnabled, withdrawalsEnabled, finalized);
        emit RouteSet(routeId, token, depositsEnabled, withdrawalsEnabled, finalized);
    }

    function setDepositsEnabled(uint256 routeId, bool enabled) external onlyGovernance {
        Route storage route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        route.depositsEnabled = enabled;
        emit DepositsEnabledSet(routeId, enabled);
    }

    function setWithdrawalsEnabled(uint256 routeId, bool enabled) external onlyGovernance {
        Route storage route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        route.withdrawalsEnabled = enabled;
        emit WithdrawalsEnabledSet(routeId, enabled);
    }

    function setWithdrawalFinalizer(address finalizer) external onlyGovernance {
        require(finalizer != address(0), "invalid finalizer");
        address previous = withdrawalFinalizer;
        withdrawalFinalizer = finalizer;
        emit WithdrawalFinalizerSet(previous, finalizer);
    }

    function deposit(uint256 routeId, uint256 amount, address goldRecipient) external nonReentrant whenNotPaused returns (bytes32 depositId) {
        Route memory route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        if (!route.depositsEnabled) revert DepositsDisabled();
        if (amount == 0) revert InvalidAmount();
        if (goldRecipient == address(0)) revert InvalidRecipient();

        depositId = keccak256(abi.encodePacked(block.chainid, address(this), routeId, msg.sender, goldRecipient, amount, nextDepositNonce++));
        _safeTransferFrom(route.token, msg.sender, address(this), amount);
        lockedByRoute[routeId] += amount;
        emit Deposited(depositId, routeId, msg.sender, goldRecipient, amount);
    }

    function finalizeWithdrawal(bytes32 withdrawalId, uint256 routeId, address recipient, uint256 amount)
        external
        onlyFinalizer
        nonReentrant
        whenNotPaused
    {
        Route memory route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        if (!route.withdrawalsEnabled) revert WithdrawalsDisabled();
        if (finalizedWithdrawals[withdrawalId]) revert AlreadyFinalized();
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        if (lockedByRoute[routeId] < amount) revert InvalidAmount();

        finalizedWithdrawals[withdrawalId] = true;
        lockedByRoute[routeId] -= amount;
        _safeTransfer(route.token, recipient, amount);
        emit WithdrawalFinalized(withdrawalId, routeId, recipient, amount);
    }

    function _safeTransferFrom(address token, address from, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20Minimal.transferFrom.selector, from, to, amount));
        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TransferFailed();
    }

    function _safeTransfer(address token, address to, uint256 amount) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20Minimal.transfer.selector, to, amount));
        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TransferFailed();
    }
}
