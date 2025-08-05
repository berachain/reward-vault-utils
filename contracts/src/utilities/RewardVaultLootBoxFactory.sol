// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {RewardVaultLootBox} from "../examples/RewardVaultLootBox.sol";

contract RewardVaultLootBoxFactory {
    address public constant ENTROPY_CONTRACT = 0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320;
    address public constant DEFAULT_ENTROPY_PROVIDER = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;

    event RewardVaultLootBoxDeployed(address indexed lootBoxVault, address indexed deployer);

    function deployRewardVaultLootBox(
        address lootBoxContract,
        uint256[] memory rarityProbabilities,
        uint256[] memory rarityRewardBips
    ) external returns (address rewardVaultLootBox) {
        rewardVaultLootBox = address(new RewardVaultLootBox(
            ENTROPY_CONTRACT,
            lootBoxContract,
            DEFAULT_ENTROPY_PROVIDER,
            rarityProbabilities,
            rarityRewardBips
        ));

        emit RewardVaultLootBoxDeployed(rewardVaultLootBox, msg.sender);
    }
} 