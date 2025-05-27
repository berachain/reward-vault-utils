// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {CompetitionManagerMerkle} from "../src/CompetitionManagerMerkle.sol";
import {IRewardVaultFactory} from "../src/interfaces/IRewardVaultFactory.sol";
import {Button} from "../src/Button.sol";

contract DeployCompetitionManagerMerkle is Script {
    // Bepolia RewardVaultFactory address
    address constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    function run() external {
        // Use the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy CompetitionManagerMerkle
        CompetitionManagerMerkle manager = new CompetitionManagerMerkle();
        address competitionToken = address(manager.competitionToken());

        // 2. Deploy RewardVault using the factory (add any required params)
        // NOTE: You must update this call to match the actual factory ABI and params
        address rewardVault = IRewardVaultFactory(REWARD_VAULT_FACTORY).createRewardVault(competitionToken);

        // 3. Initialize the manager with the reward vault
        manager.initialize(rewardVault);

        // 4. Log addresses
        console2.log("CompetitionManagerMerkle:", address(manager));
        console2.log("CompetitionToken:", competitionToken);
        console2.log("RewardVault:", rewardVault);

        // 5. Deploy Button and log its address
        Button button = new Button();
        console2.log("Button:", address(button));

        vm.stopBroadcast();
    }
} 