// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {RarityTypes} from "./RarityTypes.sol";

library LootBoxLogic {
    function determineRarityFromEntropy(bytes32 entropy, uint256[5] memory rarityProbabilities) internal pure returns (RarityTypes.Rarity) {
        uint256 rarityRoll = uint256(entropy) % 10000;
        uint256 cumulative = 0;
        cumulative += rarityProbabilities[uint256(RarityTypes.Rarity.COMMON)];
        if (rarityRoll < cumulative) return RarityTypes.Rarity.COMMON;
        cumulative += rarityProbabilities[uint256(RarityTypes.Rarity.UNCOMMON)];
        if (rarityRoll < cumulative) return RarityTypes.Rarity.UNCOMMON;
        cumulative += rarityProbabilities[uint256(RarityTypes.Rarity.RARE)];
        if (rarityRoll < cumulative) return RarityTypes.Rarity.RARE;
        cumulative += rarityProbabilities[uint256(RarityTypes.Rarity.EPIC)];
        if (rarityRoll < cumulative) return RarityTypes.Rarity.EPIC;
        return RarityTypes.Rarity.LEGENDARY;
    }

    function calculateRewardBipsFromEntropy(uint256 baseRewardBips, bytes32 entropy) internal pure returns (uint256) {
        uint256 randomFactor = generateRandomFactorFromEntropy(entropy);
        uint256 finalRewardBips = (baseRewardBips * randomFactor) / 10000;
        return finalRewardBips;
    }

    function generateRandomFactorFromEntropy(bytes32 entropy) internal pure returns (uint256) {
        uint256 entropyMiddle = uint256(entropy >> 64) & 0xFFFFFFFFFFFFFFFF;
        uint256 randomRange = 4000; // 12000 - 8000
        uint256 randomOffset = entropyMiddle % randomRange;
        return 8000 + randomOffset;
    }
} 