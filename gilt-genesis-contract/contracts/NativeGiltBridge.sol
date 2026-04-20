// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "./SystemV2.sol";
import "./lib/0.8.x/Utils.sol";

contract NativeGiltBridge is SystemV2 {
    using Utils for bytes;
    using Utils for string;

    address public childChainManager;

    event ChildChainManagerUpdated(address indexed childChainManager);
    event NativeGiltDeposited(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 value);

    error InvalidChildChainManager();
    error InvalidUser();
    error InvalidAmount();
    error OnlyChildChainManager();
    error InsufficientBalance();

    function updateParam(string calldata key, bytes calldata value) external onlyGov {
        if (key.compareStrings("childChainManager")) {
            if (value.length != 20) revert InvalidValue(key, value);
            _setChildChainManager(value.bytesToAddress(20));
        } else {
            revert UnknownParam(key, value);
        }
    }

    function setChildChainManager(address newChildChainManager) external onlyGovernor {
        _setChildChainManager(newChildChainManager);
    }

    function _setChildChainManager(address newChildChainManager) internal {
        if (newChildChainManager == address(0)) revert InvalidChildChainManager();
        childChainManager = newChildChainManager;
        emit ChildChainManagerUpdated(newChildChainManager);
    }

    function deposit(address user, bytes calldata depositData) external {
        if (msg.sender != childChainManager) revert OnlyChildChainManager();
        if (user == address(0)) revert InvalidUser();

        uint256 amount = abi.decode(depositData, (uint256));
        if (amount == 0) revert InvalidAmount();

        emit NativeGiltDeposited(user, amount);
    }

    function withdraw(uint256 amount) external {
        if (amount == 0) revert InvalidAmount();
        if (msg.sender.balance < amount) revert InsufficientBalance();

        emit Transfer(msg.sender, address(0), amount);
    }
}
