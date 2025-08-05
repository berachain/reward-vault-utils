// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// This script sends 10 FBGT tokens to the RewardVaultLootBox contract for reward funding.

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";

contract SendFBGTToVault is Script {
    address public constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
    address public constant REWARD_VAULT_LOOTBOX = 0x8f0E419112911F647917C1fa24842dA7D9e28FAD;
    uint256 public constant AMOUNT = 10 ether;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ERC20(FBGT_TOKEN).transfer(REWARD_VAULT_LOOTBOX, AMOUNT);

        vm.stopBroadcast();
    }
}
