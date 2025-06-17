// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";
import {RewardVaultToken} from "../src/examples/RewardVaultToken.sol";
import {IRewardVaultFactory} from "../src/interfaces/IRewardVaultFactory.sol";
import {Button} from "../src/examples/Button.sol";
import {FBGT} from "../src/examples/FBGT.sol";
import {LiquidBGTMinter} from "../src/examples/LiquidBGTMinter.sol";

contract DeployRewardVaultManagerMerkle is Script {
    // Bepolia RewardVaultFactory address
    address constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    function run() external {
        // Use the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy RewardVaultManagerMerkle
        RewardVaultManagerMerkle manager = new RewardVaultManagerMerkle();
        address rewardVaultToken = address(manager.rewardVaultToken());

        // 2. Deploy RewardVault using the factory (add any required params)
        // NOTE: You must update this call to match the actual factory ABI and params
        address rewardVault = IRewardVaultFactory(REWARD_VAULT_FACTORY).createRewardVault(rewardVaultToken);

        // 3. Initialize the manager with the reward vault
        manager.initialize(rewardVault);

        // 4. Deploy FBGT token
        FBGT fbgt = new FBGT();
        console.log("FBGT:", address(fbgt));

        // 5. Deploy LiquidBGTMinter
        LiquidBGTMinter minter = new LiquidBGTMinter(address(fbgt));
        console.log("LiquidBGTMinter:", address(minter));

        // 6. Transfer FBGT ownership to the minter
        fbgt.transferOwnership(address(minter));
        console.log("Transferred FBGT ownership to minter");

        // 7. Log addresses
        console.log("RewardVaultManagerMerkle:", address(manager));
        console.log("RewardVaultToken:", rewardVaultToken);
        console.log("RewardVault:", rewardVault);

        // 8. Deploy Button and log its address
        Button button = new Button();
        console.log("Button:", address(button));

        vm.stopBroadcast();
    }
}
