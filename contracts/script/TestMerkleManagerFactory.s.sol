// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";

contract TestMerkleManagerFactory is Script {
    address private constant MERKLE_MANAGER_FACTORY = 0x0000000000000000000000000000000000000000; // Replace with actual address

    function run() external {
        // Use the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Get the factory instance
        MerkleManagerFactory factory = MerkleManagerFactory(MERKLE_MANAGER_FACTORY);
        
        console.log("Using MerkleManagerFactory at:", MERKLE_MANAGER_FACTORY);

        // Deploy a complete merkle manager setup
        (
            address manager,
            address rewardVault,
            address fbgt,
            address liquidBGTMinter,
            address rewardVaultToken
        ) = factory.deployMerkleManager();

        console.log("Deployment complete!");
        console.log("RewardVaultManagerMerkle:", manager);
        console.log("RewardVault:", rewardVault);
        console.log("FBGT:", fbgt);
        console.log("LiquidBGTMinter:", liquidBGTMinter);
        console.log("RewardVaultToken:", rewardVaultToken);

        vm.stopBroadcast();
    }
} 