// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";

/// @notice Deploys the MerkleManagerFactory contract
/// @dev The factory is configured with a hardcoded reward vault factory address
contract DeployMerkleManagerFactory is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("RV_UTILS_PK");
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== MerkleManagerFactory Deployment ===");
        console.log("Using RV_UTILS_PK for deployment");

        // Deploy the MerkleManagerFactory
        // Note: The factory constructor no longer takes parameters as the reward vault factory is hardcoded
        MerkleManagerFactory factory = new MerkleManagerFactory();

        console.log("MerkleManagerFactory deployed at:", address(factory));
        console.log("Reward Vault Factory (hardcoded):", factory.rewardVaultFactory());
        console.log("Factory owner:", factory.owner());

        console.log("\n=== Deployment Complete ===");
        console.log("MerkleManagerFactory deployed successfully!");
        console.log("Factory Address:", address(factory));

        vm.stopBroadcast();
    }
}
