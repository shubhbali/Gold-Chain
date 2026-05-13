pragma solidity 0.6.6;

import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {AccessControlMixin} from "../../common/AccessControlMixin.sol";
import {IChildToken} from "./IChildToken.sol";
import {NativeMetaTransaction} from "../../common/NativeMetaTransaction.sol";
import {ContextMixin} from "../../common/ContextMixin.sol";

contract ChildGold1155 is
    ERC1155,
    IChildToken,
    AccessControlMixin,
    NativeMetaTransaction,
    ContextMixin
{
    using SafeMath for uint256;

    bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");

    uint256 public constant PAXG_TOKEN_ID = 1;
    uint256 public constant XAUT_TOKEN_ID = 2;

    string public name;
    string public symbol;
    uint256 public scaleNumerator;
    uint256 public scaleDenominator;

    struct RoutePrecision {
        bool exists;
        uint8 rootDecimals;
        uint8 goldDecimals;
        uint256 scaleNumerator;
        uint256 scaleDenominator;
        uint256 rootUnit;
    }

    mapping(uint256 => RoutePrecision) public routePrecisionByTokenId;

    event BridgeRoutePrecisionConfigured(
        uint256 indexed tokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 scaleNumerator,
        uint256 scaleDenominator,
        uint256 rootUnit
    );

    constructor(
        string memory uri_,
        address childChainManager,
        uint256 _scaleNumerator,
        uint256 _scaleDenominator
    ) public ERC1155(uri_) {
        require(_scaleNumerator != 0 && _scaleDenominator != 0, "ChildGold1155: BAD_RATIO");
        _setupContractId("ChildGold1155");
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(DEPOSITOR_ROLE, childChainManager);
        _initializeEIP712(uri_);
        name = "Physical Gold";
        symbol = "PGOLD";
        scaleNumerator = _scaleNumerator;
        scaleDenominator = _scaleDenominator;
        _setRoutePrecision(PAXG_TOKEN_ID, 18, 18, _scaleNumerator, _scaleDenominator, 1);
        _setRoutePrecision(XAUT_TOKEN_ID, 6, 18, _scaleNumerator.mul(10 ** 12), _scaleDenominator, 1);
    }

    function _msgSender()
        internal
        override
        view
        returns (address payable sender)
    {
        return ContextMixin.msgSender();
    }

    function deposit(address user, bytes calldata depositData)
        external
        override
        only(DEPOSITOR_ROLE)
    {
        (uint256 tokenId, uint256 rootAmount) = abi.decode(
            depositData,
            (uint256, uint256)
        );
        require(user != address(0), "ChildGold1155: INVALID_DEPOSIT_USER");
        require(_isSupportedTokenId(tokenId), "ChildGold1155: INVALID_TOKEN_ID");
        require(rootAmount != 0, "ChildGold1155: INVALID_AMOUNT");
        RoutePrecision memory route = _route(tokenId);
        require(rootAmount.mod(route.rootUnit) == 0, "ChildGold1155: INVALID_ROOT_DIVISIBILITY");

        uint256 numeratorProduct = rootAmount.mul(route.scaleNumerator);
        require(
            numeratorProduct.mod(route.scaleDenominator) == 0,
            "ChildGold1155: NON_EXACT_DEPOSIT"
        );

        _mint(user, tokenId, numeratorProduct.div(route.scaleDenominator), bytes(""));
    }

    function withdrawSingle(uint256 tokenId, uint256 amount) external {
        require(_isSupportedTokenId(tokenId), "ChildGold1155: INVALID_TOKEN_ID");
        require(amount != 0, "ChildGold1155: INVALID_AMOUNT");
        RoutePrecision memory route = _route(tokenId);

        uint256 denominatorProduct = amount.mul(route.scaleDenominator);
        require(
            denominatorProduct.mod(route.scaleNumerator) == 0,
            "ChildGold1155: NON_EXACT_WITHDRAW"
        );
        uint256 rootAmount = denominatorProduct.div(route.scaleNumerator);
        require(rootAmount.mod(route.rootUnit) == 0, "ChildGold1155: INVALID_ROOT_DIVISIBILITY");

        _burn(_msgSender(), tokenId, amount);
    }

    function setBridgeRoutePrecision(
        uint256 tokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 routeScaleNumerator,
        uint256 routeScaleDenominator,
        uint256 rootUnit
    ) external only(DEFAULT_ADMIN_ROLE) {
        _setRoutePrecision(
            tokenId,
            rootDecimals,
            goldDecimals,
            routeScaleNumerator,
            routeScaleDenominator,
            rootUnit
        );
    }

    function _isSupportedTokenId(uint256 tokenId) internal pure returns (bool) {
        return tokenId == PAXG_TOKEN_ID || tokenId == XAUT_TOKEN_ID;
    }

    function _route(uint256 tokenId) internal view returns (RoutePrecision memory) {
        RoutePrecision memory route = routePrecisionByTokenId[tokenId];
        require(route.exists, "ChildGold1155: ROUTE_NOT_CONFIGURED");
        return route;
    }

    function _setRoutePrecision(
        uint256 tokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 routeScaleNumerator,
        uint256 routeScaleDenominator,
        uint256 rootUnit
    ) internal {
        require(_isSupportedTokenId(tokenId), "ChildGold1155: INVALID_TOKEN_ID");
        require(routeScaleNumerator != 0 && routeScaleDenominator != 0, "ChildGold1155: BAD_RATIO");
        require(rootUnit != 0, "ChildGold1155: INVALID_ROOT_UNIT");

        routePrecisionByTokenId[tokenId] = RoutePrecision({
            exists: true,
            rootDecimals: rootDecimals,
            goldDecimals: goldDecimals,
            scaleNumerator: routeScaleNumerator,
            scaleDenominator: routeScaleDenominator,
            rootUnit: rootUnit
        });

        emit BridgeRoutePrecisionConfigured(
            tokenId,
            rootDecimals,
            goldDecimals,
            routeScaleNumerator,
            routeScaleDenominator,
            rootUnit
        );
    }
}
