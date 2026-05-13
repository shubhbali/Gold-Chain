pragma solidity 0.6.4;

interface IStakeHub {
    function downtimeSlash(address validator) external;
    function maliciousVoteSlash(bytes calldata voteAddress) external;
    function doubleSignSlash(address validator) external;
    function BREATHE_BLOCK_INTERVAL() external view returns (uint256);
    function voteToOperator(bytes calldata voteAddress) external view returns (address);
    function consensusToOperator(address validator) external view returns (address);
    function getValidatorConsensusAddress(address validator) external view returns (address);
    function getValidatorCreditContract(address validator) external view returns (address);
    function getValidatorVoteAddress(address validator) external view returns (bytes memory);
    function expectedInflationMintAmount(uint256 dayIndex) external view returns (uint256);
    function maxElectedValidators() external view returns (uint256);
    function distributeReward(address validator) external payable;
    function recordInflationMint(address consensusAddress) external payable;
}
