// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

interface IStakeHub {
    function DEAD_ADDRESS() external view returns (address);
    function LOCK_AMOUNT() external view returns (uint256);
    function BREATHE_BLOCK_INTERVAL() external view returns (uint256);
    function unbondPeriod() external view returns (uint256);
    function transferGasLimit() external view returns (uint256);
    function stakeTokenB() external view returns (address);
    function legacyStakeTokenB() external view returns (address);
    function stakeTokenBPrimaryId() external view returns (uint256);
    function stakeTokenBSecondaryId() external view returns (uint256);
    function tokenBCutoverVersion() external view returns (uint256);
    function tokenBMigrationReserve() external view returns (uint256);
    function tokenBMigrationReserveById(uint256 tokenId) external view returns (uint256);
    function tokenBMigrationController() external view returns (address);
    function slashReserveVault() external view returns (address);
    function slashReserveAmountById(uint256 tokenId) external view returns (uint256);
    function slashReserveSelfMigrationCompleted() external view returns (bool);
    function expectedInflationMintAmount(uint256 dayIndex) external view returns (uint256);
    function inflationRecorderByDay(uint256 dayIndex) external view returns (address);
    function tokenBMigrationProposalId() external view returns (uint256);
    function pendingTokenBMigrationStakeTokenB() external view returns (address);
    function pendingTokenBMigrationReserveVault() external view returns (address);
    function pendingTokenBMigrationApprovalCount() external view returns (uint256);
    function pendingTokenBMigrationRequiredApprovals() external view returns (uint256);
    function totalDelegatedTokenB(address operatorAddress) external view returns (uint256);
    function totalLegacyDelegatedTokenB(address operatorAddress) external view returns (uint256);
    function getDelegatedTokenB(address operatorAddress, address delegator) external view returns (uint256);
    function getDelegatedTokenBById(address operatorAddress, address delegator, uint256 tokenId)
        external
        view
        returns (uint256);
    function getLegacyDelegatedTokenB(address operatorAddress, address delegator) external view returns (uint256);
    function getLegacyDelegatedTokenBById(address operatorAddress, address delegator, uint256 tokenId)
        external
        view
        returns (uint256);
    function activateTokenBMigration(address newStakeTokenB, address reserveVault) external;
    function hasApprovedTokenBMigration(uint256 proposalId, address operatorAddress) external view returns (bool);
    function depositTokenBMigrationReserve1155(uint256 tokenId, uint256 amount) external;
    function withdrawTokenBMigrationReserve1155(address recipient, uint256 tokenId, uint256 amount) external;
    function delegateTokenB1155(address operatorAddress, uint256 tokenId, uint256 tokenBAmount) external;
    function undelegateTokenB1155(address operatorAddress, uint256 tokenId, uint256 tokenBAmount) external;
    function tokenB1155UnbondRequest(address operatorAddress, address delegator, uint256 index)
        external
        view
        returns (uint256 tokenId, uint256 tokenBAmount, uint256 unlockTime);
    function migrateLegacyTokenB(address operatorAddress) external;
    function settleSlashReserve1155(address recipient, uint256 tokenId, uint256 amount) external;
    function migrateSelfCustodiedSlashReserve(uint256[] calldata tokenIds, uint256[] calldata amounts) external;
}
