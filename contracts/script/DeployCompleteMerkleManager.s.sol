// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";
import {IRewardVaultFactory} from "../src/interfaces/IRewardVaultFactory.sol";

/// @notice Deploys a complete merkle manager setup using the existing factory
/// @dev This script demonstrates the multi-step process:
/// 1. Use MerkleManagerFactory to deploy the manager and token
/// 2. Create a reward vault using the reward vault factory
/// 3. Initialize the manager with the reward vault
/// 4. Set up liquid BGT minter integration
contract DeployCompleteMerkleManager is Script {
    // Berachain Bepolia testnet addresses
    address public constant MERKLE_MANAGER_FACTORY = 0x89a2e4bd1cfbf5D4C34C67606826922aB3e7D5Fd;
    address public constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;
    address public constant LIQUID_BGT_MINTER = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address public constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== Complete Merkle Manager Deployment ===");
        console.log("Using MerkleManagerFactory at:", MERKLE_MANAGER_FACTORY);
        console.log("Using RewardVaultFactory at:", REWARD_VAULT_FACTORY);

        // Step 1: Deploy merkle manager using the factory
        console.log("\n--- Step 1: Deploy Merkle Manager ---");
        MerkleManagerFactory factory = MerkleManagerFactory(MERKLE_MANAGER_FACTORY);

        (address manager, address rewardVaultToken) =
            factory.deployMerkleManager();

        console.log("Merkle Manager deployed at:", manager);
        console.log("Reward Vault Token deployed at:", rewardVaultToken);
        console.log("Using existing FBGT token at:", FBGT_TOKEN);
        console.log("Using existing Liquid BGT Minter at:", LIQUID_BGT_MINTER);

        // Step 2: Create reward vault using the reward vault factory
        console.log("\n--- Step 2: Create Reward Vault ---");
        IRewardVaultFactory rewardVaultFactory = IRewardVaultFactory(REWARD_VAULT_FACTORY);

        address rewardVault = rewardVaultFactory.createRewardVault(rewardVaultToken);
        console.log("Reward Vault created at:", rewardVault);

        // Step 3: Register the reward vault with the merkle manager
        console.log("\n--- Step 3: Register Reward Vault ---");
        RewardVaultManagerMerkle managerContract = RewardVaultManagerMerkle(manager);

        managerContract.registerRewardVault(rewardVault);
        console.log("Reward vault registered with merkle manager");

        // Step 4: Set up liquid BGT minter integration
        console.log("\n--- Step 4: Configure Liquid BGT Integration ---");
        managerContract.setLiquidBGTMinter(LIQUID_BGT_MINTER, FBGT_TOKEN);
        console.log("Liquid BGT minter configured");

        // Step 5: Verify the complete setup
        console.log("\n--- Step 5: Verification ---");
        console.log("Manager owner:", managerContract.owner());
        console.log("Manager reward vault:", address(managerContract.rewardVault()));
        console.log("Manager liquid BGT minter:", address(managerContract.liquidBGTMinter()));
        console.log("Manager liquid BGT token:", managerContract.liquidBGTToken());

        console.log("\n=== Deployment Complete ===");
        console.log("Complete merkle manager setup deployed successfully!");
        console.log("Manager Address:", manager);
        console.log("Reward Vault:", rewardVault);
        console.log("Reward Vault Token:", rewardVaultToken);

        vm.stopBroadcast();
    }
}
