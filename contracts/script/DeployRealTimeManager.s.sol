// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";

interface IRewardVaultManagerRealTimeFactory {
    function deployRealTimeManager() external returns (address manager, address rewardVaultToken);
}

contract DeployRealTimeManager is Script {
    // Our verified Real-Time Manager Factory
    address public constant REAL_TIME_MANAGER_FACTORY = 0x6807ee246ee005fb984DBfCd2Fc484e043459Bb2;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying new Real-Time Manager using factory...");

        IRewardVaultManagerRealTimeFactory factory = IRewardVaultManagerRealTimeFactory(REAL_TIME_MANAGER_FACTORY);
        (address manager, address rewardVaultToken) = factory.deployRealTimeManager();

        console.log("New Real-Time Manager deployed!");
        console.log("Manager address:", manager);
        console.log("Reward Vault Token:", rewardVaultToken);

        vm.stopBroadcast();
    }
}
