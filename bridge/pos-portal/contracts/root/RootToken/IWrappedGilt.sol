import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity 0.6.6;

interface IWrappedGilt is IERC20 {
    function mint(address user, uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}
