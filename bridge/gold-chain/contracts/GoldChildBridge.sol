// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IGoldBridgeMinter {
    function finalizeDeposit(bytes32 depositId, uint256 routeId, uint256 amount, address recipient) external;
    function burnForWithdrawal(address account, uint256 routeId, uint256 amount) external;
}

contract GoldChildBridge {
    address public governance;
    address public pendingGovernance;
    address public depositFinalizer;
    IGoldBridgeMinter public immutable minter;
    bool public paused;
    uint256 public nextWithdrawalNonce;
    uint256 private _reentrancyLock = 1;

    mapping(bytes32 => bool) public finalizedDeposits;

    event GovernanceTransferStarted(address indexed currentGovernance, address indexed pendingGovernance);
    event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);
    event DepositFinalizerSet(address indexed previousFinalizer, address indexed newFinalizer);
    event Paused(address indexed account);
    event Unpaused(address indexed account);
    event DepositFinalized(bytes32 indexed depositId, uint256 indexed routeId, address indexed recipient, uint256 amount);
    event WithdrawalInitiated(bytes32 indexed withdrawalId, uint256 indexed routeId, address indexed account, address ethereumRecipient, uint256 amount);

    error NotGovernance();
    error NotPendingGovernance();
    error NotFinalizer();
    error AlreadyFinalized();
    error InvalidAmount();
    error InvalidRecipient();
    error PausedError();
    error Reentrancy();

    modifier onlyGovernance() {
        if (msg.sender != governance) revert NotGovernance();
        _;
    }

    modifier onlyFinalizer() {
        if (msg.sender != depositFinalizer) revert NotFinalizer();
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

    constructor(IGoldBridgeMinter minter_, address governance_, address depositFinalizer_) {
        require(address(minter_) != address(0), "invalid minter");
        require(governance_ != address(0), "invalid governance");
        require(depositFinalizer_ != address(0), "invalid finalizer");
        minter = minter_;
        governance = governance_;
        depositFinalizer = depositFinalizer_;
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

    function setDepositFinalizer(address finalizer) external onlyGovernance {
        require(finalizer != address(0), "invalid finalizer");
        address previous = depositFinalizer;
        depositFinalizer = finalizer;
        emit DepositFinalizerSet(previous, finalizer);
    }

    function finalizeDeposit(bytes32 depositId, uint256 routeId, uint256 amount, address recipient)
        external
        onlyFinalizer
        nonReentrant
        whenNotPaused
    {
        if (finalizedDeposits[depositId]) revert AlreadyFinalized();
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        finalizedDeposits[depositId] = true;
        minter.finalizeDeposit(depositId, routeId, amount, recipient);
        emit DepositFinalized(depositId, routeId, recipient, amount);
    }

    function withdraw(uint256 routeId, uint256 amount, address ethereumRecipient)
        external
        nonReentrant
        whenNotPaused
        returns (bytes32 withdrawalId)
    {
        if (ethereumRecipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        withdrawalId = keccak256(abi.encodePacked(block.chainid, address(this), routeId, msg.sender, ethereumRecipient, amount, nextWithdrawalNonce++));
        minter.burnForWithdrawal(msg.sender, routeId, amount);
        emit WithdrawalInitiated(withdrawalId, routeId, msg.sender, ethereumRecipient, amount);
    }
}
