// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {RewardVaultManagerRealTime} from "../examples/RewardVaultManagerRealTime.sol";

/// @title RewardVaultManagerRealTimeFactory
/// @notice Factory contract for deploying RewardVaultManagerRealTime instances
contract RewardVaultManagerRealTimeFactory {
    /// @notice Emitted when a real-time manager is deployed
    /// @param manager The address of the deployed manager
    /// @param deployer The address that deployed the manager
    event RealTimeManagerDeployed(address indexed manager, address indexed deployer);

    /// @notice Deploys a new RewardVaultManagerRealTime instance
    /// @return manager The address of the deployed manager
    /// @return rewardVaultToken The address of the reward vault token
    function deployRealTimeManager() external returns (address manager, address rewardVaultToken) {
        RewardVaultManagerRealTime managerContract = new RewardVaultManagerRealTime();
        manager = address(managerContract);
        rewardVaultToken = address(managerContract.rewardVaultToken());
        
        // Transfer ownership to the deployer
        managerContract.transferOwnership(msg.sender);
        
        emit RealTimeManagerDeployed(manager, msg.sender);
    }
} 