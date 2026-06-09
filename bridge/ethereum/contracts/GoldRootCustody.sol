// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IERC20Minimal {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract GoldRootCustody {
    address public governance;
    address public withdrawalFinalizer;
    uint256 public nextDepositNonce;

    struct Route {
        address token;
        bool depositsEnabled;
        bool withdrawalsEnabled;
    }

    mapping(uint256 => Route) public routes;
    mapping(uint256 => uint256) public lockedByRoute;
    mapping(bytes32 => bool) public finalizedWithdrawals;

    event RouteSet(uint256 indexed routeId, address indexed token, bool depositsEnabled, bool withdrawalsEnabled);
    event Deposited(bytes32 indexed depositId, uint256 indexed routeId, address indexed from, address goldRecipient, uint256 amount);
    event WithdrawalFinalized(bytes32 indexed withdrawalId, uint256 indexed routeId, address indexed recipient, uint256 amount);

    error NotGovernance();
    error NotFinalizer();
    error InvalidRoute();
    error InvalidAmount();
    error InvalidRecipient();
    error DepositsDisabled();
    error WithdrawalsDisabled();
    error AlreadyFinalized();
    error TransferFailed();

    modifier onlyGovernance() {
        if (msg.sender != governance) revert NotGovernance();
        _;
    }

    modifier onlyFinalizer() {
        if (msg.sender != withdrawalFinalizer) revert NotFinalizer();
        _;
    }

    constructor(address governance_, address withdrawalFinalizer_) {
        require(governance_ != address(0), "invalid governance");
        require(withdrawalFinalizer_ != address(0), "invalid finalizer");
        governance = governance_;
        withdrawalFinalizer = withdrawalFinalizer_;
    }

    function setRoute(uint256 routeId, address token, bool depositsEnabled, bool withdrawalsEnabled) external onlyGovernance {
        if (routeId == 0 || token == address(0)) revert InvalidRoute();
        routes[routeId] = Route(token, depositsEnabled, withdrawalsEnabled);
        emit RouteSet(routeId, token, depositsEnabled, withdrawalsEnabled);
    }

    function setWithdrawalFinalizer(address finalizer) external onlyGovernance {
        require(finalizer != address(0), "invalid finalizer");
        withdrawalFinalizer = finalizer;
    }

    function deposit(uint256 routeId, uint256 amount, address goldRecipient) external returns (bytes32 depositId) {
        Route memory route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        if (!route.depositsEnabled) revert DepositsDisabled();
        if (amount == 0) revert InvalidAmount();
        if (goldRecipient == address(0)) revert InvalidRecipient();

        depositId = keccak256(abi.encodePacked(block.chainid, address(this), routeId, msg.sender, goldRecipient, amount, nextDepositNonce++));
        lockedByRoute[routeId] += amount;
        if (!IERC20Minimal(route.token).transferFrom(msg.sender, address(this), amount)) revert TransferFailed();
        emit Deposited(depositId, routeId, msg.sender, goldRecipient, amount);
    }

    function finalizeWithdrawal(bytes32 withdrawalId, uint256 routeId, address recipient, uint256 amount) external onlyFinalizer {
        Route memory route = routes[routeId];
        if (route.token == address(0)) revert InvalidRoute();
        if (!route.withdrawalsEnabled) revert WithdrawalsDisabled();
        if (finalizedWithdrawals[withdrawalId]) revert AlreadyFinalized();
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        if (lockedByRoute[routeId] < amount) revert InvalidAmount();

        finalizedWithdrawals[withdrawalId] = true;
        lockedByRoute[routeId] -= amount;
        if (!IERC20Minimal(route.token).transfer(recipient, amount)) revert TransferFailed();
        emit WithdrawalFinalized(withdrawalId, routeId, recipient, amount);
    }
}
