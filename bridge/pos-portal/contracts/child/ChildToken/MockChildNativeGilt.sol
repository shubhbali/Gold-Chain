pragma solidity 0.6.6;

import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {AccessControlMixin} from "../../common/AccessControlMixin.sol";
import {IChildToken} from "./IChildToken.sol";

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

    function deposit(address user, bytes calldata depositData)
        external
        override
        only(DEPOSITOR_ROLE)
    {
        uint256 amount = abi.decode(depositData, (uint256));
        credited[user] = credited[user].add(amount);
        emit NativeGiltDeposited(user, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount != 0, "MockChildNativeGilt: INVALID_AMOUNT");
        credited[msg.sender] = credited[msg.sender].sub(amount);
        emit Transfer(msg.sender, address(0), amount);
    }
}
