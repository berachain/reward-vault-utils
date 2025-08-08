// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";

interface IRewardVaultManagerRealTimeFactory {
    function deployRealTimeManager() external returns (address manager, address rewardVaultToken);
}

contract DeployFromFactory is Script {
    // Our newly deployed and verified Real-Time Manager Factory (FIXED VERSION)
    address public constant REAL_TIME_MANAGER_FACTORY = 0x9b0Fce5212c503697ddD267706ac4D852621115A;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("RV_UTILS_PK");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying new Real-Time Manager using FIXED factory...");

        IRewardVaultManagerRealTimeFactory factory = IRewardVaultManagerRealTimeFactory(REAL_TIME_MANAGER_FACTORY);
        (address manager, address rewardVaultToken) = factory.deployRealTimeManager();

        console.log("New Real-Time Manager deployed!");
        console.log("Manager address:", manager);
        console.log("Reward Vault Token:", rewardVaultToken);

        vm.stopBroadcast();
    }
}
