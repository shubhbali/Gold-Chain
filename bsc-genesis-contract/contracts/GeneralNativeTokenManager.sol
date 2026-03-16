// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "./SystemV2.sol";

contract GeneralNativeTokenManager is SystemV2 {
    uint256 public constant RATE_DENOMINATOR = 1e18;

    mapping(uint64 => bool) public allowedGasTokens;
    mapping(uint64 => bool) public allowedTransferTokens;
    mapping(uint64 => uint256) public gasConversionRate;
    mapping(address => mapping(uint64 => uint256)) public nativeBalanceOf;

    event GasTokenUpdated(uint64 indexed tokenID, bool enabled, uint256 conversionRate);
    event TransferTokenUpdated(uint64 indexed tokenID, bool enabled);
    event NativeTokenCredited(address indexed account, uint64 indexed tokenID, uint256 amount);
    event NativeTokenDebited(address indexed account, uint64 indexed tokenID, uint256 amount);

    function initialize() external {
        allowedGasTokens[0] = true;
        allowedTransferTokens[0] = true;
        gasConversionRate[0] = RATE_DENOMINATOR;
    }

    function enableGasToken(uint64 tokenID, uint256 conversionRate) external onlyGovernor {
        require(conversionRate > 0, "bad rate");
        allowedGasTokens[tokenID] = true;
        gasConversionRate[tokenID] = conversionRate;
        emit GasTokenUpdated(tokenID, true, conversionRate);
    }

    function disableGasToken(uint64 tokenID) external onlyGovernor {
        allowedGasTokens[tokenID] = false;
        emit GasTokenUpdated(tokenID, false, gasConversionRate[tokenID]);
    }

    function enableTransferToken(uint64 tokenID) external onlyGovernor {
        allowedTransferTokens[tokenID] = true;
        emit TransferTokenUpdated(tokenID, true);
    }

    function disableTransferToken(uint64 tokenID) external onlyGovernor {
        allowedTransferTokens[tokenID] = false;
        emit TransferTokenUpdated(tokenID, false);
    }

    function creditNativeToken(address account, uint64 tokenID, uint256 amount) external onlyGovernor {
        nativeBalanceOf[account][tokenID] += amount;
        emit NativeTokenCredited(account, tokenID, amount);
    }

    function debitNativeToken(address account, uint64 tokenID, uint256 amount) external onlyGovernor {
        nativeBalanceOf[account][tokenID] -= amount;
        emit NativeTokenDebited(account, tokenID, amount);
    }
}
