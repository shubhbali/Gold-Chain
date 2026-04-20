pragma solidity 0.6.6;

import "../../child/ChildToken/ChildERC20.sol";

// These are the potatoes on the child chain
contract ChildPotatoToken is ChildERC20 {
  constructor(address childChainManager) public ChildERC20("Potato", "PTT", 18, childChainManager) {}
}
