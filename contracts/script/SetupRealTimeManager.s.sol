// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";

interface IRewardVaultFactory {
    function createRewardVault(address stakingToken) external returns (address);
}

interface IRewardVaultManagerRealTime {
    function registerRewardVault(address rewardVault) external;
    function setLiquidBGTMinter(address minter, address token) external;
    function setDistributorWhitelist(address distributor, bool isWhitelisted) external;
}

contract SetupRealTimeManager is Script {
    // Berachain Reward Vault Factory
    address public constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    // Our Real-Time Manager (from factory deployment)
    address public constant REAL_TIME_MANAGER = 0x1b42805C4276e9390383AcA1690efa4Db033a7e7;
    address public constant REWARD_VAULT_TOKEN = 0xB08E21bD25345e0495696b0fC9F229e8a8Ce71F0;

    // Liquid BGT Minter
    address public constant LIQUID_BGT_MINTER = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address public constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Setting up Real-Time Manager with Reward Vault...");

        // 1. Create a reward vault using the Berachain factory
        console.log("Creating reward vault...");
        IRewardVaultFactory factory = IRewardVaultFactory(REWARD_VAULT_FACTORY);
        address rewardVault = factory.createRewardVault(REWARD_VAULT_TOKEN);
        console.log("Reward vault created at:", rewardVault);

        // 2. Register the reward vault with our manager
        console.log("Registering reward vault with manager...");
        IRewardVaultManagerRealTime manager = IRewardVaultManagerRealTime(REAL_TIME_MANAGER);
        manager.registerRewardVault(rewardVault);

        // 3. Set up liquid BGT minter in our manager
        console.log("Setting up liquid BGT minter...");
        manager.setLiquidBGTMinter(LIQUID_BGT_MINTER, FBGT_TOKEN);

        // 4. Whitelist our address as a distributor
        console.log("Whitelisting deployer as distributor...");
        manager.setDistributorWhitelist(vm.addr(deployerPrivateKey), true);

        console.log("Setup complete!");
        console.log("Real-Time Manager:", REAL_TIME_MANAGER);
        console.log("Reward Vault:", rewardVault);
        console.log("Reward Vault Token:", REWARD_VAULT_TOKEN);

        vm.stopBroadcast();
    }
}
