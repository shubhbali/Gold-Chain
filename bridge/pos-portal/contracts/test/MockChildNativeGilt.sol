pragma solidity 0.6.6;

import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {AccessControlMixin} from "../common/AccessControlMixin.sol";
import {IChildToken} from "../child/ChildToken/IChildToken.sol";

contract MockChildNativeGilt is IChildToken, AccessControlMixin {
    using SafeMath for uint256;

    bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");

    mapping(address => uint256) public credited;

    event NativeGiltDeposited(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address childChainManager) public {
        _setupContractId("MockChildNativeGilt");
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(DEPOSITOR_ROLE, childChainManager);
    }

    receive() external payable {}

    function deposit(address user, bytes calldata depositData)
        external
        override
        only(DEPOSITOR_ROLE)
    {
        uint256 amount = abi.decode(depositData, (uint256));
        require(address(this).balance >= amount, "MockChildNativeGilt: INSUFFICIENT_LIQUIDITY");
        credited[user] = credited[user].add(amount);
        (bool success, ) = payable(user).call{value: amount}("");
        require(success, "MockChildNativeGilt: NATIVE_TRANSFER_FAILED");
        emit NativeGiltDeposited(user, amount);
    }

    function withdraw(uint256 amount) external payable {
        require(amount != 0, "MockChildNativeGilt: INVALID_AMOUNT");
        require(msg.value == amount, "MockChildNativeGilt: INVALID_MSG_VALUE");
        credited[msg.sender] = credited[msg.sender].sub(amount);
        emit Transfer(msg.sender, address(0), amount);
    }
}
