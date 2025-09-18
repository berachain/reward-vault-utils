// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Owned} from "@solmate/auth/Owned.sol";
import {RewardVaultManagerMerkle} from "../examples/RewardVaultManagerMerkle.sol";
import {RewardVaultToken} from "../examples/RewardVaultToken.sol";
import {IRewardVaultFactory} from "../interfaces/IRewardVaultFactory.sol";
import {IRewardVault} from "../interfaces/IRewardVault.sol";

/// @title MerkleManagerFactory
/// @notice A factory contract for deploying complete merkle reward vault manager setups
/// @dev Automates the deployment of RewardVaultManagerMerkle and RewardVault setup
contract MerkleManagerFactory is Owned {
    // ============ Events ============

    /// @notice Emitted when a new merkle manager setup is deployed
    /// @param manager The address of the deployed RewardVaultManagerMerkle
    /// @param rewardVaultToken The address of the RewardVaultToken
    /// @param deployer The address that deployed the setup
    event MerkleManagerDeployed(address indexed manager, address rewardVaultToken, address deployer);

    // ============ Errors ============

    /// @notice Error thrown when reward vault creation fails
    error RewardVaultCreationFailed();
    /// @notice Error thrown when initialization fails
    error InitializationFailed();

    // ============ State Variables ============

    /// @notice The reward vault factory address
    address public immutable rewardVaultFactory = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    // ============ Constructor ============

    /// @notice Creates a new MerkleManagerFactory
    /// @dev The deployer becomes the owner
    constructor() Owned(msg.sender) {}

    // ============ External Functions ============

    /// @notice Deploys a complete merkle manager setup
    /// @return manager The address of the deployed RewardVaultManagerMerkle
    /// @return rewardVaultToken The address of the RewardVaultToken
    function deployMerkleManager() external returns (address manager, address rewardVaultToken) {
        // 1. Deploy RewardVaultManagerMerkle
        RewardVaultManagerMerkle managerContract = new RewardVaultManagerMerkle();
        manager = address(managerContract);

        // 2. Get the RewardVaultToken from the manager
        rewardVaultToken = address(managerContract.rewardVaultToken());

        // 3. Transfer ownership of the manager to the deployer
        managerContract.transferOwnership(msg.sender);

        emit MerkleManagerDeployed(manager, rewardVaultToken, msg.sender);
    }
}
