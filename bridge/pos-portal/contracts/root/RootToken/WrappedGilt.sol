pragma solidity 0.6.6;

import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AccessControlMixin} from "../../common/AccessControlMixin.sol";
import {NativeMetaTransaction} from "../../common/NativeMetaTransaction.sol";
import {ContextMixin} from "../../common/ContextMixin.sol";
import {IWrappedGilt} from "./IWrappedGilt.sol";

contract WrappedGilt is
    ERC20,
    AccessControlMixin,
    NativeMetaTransaction,
    ContextMixin,
    IWrappedGilt
{
    using SafeMath for uint256;

    bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");

    constructor() public ERC20("Wrapped Gold Chain GILT", "wGILT") {
        _setupContractId("WrappedGilt");
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(PREDICATE_ROLE, _msgSender());

        _initializeEIP712("Wrapped Gold Chain GILT");
    }

    function mint(address user, uint256 amount) external override only(PREDICATE_ROLE) {
        _mint(user, amount);
    }

    function burnFrom(address account, uint256 amount) public override {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
            amount,
            "ERC20: burn amount exceeds allowance"
        );
        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }

    function _msgSender()
        internal
        override
        view
        returns (address payable sender)
    {
        return ContextMixin.msgSender();
    }
}
