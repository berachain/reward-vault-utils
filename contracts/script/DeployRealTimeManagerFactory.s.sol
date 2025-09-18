// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultManagerRealTimeFactory} from "../src/utilities/RewardVaultManagerRealTimeFactory.sol";

contract DeployRealTimeManagerFactory is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("RV_UTILS_PK");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying Real-Time Manager Factory...");

        RewardVaultManagerRealTimeFactory factory = new RewardVaultManagerRealTimeFactory();

        console.log("Real-Time Manager Factory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}
