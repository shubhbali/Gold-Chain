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

    struct RoutePrecision {
        bool exists;
        uint256 childTokenId;
        uint8 rootDecimals;
        uint8 goldDecimals;
        uint256 scaleNumerator;
        uint256 scaleDenominator;
        uint256 rootUnit;
    }

    mapping(address => RoutePrecision) public routePrecisionByRootToken;

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

    event GoldRoutePrecisionConfigured(
        address indexed rootToken,
        uint256 indexed childTokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 scaleNumerator,
        uint256 scaleDenominator,
        uint256 rootUnit
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

    function configureGoldRoutePrecision(
        address rootToken,
        uint256 childTokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 routeScaleNumerator,
        uint256 routeScaleDenominator,
        uint256 rootUnit
    ) external only(DEFAULT_ADMIN_ROLE) {
        require(rootToken != address(0), "ScaledERC1155Predicate: INVALID_ROOT_TOKEN");
        require(childTokenId != 0, "ScaledERC1155Predicate: INVALID_TOKEN_ID");
        require(routeScaleNumerator != 0 && routeScaleDenominator != 0, "ScaledERC1155Predicate: BAD_RATIO");
        require(rootUnit != 0, "ScaledERC1155Predicate: INVALID_ROOT_UNIT");

        routePrecisionByRootToken[rootToken] = RoutePrecision({
            exists: true,
            childTokenId: childTokenId,
            rootDecimals: rootDecimals,
            goldDecimals: goldDecimals,
            scaleNumerator: routeScaleNumerator,
            scaleDenominator: routeScaleDenominator,
            rootUnit: rootUnit
        });

        emit GoldRoutePrecisionConfigured(
            rootToken,
            childTokenId,
            rootDecimals,
            goldDecimals,
            routeScaleNumerator,
            routeScaleDenominator,
            rootUnit
        );
    }

    function lockTokens(
        address depositor,
        address depositReceiver,
        address rootToken,
        bytes calldata depositData
    ) external override only(MANAGER_ROLE) returns (bytes memory) {
        (uint256 childTokenId, uint256 requestedRootAmount) = abi.decode(depositData, (uint256, uint256));
        require(requestedRootAmount != 0, "ScaledERC1155Predicate: INVALID_AMOUNT");
        RoutePrecision memory route = _route(rootToken, childTokenId);

        uint256 rootAmount = _pullAndMeasure(IERC20(rootToken), depositor, requestedRootAmount);
        require(rootAmount.mod(route.rootUnit) == 0, "ScaledERC1155Predicate: INVALID_ROOT_DIVISIBILITY");
        uint256 childAmount = _scaledAmountForDeposit(route, rootAmount);
        emit LockedScaledERC1155(
            depositor,
            depositReceiver,
            rootToken,
            childTokenId,
            rootAmount,
            childAmount
        );
        return abi.encode(childTokenId, rootAmount);
    }

    function _pullAndMeasure(IERC20 token, address depositor, uint256 requestedRootAmount) private returns (uint256) {
        uint256 beforeBalance = token.balanceOf(address(this));
        token.safeTransferFrom(depositor, address(this), requestedRootAmount);
        uint256 afterBalance = token.balanceOf(address(this));
        require(afterBalance >= beforeBalance, "ScaledERC1155Predicate: BALANCE_DECREASED");

        uint256 rootAmount = afterBalance.sub(beforeBalance);
        require(rootAmount != 0, "ScaledERC1155Predicate: INVALID_AMOUNT");
        return rootAmount;
    }

    function _scaledAmountForDeposit(RoutePrecision memory route, uint256 rootAmount) private pure returns (uint256) {
        uint256 numeratorProduct = rootAmount.mul(route.scaleNumerator);
        require(
            numeratorProduct.mod(route.scaleDenominator) == 0,
            "ScaledERC1155Predicate: NON_EXACT_DEPOSIT"
        );
        return numeratorProduct.div(route.scaleDenominator);
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
        RoutePrecision memory route = _route(rootToken, childTokenId);
        uint256 rootAmount = _rootAmountForExit(route, childAmount);
        require(rootAmount.mod(route.rootUnit) == 0, "ScaledERC1155Predicate: INVALID_ROOT_DIVISIBILITY");
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

    function _route(address rootToken, uint256 childTokenId) private view returns (RoutePrecision memory) {
        RoutePrecision memory route = routePrecisionByRootToken[rootToken];
        require(route.exists, "ScaledERC1155Predicate: ROUTE_NOT_CONFIGURED");
        require(route.childTokenId == childTokenId, "ScaledERC1155Predicate: TOKEN_ID_MISMATCH");
        return route;
    }

    function _rootAmountForExit(RoutePrecision memory route, uint256 childAmount) private pure returns (uint256) {
        uint256 denominatorProduct = childAmount.mul(route.scaleDenominator);
        require(
            denominatorProduct.mod(route.scaleNumerator) == 0,
            "ScaledERC1155Predicate: NON_EXACT_EXIT"
        );
        return denominatorProduct.div(route.scaleNumerator);
    }
}
