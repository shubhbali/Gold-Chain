// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./PhysicalGold1155.sol";
import "./SystemV2.sol";

contract GoldMigrationController is SystemV2 {
    enum LifecycleState {
        INACTIVE,
        PREPARE,
        ACTIVE,
        EXIT_ONLY,
        FINALIZED
    }

    uint8 public constant ACTIVE_STATE = uint8(LifecycleState.ACTIVE);
    uint256 public constant PAXG_TOKEN_ID = 1;
    uint256 public constant XAUT_TOKEN_ID = 2;

    IERC1155 public legacyGold;
    PhysicalGold1155 public finalGold;
    address public reserveVault;
    address public stakeMigrationCaller;
    address public walletMigrationRouter;
    LifecycleState public lifecycleState;
    bool public migrationPaused = true;
    uint256 public exitCutoffBlock;

    mapping(uint256 => uint256) public legacyCapturedById;
    mapping(uint256 => uint256) public finalMintedById;
    uint256 public totalLegacyCaptured;
    uint256 public totalFinalMinted;

    event LifecycleChanged(LifecycleState indexed previousState, LifecycleState indexed newState, uint256 atBlock);
    event MigrationPausedSet(bool paused);
    event MigrationPrepared(
        address indexed legacyGold,
        address indexed finalGold,
        address indexed reserveVault,
        address stakeMigrationCaller
    );
    event StakeMigrationCallerUpdated(address indexed previousCaller, address indexed newCaller);
    event WalletMigrationRouterUpdated(address indexed previousRouter, address indexed newRouter);
    event WalletMigrated(address indexed account, uint256 indexed tokenId, uint256 amount, bytes32 migrationRef);
    event StakeMigrated(
        address indexed operator,
        address indexed delegator,
        uint256 indexed tokenId,
        uint256 amount,
        bytes32 migrationRef
    );

    error InvalidRequest();
    error InvalidState(LifecycleState expected, LifecycleState actual);

    modifier whenMigrationActive() {
        if (lifecycleState != LifecycleState.ACTIVE) revert InvalidState(LifecycleState.ACTIVE, lifecycleState);
        if (migrationPaused) revert InvalidRequest();
        _;
    }

    modifier onlyGovernanceExecutor() {
        if (msg.sender != GOV_HUB_ADDR && msg.sender != TIMELOCK_ADDR) revert OnlySystemContract(GOV_HUB_ADDR);
        _;
    }

    modifier onlyStakeMigrationCaller() {
        if (msg.sender != stakeMigrationCaller || stakeMigrationCaller == address(0)) revert InvalidRequest();
        _;
    }

    function activatePrepare(
        address legacyGold_,
        address finalGold_,
        address reserveVault_,
        address stakeMigrationCaller_
    ) external onlyGovernanceExecutor {
        if (
            legacyGold_ == address(0) || finalGold_ == address(0) || reserveVault_ == address(0)
                || stakeMigrationCaller_ == address(0)
        ) revert InvalidRequest();
        if (lifecycleState != LifecycleState.INACTIVE) revert InvalidState(LifecycleState.INACTIVE, lifecycleState);

        legacyGold = IERC1155(legacyGold_);
        finalGold = PhysicalGold1155(finalGold_);
        reserveVault = reserveVault_;
        stakeMigrationCaller = stakeMigrationCaller_;
        if (finalGold.migrationController() != address(this)) revert InvalidRequest();
        finalGold.setMigrationMintingEnabled(false);
        migrationPaused = true;
        _setLifecycleState(LifecycleState.PREPARE);

        emit MigrationPrepared(legacyGold_, finalGold_, reserveVault_, stakeMigrationCaller_);
    }

    function setStakeMigrationCaller(address newCaller) external onlyGovernanceExecutor {
        if (newCaller == address(0)) revert InvalidRequest();
        address previousCaller = stakeMigrationCaller;
        stakeMigrationCaller = newCaller;
        emit StakeMigrationCallerUpdated(previousCaller, newCaller);
    }

    function setWalletMigrationRouter(address newRouter) external onlyGovernanceExecutor {
        address previousRouter = walletMigrationRouter;
        walletMigrationRouter = newRouter;
        emit WalletMigrationRouterUpdated(previousRouter, newRouter);
    }

    function activateMigration() external onlyGovernanceExecutor {
        if (lifecycleState != LifecycleState.PREPARE) revert InvalidState(LifecycleState.PREPARE, lifecycleState);
        finalGold.setMigrationMintingEnabled(true);
        migrationPaused = false;
        _setLifecycleState(LifecycleState.ACTIVE);
    }

    function setMigrationPaused(bool paused_) external onlyGovernanceExecutor {
        migrationPaused = paused_;
        emit MigrationPausedSet(paused_);
    }

    function setExitOnly(uint256 cutoffBlock) external onlyGovernanceExecutor {
        if (lifecycleState != LifecycleState.ACTIVE) revert InvalidState(LifecycleState.ACTIVE, lifecycleState);
        if (cutoffBlock <= block.number) revert InvalidRequest();
        exitCutoffBlock = cutoffBlock;
        _setLifecycleState(LifecycleState.EXIT_ONLY);
    }

    function finalizeMigration() external onlyGovernanceExecutor {
        if (lifecycleState != LifecycleState.EXIT_ONLY) revert InvalidState(LifecycleState.EXIT_ONLY, lifecycleState);
        if (exitCutoffBlock != 0 && block.number <= exitCutoffBlock) revert InvalidRequest();
        finalGold.finalizeMigrationMinting();
        _setLifecycleState(LifecycleState.FINALIZED);
    }

    function migrateWallet(uint256 tokenId, uint256 amount) external whenMigrationActive {
        _migrateWalletFor(msg.sender, tokenId, amount);
    }

    function migrateWalletFor(address account, uint256 tokenId, uint256 amount) external whenMigrationActive {
        if (account == address(0)) revert InvalidRequest();
        if (msg.sender != account && msg.sender != walletMigrationRouter) revert InvalidRequest();
        _migrateWalletFor(account, tokenId, amount);
    }

    function migrateStake(address delegator, uint256 tokenId, uint256 amount)
        external
        whenMigrationActive
        onlyStakeMigrationCaller
    {
        if (delegator == address(0)) revert InvalidRequest();
        bytes32 migrationRef = _buildStakeMigrationRef(msg.sender, delegator, tokenId, amount);
        _migrate(msg.sender, msg.sender, tokenId, amount, migrationRef);
        emit StakeMigrated(msg.sender, delegator, tokenId, amount, migrationRef);
    }

    function _migrateWalletFor(address account, uint256 tokenId, uint256 amount) internal {
        bytes32 migrationRef = _buildMigrationRef(account, account, tokenId, amount, false);
        _migrate(account, account, tokenId, amount, migrationRef);
        emit WalletMigrated(account, tokenId, amount, migrationRef);
    }

    function _migrate(address source, address beneficiary, uint256 tokenId, uint256 amount, bytes32 migrationRef)
        internal
    {
        if (!_isSupportedTokenId(tokenId) || amount == 0 || source == address(0) || beneficiary == address(0)) {
            revert InvalidRequest();
        }
        if (address(legacyGold) == address(0) || address(finalGold) == address(0) || reserveVault == address(0)) {
            revert InvalidRequest();
        }

        legacyGold.safeTransferFrom(source, reserveVault, tokenId, amount, "");
        finalGold.mintForMigration(beneficiary, tokenId, amount, migrationRef);

        legacyCapturedById[tokenId] += amount;
        finalMintedById[tokenId] += amount;
        totalLegacyCaptured += amount;
        totalFinalMinted += amount;
    }

    function _setLifecycleState(LifecycleState newState) internal {
        LifecycleState previousState = lifecycleState;
        lifecycleState = newState;
        emit LifecycleChanged(previousState, newState, block.number);
    }

    function _buildMigrationRef(address source, address beneficiary, uint256 tokenId, uint256 amount, bool fromStake)
        internal
        view
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(block.chainid, source, beneficiary, tokenId, amount, fromStake, block.number));
    }

    function _buildStakeMigrationRef(address operator, address delegator, uint256 tokenId, uint256 amount)
        internal
        view
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(block.chainid, operator, delegator, tokenId, amount, true, block.number));
    }

    function _isSupportedTokenId(uint256 tokenId) internal pure returns (bool) {
        return tokenId == PAXG_TOKEN_ID || tokenId == XAUT_TOKEN_ID;
    }
}
