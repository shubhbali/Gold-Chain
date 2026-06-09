// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IGoldBridgeMinter {
    function finalizeDeposit(bytes32 depositId, uint256 routeId, uint256 amount, address recipient) external;
    function burnForWithdrawal(address account, uint256 routeId, uint256 amount) external;
}

contract GoldChildBridge {
    address public governance;
    address public depositFinalizer;
    IGoldBridgeMinter public immutable minter;
    uint256 public nextWithdrawalNonce;

    mapping(bytes32 => bool) public finalizedDeposits;

    event DepositFinalized(bytes32 indexed depositId, uint256 indexed routeId, address indexed recipient, uint256 amount);
    event WithdrawalInitiated(bytes32 indexed withdrawalId, uint256 indexed routeId, address indexed account, address ethereumRecipient, uint256 amount);

    error NotGovernance();
    error NotFinalizer();
    error AlreadyFinalized();
    error InvalidAmount();
    error InvalidRecipient();

    modifier onlyGovernance() {
        if (msg.sender != governance) revert NotGovernance();
        _;
    }

    modifier onlyFinalizer() {
        if (msg.sender != depositFinalizer) revert NotFinalizer();
        _;
    }

    constructor(IGoldBridgeMinter minter_, address governance_, address depositFinalizer_) {
        require(address(minter_) != address(0), "invalid minter");
        require(governance_ != address(0), "invalid governance");
        require(depositFinalizer_ != address(0), "invalid finalizer");
        minter = minter_;
        governance = governance_;
        depositFinalizer = depositFinalizer_;
    }

    function setDepositFinalizer(address finalizer) external onlyGovernance {
        require(finalizer != address(0), "invalid finalizer");
        depositFinalizer = finalizer;
    }

    function finalizeDeposit(bytes32 depositId, uint256 routeId, uint256 amount, address recipient) external onlyFinalizer {
        if (finalizedDeposits[depositId]) revert AlreadyFinalized();
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        finalizedDeposits[depositId] = true;
        minter.finalizeDeposit(depositId, routeId, amount, recipient);
        emit DepositFinalized(depositId, routeId, recipient, amount);
    }

    function withdraw(uint256 routeId, uint256 amount, address ethereumRecipient) external returns (bytes32 withdrawalId) {
        if (ethereumRecipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();
        withdrawalId = keccak256(abi.encodePacked(block.chainid, address(this), routeId, msg.sender, ethereumRecipient, amount, nextWithdrawalNonce++));
        minter.burnForWithdrawal(msg.sender, routeId, amount);
        emit WithdrawalInitiated(withdrawalId, routeId, msg.sender, ethereumRecipient, amount);
    }
}
