pragma solidity 0.6.6;

import {ChildERC20} from "./ChildERC20.sol";

contract GiltWETH is ChildERC20 {
    constructor(address childChainManager) public ChildERC20("Wrapped Ether", "WETH", 18, childChainManager) {}
}
