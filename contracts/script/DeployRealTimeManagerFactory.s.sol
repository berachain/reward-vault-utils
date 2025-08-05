// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultManagerRealTimeFactory} from "../src/utilities/RewardVaultManagerRealTimeFactory.sol";

contract DeployRealTimeManagerFactory is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the factory
        RewardVaultManagerRealTimeFactory factory = new RewardVaultManagerRealTimeFactory();
        console.log("RewardVaultManagerRealTimeFactory deployed at:", address(factory));

        // Test deployment of a real-time manager
        (address manager, address rewardVaultToken) = factory.deployRealTimeManager();
        console.log("Test RealTimeManager deployment:");
        console.log("  Manager:", manager);
        console.log("  RewardVaultToken:", rewardVaultToken);

        vm.stopBroadcast();
    }
} 