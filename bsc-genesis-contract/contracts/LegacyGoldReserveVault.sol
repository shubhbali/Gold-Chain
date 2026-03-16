// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract LegacyGoldReserveVault is Ownable {
    using SafeERC20 for IERC20;

    event LegacyGoldReleased(address indexed token, address indexed recipient, uint256 amount);

    function release(address token, address recipient, uint256 amount) external onlyOwner {
        IERC20(token).safeTransfer(recipient, amount);
        emit LegacyGoldReleased(token, recipient, amount);
    }
}
