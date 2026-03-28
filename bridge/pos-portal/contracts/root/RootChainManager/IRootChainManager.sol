pragma solidity 0.6.6;

interface IRootChainManager {
    struct TokenMigrationStatus {
        bool isDepositDisabled;
        bool isExitDisabled;
        uint256 lastExitBlockNumber;
    }

    event TokenMapped(
        address indexed rootToken,
        address indexed childToken,
        bytes32 indexed tokenType
    );

    event PredicateRegistered(
        bytes32 indexed tokenType,
        address indexed predicateAddress
    );

    event MigrationStatusChanged(
        address indexed rootToken,
        bool isDepositDisabled,
        bool isExitDisabled,
        uint256 lastExitBlockNumber
    );

    event MigrationTokenApprovalSet(
        address indexed rootToken,
        bool approved
    );

    function registerPredicate(bytes32 tokenType, address predicateAddress)
        external;

    function mapToken(
        address rootToken,
        address childToken,
        bytes32 tokenType
    ) external;

    function mapGoldToken(
        address rootToken,
        address childToken,
        uint256 childTokenId,
        bytes32 tokenType
    ) external;

    function cleanMapToken(
        address rootToken,
        address childToken
    ) external;

    function remapToken(
        address rootToken,
        address childToken,
        bytes32 tokenType
    ) external;

    function depositEtherFor(address user) external payable;

    function depositFor(
        address user,
        address rootToken,
        bytes calldata depositData
    ) external;

    function exit(bytes calldata inputData) external;

    function setTokenMigrationManager(
        address rootToken,
        bool approved
    ) external;

    function updateTokenMigrationStatus(
        address rootToken,
        bool isDepositDisable,
        bool isExitDisabled,
        uint256 lastExitBlockNumber
    ) external;

    function migrateBridgeFunds(address rootToken, bytes calldata data)
        external;

    function isMigrated(address rootToken) external view returns (bool);
}
