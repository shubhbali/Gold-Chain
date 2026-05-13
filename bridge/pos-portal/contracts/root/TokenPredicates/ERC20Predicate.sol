pragma solidity 0.6.6;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {AccessControlMixin} from "../../common/AccessControlMixin.sol";
import {RLPReader} from "../../lib/RLPReader.sol";
import {ITokenPredicate} from "./ITokenPredicate.sol";
import {Initializable} from "../../common/Initializable.sol";

contract ERC20Predicate is ITokenPredicate, AccessControlMixin, Initializable {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant TOKEN_TYPE = keccak256("ERC20");
    bytes32 public constant TRANSFER_EVENT_SIG = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;

    event LockedERC20(
        address indexed depositor,
        address indexed depositReceiver,
        address indexed rootToken,
        uint256 amount
    );

    event ExitedERC20(
        address indexed exitor,
        address indexed rootToken,
        uint256 amount
    );

    constructor() public {
        // Disable initializer on implementation contract
        _disableInitializer();
    }

    function initialize(address _owner) external initializer {
        _setupContractId("ERC20Predicate");
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        _setupRole(MANAGER_ROLE, _owner);
    }

    /**
     * @notice Lock ERC20 tokens for deposit, callable only by manager
     * @param depositor Address who wants to deposit tokens
     * @param depositReceiver Address (address) who wants to receive tokens on child chain
     * @param rootToken Token which gets deposited
     * @param depositData ABI encoded amount
     */
    function lockTokens(
        address depositor,
        address depositReceiver,
        address rootToken,
        bytes calldata depositData
    )
        external
        override
        only(MANAGER_ROLE)
        returns (bytes memory)
    {
        uint256 requestedAmount = abi.decode(depositData, (uint256));
        IERC20 token = IERC20(rootToken);

        uint256 beforeBalance = token.balanceOf(address(this));
        token.safeTransferFrom(depositor, address(this), requestedAmount);
        uint256 afterBalance = token.balanceOf(address(this));
        require(afterBalance >= beforeBalance, "ERC20Predicate: BALANCE_DECREASED");

        uint256 actualReceived = afterBalance.sub(beforeBalance);
        require(actualReceived != 0, "ERC20Predicate: INVALID_AMOUNT");

        emit LockedERC20(depositor, depositReceiver, rootToken, actualReceived);
        return abi.encode(actualReceived);
    }

    /**
     * @notice Validates log signature, from and to address
     * then sends the correct amount to withdrawer
     * callable only by manager
     * @notice address unused, being kept for abi compatability
     * @param rootToken Token which gets withdrawn
     * @param log Valid ERC20 burn log from child chain
     */
    function exitTokens(
        address,
        address rootToken,
        bytes calldata log
    )
        external
        override
        only(MANAGER_ROLE)
    {
        RLPReader.RLPItem[] memory logRLPList = log.toRlpItem().toList();
        RLPReader.RLPItem[] memory logTopicRLPList = logRLPList[1].toList(); // topics

        require(
            bytes32(logTopicRLPList[0].toUint()) == TRANSFER_EVENT_SIG, // topic0 is event sig
            "ERC20Predicate: INVALID_SIGNATURE"
        );

        address withdrawer = address(logTopicRLPList[1].toUint()); // topic1 is from address

        require(
            address(logTopicRLPList[2].toUint()) == address(0), // topic2 is to address
            "ERC20Predicate: INVALID_RECEIVER"
        );

        uint256 amount = logRLPList[2].toUint(); // log data field is the amount

        IERC20(rootToken).safeTransfer(
            withdrawer,
            amount
        );

        emit ExitedERC20(withdrawer, rootToken, amount);
    }

    /**
     * @notice Allows migration of tokens from the predicate to another address.
     * @dev Note: Only allowed for ERC20 standard as of now.
     * @param target The target address.
     * @param data ABI encoded information including details like the token amount, and other relevant data.
     */
    function migrateTokens(address target, bytes calldata data)
        external
        override
        only(MANAGER_ROLE)
    {
        (bool ok, bytes memory ret) = target.call(data);
        assembly {
            if iszero(ok) { revert(add(32, ret), ret) }
        }
    }
}
