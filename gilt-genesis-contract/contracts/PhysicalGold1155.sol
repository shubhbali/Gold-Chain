// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract PhysicalGold1155 is ERC1155, ERC1155Supply, AccessControl {
    uint256 public constant PAXG_TOKEN_ID = 1;
    uint256 public constant XAUT_TOKEN_ID = 2;
    bytes32 public constant BRIDGE_MINTER_ROLE = keccak256("BRIDGE_MINTER_ROLE");

    string public name;
    string public symbol;
    address public bridgeDepositor;
    address public migrationController;
    bool public migrationMintingEnabled;
    bool public migrationMintingFinalized;
    uint256 public immutable bridgeScaleNumerator;
    uint256 public immutable bridgeScaleDenominator;

    struct RoutePrecision {
        bool enabled;
        uint8 rootDecimals;
        uint8 goldDecimals;
        uint256 scaleNumerator;
        uint256 scaleDenominator;
        uint256 rootUnit;
    }

    mapping(uint256 => RoutePrecision) public bridgeRoutePrecision;

    event BridgeRatioInitialized(uint256 scaleNumerator, uint256 scaleDenominator);
    event BridgeDepositorUpdated(address indexed previousBridgeDepositor, address indexed newBridgeDepositor);
    event MigrationControllerUpdated(address indexed previousController, address indexed newController);
    event MigrationMintingEnabledSet(bool enabled);
    event MigrationMintingFinalized();
    event MigrationMint(address indexed account, uint256 indexed tokenId, uint256 amount, bytes32 migrationRef);
    event BridgeRoutePrecisionSet(
        uint256 indexed tokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 scaleNumerator,
        uint256 scaleDenominator,
        uint256 rootUnit
    );

    constructor(string memory uri_, uint256 scaleNumerator_, uint256 scaleDenominator_, address admin_) ERC1155(uri_) {
        require(scaleNumerator_ != 0 && scaleDenominator_ != 0, "invalid bridge ratio");
        require(admin_ != address(0), "invalid admin");
        name = "Physical Gold";
        symbol = "PGOLD";
        bridgeScaleNumerator = scaleNumerator_;
        bridgeScaleDenominator = scaleDenominator_;
        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
        _setBridgeRoutePrecision(PAXG_TOKEN_ID, 18, 18, scaleNumerator_, scaleDenominator_, 1);
        _setBridgeRoutePrecision(XAUT_TOKEN_ID, 6, 18, scaleNumerator_ * (10 ** 12), scaleDenominator_, 1);
        emit BridgeRatioInitialized(scaleNumerator_, scaleDenominator_);
    }

    function setBridgeDepositor(address newBridgeDepositor) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(newBridgeDepositor != address(0), "invalid bridge depositor");
        address previousBridgeDepositor = bridgeDepositor;
        if (previousBridgeDepositor != address(0) && previousBridgeDepositor != newBridgeDepositor) {
            _revokeRole(BRIDGE_MINTER_ROLE, previousBridgeDepositor);
        }
        bridgeDepositor = newBridgeDepositor;
        _grantRole(BRIDGE_MINTER_ROLE, newBridgeDepositor);
        emit BridgeDepositorUpdated(previousBridgeDepositor, newBridgeDepositor);
    }

    function setMigrationController(address newMigrationController) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!migrationMintingFinalized, "migration minting finalized");
        require(newMigrationController != address(0), "invalid migration controller");
        address previousController = migrationController;
        migrationController = newMigrationController;
        emit MigrationControllerUpdated(previousController, newMigrationController);
    }

    function setBridgeRoutePrecision(
        uint256 tokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 scaleNumerator_,
        uint256 scaleDenominator_,
        uint256 rootUnit
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setBridgeRoutePrecision(tokenId, rootDecimals, goldDecimals, scaleNumerator_, scaleDenominator_, rootUnit);
    }

    function setMigrationMintingEnabled(bool enabled) external {
        require(msg.sender == migrationController || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "missing migration authority");
        require(!migrationMintingFinalized, "migration minting finalized");
        migrationMintingEnabled = enabled;
        emit MigrationMintingEnabledSet(enabled);
    }

    function finalizeMigrationMinting() external {
        require(msg.sender == migrationController || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "missing migration authority");
        require(!migrationMintingFinalized, "migration minting finalized");
        migrationMintingEnabled = false;
        migrationMintingFinalized = true;
        emit MigrationMintingEnabledSet(false);
        emit MigrationMintingFinalized();
    }

    function mintForMigration(address account, uint256 tokenId, uint256 amount, bytes32 migrationRef)
        external
    {
        require(msg.sender == migrationController, "only migration controller");
        require(migrationMintingEnabled, "migration minting disabled");
        require(_isSupportedTokenId(tokenId), "unsupported token id");
        require(account != address(0), "invalid account");
        require(amount != 0, "invalid amount");
        _mint(account, tokenId, amount, "");
        emit MigrationMint(account, tokenId, amount, migrationRef);
    }

    function burn(address account, uint256 tokenId, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _burn(account, tokenId, amount);
    }

    function burnBatch(address account, uint256[] calldata tokenIds, uint256[] calldata amounts)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _burnBatch(account, tokenIds, amounts);
    }

    function deposit(address account, bytes calldata depositData) external {
        require(msg.sender == bridgeDepositor, "only bridge depositor");
        require(hasRole(BRIDGE_MINTER_ROLE, msg.sender), "missing bridge role");
        require(account != address(0), "invalid account");

        (uint256 tokenId, uint256 rootAmount) = abi.decode(depositData, (uint256, uint256));
        require(_isSupportedTokenId(tokenId), "unsupported token id");
        require(rootAmount != 0, "invalid amount");
        RoutePrecision memory route = _route(tokenId);
        require(rootAmount % route.rootUnit == 0, "invalid route divisibility");

        uint256 scaledAmount = rootAmount * route.scaleNumerator;
        require(scaledAmount % route.scaleDenominator == 0, "non exact deposit");
        _mint(account, tokenId, scaledAmount / route.scaleDenominator, "");
    }

    function withdrawSingle(uint256 tokenId, uint256 amount) external {
        require(_isSupportedTokenId(tokenId), "unsupported token id");
        require(amount != 0, "invalid amount");
        RoutePrecision memory route = _route(tokenId);
        uint256 scaledAmount = amount * route.scaleDenominator;
        require(scaledAmount % route.scaleNumerator == 0, "non exact withdraw");
        uint256 rootAmount = scaledAmount / route.scaleNumerator;
        require(rootAmount % route.rootUnit == 0, "invalid route divisibility");
        _burn(msg.sender, tokenId, amount);
    }

    function _isSupportedTokenId(uint256 tokenId) internal pure returns (bool) {
        return tokenId == PAXG_TOKEN_ID || tokenId == XAUT_TOKEN_ID;
    }

    function _route(uint256 tokenId) internal view returns (RoutePrecision memory) {
        RoutePrecision memory route = bridgeRoutePrecision[tokenId];
        require(route.enabled, "route not configured");
        return route;
    }

    function _setBridgeRoutePrecision(
        uint256 tokenId,
        uint8 rootDecimals,
        uint8 goldDecimals,
        uint256 scaleNumerator_,
        uint256 scaleDenominator_,
        uint256 rootUnit
    ) internal {
        require(_isSupportedTokenId(tokenId), "unsupported token id");
        require(scaleNumerator_ != 0 && scaleDenominator_ != 0, "invalid bridge ratio");
        require(rootUnit != 0, "invalid root unit");

        bridgeRoutePrecision[tokenId] = RoutePrecision({
            enabled: true,
            rootDecimals: rootDecimals,
            goldDecimals: goldDecimals,
            scaleNumerator: scaleNumerator_,
            scaleDenominator: scaleDenominator_,
            rootUnit: rootUnit
        });

        emit BridgeRoutePrecisionSet(
            tokenId,
            rootDecimals,
            goldDecimals,
            scaleNumerator_,
            scaleDenominator_,
            rootUnit
        );
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
