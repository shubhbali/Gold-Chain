pragma solidity 0.6.6;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {AccessControlMixin} from "../../common/AccessControlMixin.sol";
import {RLPReader} from "../../lib/RLPReader.sol";
import {ITokenPredicate} from "./ITokenPredicate.sol";
import {Initializable} from "../../common/Initializable.sol";

contract ScaledERC1155Predicate is ITokenPredicate, AccessControlMixin, Initializable {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant TOKEN_TYPE = keccak256("ScaledERC1155");
    bytes32 public constant TRANSFER_SINGLE_EVENT_SIG = keccak256(
        "TransferSingle(address,address,address,uint256,uint256)"
    );

    uint256 public scaleNumerator;
    uint256 public scaleDenominator;

    event LockedScaledERC1155(
        address indexed depositor,
        address indexed depositReceiver,
        address indexed rootToken,
        uint256 childTokenId,
        uint256 rootAmount,
        uint256 childAmount
    );

    event ExitedScaledERC1155(
        address indexed exitor,
        address indexed rootToken,
        uint256 childTokenId,
        uint256 childAmount,
        uint256 rootAmount
    );

    constructor() public {
        _disableInitializer();
    }

    function initialize(
        address _owner,
        uint256 _scaleNumerator,
        uint256 _scaleDenominator
    ) external initializer {
        require(_scaleNumerator != 0 && _scaleDenominator != 0, "ScaledERC1155Predicate: BAD_RATIO");
        _setupContractId("ScaledERC1155Predicate");
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        _setupRole(MANAGER_ROLE, _owner);
        scaleNumerator = _scaleNumerator;
        scaleDenominator = _scaleDenominator;
    }

    function lockTokens(
        address depositor,
        address depositReceiver,
        address rootToken,
        bytes calldata depositData
    ) external override only(MANAGER_ROLE) {
        (uint256 childTokenId, uint256 rootAmount) = abi.decode(
            depositData,
            (uint256, uint256)
        );
        require(rootAmount != 0, "ScaledERC1155Predicate: INVALID_AMOUNT");

        uint256 numeratorProduct = rootAmount.mul(scaleNumerator);
        require(
            numeratorProduct.mod(scaleDenominator) == 0,
            "ScaledERC1155Predicate: NON_EXACT_DEPOSIT"
        );

        uint256 childAmount = numeratorProduct.div(scaleDenominator);
        emit LockedScaledERC1155(
            depositor,
            depositReceiver,
            rootToken,
            childTokenId,
            rootAmount,
            childAmount
        );
        IERC20(rootToken).safeTransferFrom(depositor, address(this), rootAmount);
    }

    function exitTokens(
        address,
        address rootToken,
        bytes calldata log
    ) external override only(MANAGER_ROLE) {
        RLPReader.RLPItem[] memory logRLPList = log.toRlpItem().toList();
        RLPReader.RLPItem[] memory logTopicRLPList = logRLPList[1].toList();

        require(
            bytes32(logTopicRLPList[0].toUint()) == TRANSFER_SINGLE_EVENT_SIG,
            "ScaledERC1155Predicate: INVALID_SIGNATURE"
        );

        address withdrawer = address(logTopicRLPList[2].toUint());
        require(
            address(logTopicRLPList[3].toUint()) == address(0),
            "ScaledERC1155Predicate: INVALID_RECEIVER"
        );

        (uint256 childTokenId, uint256 childAmount) = abi.decode(
            logRLPList[2].toBytes(),
            (uint256, uint256)
        );
        require(childAmount != 0, "ScaledERC1155Predicate: INVALID_AMOUNT");

        uint256 denominatorProduct = childAmount.mul(scaleDenominator);
        require(
            denominatorProduct.mod(scaleNumerator) == 0,
            "ScaledERC1155Predicate: NON_EXACT_EXIT"
        );

        uint256 rootAmount = denominatorProduct.div(scaleNumerator);
        IERC20(rootToken).safeTransfer(withdrawer, rootAmount);

        emit ExitedScaledERC1155(
            withdrawer,
            rootToken,
            childTokenId,
            childAmount,
            rootAmount
        );
    }

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
