// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Owned} from "@solmate/auth/Owned.sol";
import {RewardVaultManagerMerkle} from "../examples/RewardVaultManagerMerkle.sol";
import {RewardVaultToken} from "../examples/RewardVaultToken.sol";
import {IRewardVaultFactory} from "../interfaces/IRewardVaultFactory.sol";
import {IRewardVault} from "../interfaces/IRewardVault.sol";

/// @title MerkleManagerFactory
/// @notice A factory contract for deploying complete merkle reward vault manager setups
/// @dev Automates the deployment of RewardVaultManagerMerkle, FBGT, LiquidBGTMinter, and RewardVault setup
contract MerkleManagerFactory is Owned {
    // ============ Events ============

    /// @notice Emitted when a new merkle manager setup is deployed
    /// @param manager The address of the deployed RewardVaultManagerMerkle
    /// @param fbgt The address of the existing FBGT token
    /// @param liquidBGTMinter The address of the existing LiquidBGTMinter
    /// @param rewardVaultToken The address of the RewardVaultToken
    /// @param deployer The address that deployed the setup
    event MerkleManagerDeployed(
        address indexed manager,
        address indexed fbgt,
        address liquidBGTMinter,
        address rewardVaultToken,
        address deployer
    );

    // ============ Errors ============

    /// @notice Error thrown when trying to deploy with zero reward vault factory address
    error ZeroRewardVaultFactory();
    /// @notice Error thrown when reward vault creation fails
    error RewardVaultCreationFailed();
    /// @notice Error thrown when initialization fails
    error InitializationFailed();

    // ============ State Variables ============

    /// @notice The reward vault factory address
    address public immutable rewardVaultFactory;

    // ============ Constructor ============

    /// @notice Creates a new MerkleManagerFactory
    /// @param _rewardVaultFactory The address of the reward vault factory
    /// @dev The deployer becomes the owner
    constructor(address _rewardVaultFactory) Owned(msg.sender) {
        if (_rewardVaultFactory == address(0)) revert ZeroRewardVaultFactory();
        rewardVaultFactory = _rewardVaultFactory;
    }

    // ============ External Functions ============

    /// @notice Deploys a complete merkle manager setup
    /// @return manager The address of the deployed RewardVaultManagerMerkle
    /// @return rewardVaultToken The address of the RewardVaultToken
    /// @return fbgt The address of the existing FBGT token
    /// @return liquidBGTMinter The address of the existing LiquidBGTMinter
    function deployMerkleManager()
        external
        returns (address manager, address rewardVaultToken, address fbgt, address liquidBGTMinter)
    {
        // 1. Deploy RewardVaultManagerMerkle
        RewardVaultManagerMerkle managerContract = new RewardVaultManagerMerkle();
        manager = address(managerContract);

        // 2. Get the RewardVaultToken from the manager
        rewardVaultToken = address(managerContract.rewardVaultToken());

        // 3. Use existing FBGT and LiquidBGTMinter addresses
        fbgt = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
        liquidBGTMinter = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;

        // 4. Transfer ownership of the manager to the deployer
        managerContract.transferOwnership(msg.sender);

        emit MerkleManagerDeployed(manager, fbgt, liquidBGTMinter, rewardVaultToken, msg.sender);
    }
}
