// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IRewardVault {
    // Events
    event DelegateStaked(address indexed account, address indexed delegate, uint256 amount);
    event DelegateWithdrawn(address indexed account, address indexed delegate, uint256 amount);
    event Recovered(address token, uint256 amount);
    event OperatorSet(address account, address operator);
    event DistributorSet(address indexed distributor);
    event IncentiveManagerChanged(address indexed token, address newManager, address oldManager);
    event IncentiveTokenWhitelisted(address indexed token, uint256 minIncentiveRate, address manager);
    event IncentiveTokenRemoved(address indexed token);
    event MaxIncentiveTokensCountUpdated(uint8 maxIncentiveTokensCount);
    event IncentivesProcessed(bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount);
    event IncentivesProcessFailed(bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount);
    event IncentiveAdded(address indexed token, address sender, uint256 amount, uint256 incentiveRate);
    event BGTBoosterIncentivesProcessed(
        bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount
    );
    event BGTBoosterIncentivesProcessFailed(
        bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount
    );

    // Getters
    function distributor() external view returns (address);
    function operator(address account) external view returns (address);
    function getWhitelistedTokensCount() external view returns (uint256);
    function getWhitelistedTokens() external view returns (address[] memory);
    function getTotalDelegateStaked(address account) external view returns (uint256);
    function getDelegateStake(address account, address delegate) external view returns (uint256);
    function stakeToken() external view returns (address);
    function earned(address account) external view returns (uint256);

    // Admin
    function initialize(address _berachef, address _bgt, address _distributor, address _stakingToken) external;
    function setDistributor(address _rewardDistribution) external;
    function notifyRewardAmount(bytes calldata pubkey, uint256 reward) external;
    function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
    function setRewardsDuration(uint256 _rewardsDuration) external;
    function whitelistIncentiveToken(address token, uint256 minIncentiveRate, address manager) external;
    function removeIncentiveToken(address token) external;
    function setMaxIncentiveTokensCount(uint8 _maxIncentiveTokensCount) external;
    function pause() external;
    function unpause() external;

    // Mutative
    function exit(address recipient) external;
    function getReward(address account, address recipient) external returns (uint256);
    function stake(uint256 amount) external;
    function delegateStake(address account, uint256 amount) external;
    function withdraw(uint256 amount) external;
    function delegateWithdraw(address account, uint256 amount) external;
    function setOperator(address _operator) external;
    function updateIncentiveManager(address token, address newManager) external;
    function addIncentive(address token, uint256 amount, uint256 incentiveRate) external;
    function accountIncentives(address token, uint256 amount) external;
}
