// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@solmate/tokens/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract LootBox is ERC721, Ownable {
    address public controller;
    string public baseURI;
    uint256 public nextTokenId;

    // Rarity enum moved from RarityTypes library
    enum Rarity {
        COMMON,
        UNCOMMON,
        RARE,
        EPIC,
        LEGENDARY
    }

    struct LootBoxItem {
        Rarity rarity;
        uint256 rewardBips;
        address rewardToken;
        bool claimed;
    }

    mapping(uint256 => LootBoxItem) public lootBoxItems;

    modifier onlyController() {
        require(msg.sender == controller, "NC");
        _;
    }

    constructor(string memory _name, string memory _symbol, string memory _baseURI)
        ERC721(_name, _symbol)
        Ownable(msg.sender)
    {
        baseURI = _baseURI;
        controller = address(0);
    }

    function setController(address _controller) external onlyOwner {
        controller = _controller;
    }

    function mint(address to, LootBoxItem memory item) external onlyController returns (uint256 tokenId) {
        tokenId = nextTokenId++;
        _mint(to, tokenId);
        lootBoxItems[tokenId] = item;
    }

    function setClaimed(uint256 tokenId) external onlyController {
        lootBoxItems[tokenId].claimed = true;
    }

    function burn(uint256 tokenId) external onlyController {
        _burn(tokenId);
        delete lootBoxItems[tokenId];
    }

    function setBaseURI(string memory _baseURI) external onlyController {
        baseURI = _baseURI;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(ownerOf(id) != address(0), "NM");
        return string(abi.encodePacked(baseURI, _toString(id)));
    }

    function getLootBoxItem(uint256 tokenId) external view returns (LootBoxItem memory) {
        return lootBoxItems[tokenId];
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    // LootBoxLogic functions moved from library
    function generateRandomFactorFromEntropy(bytes32 entropy) internal pure returns (uint256) {
        uint256 entropyMiddle = uint256(entropy >> 64) & 0xFFFFFFFFFFFFFFFF;
        uint256 randomRange = 4000; // 12000 - 8000
        uint256 randomOffset = entropyMiddle % randomRange;
        return 8000 + randomOffset;
    }

    function determineRarityFromEntropy(bytes32 entropy, uint256[5] memory rarityProbabilities)
        external
        pure
        returns (Rarity)
    {
        uint256 rarityRoll = uint256(entropy) % 10000;
        uint256 cumulative = 0;
        cumulative += rarityProbabilities[uint256(Rarity.COMMON)];
        if (rarityRoll < cumulative) return Rarity.COMMON;
        cumulative += rarityProbabilities[uint256(Rarity.UNCOMMON)];
        if (rarityRoll < cumulative) return Rarity.UNCOMMON;
        cumulative += rarityProbabilities[uint256(Rarity.RARE)];
        if (rarityRoll < cumulative) return Rarity.RARE;
        cumulative += rarityProbabilities[uint256(Rarity.EPIC)];
        if (rarityRoll < cumulative) return Rarity.EPIC;
        return Rarity.LEGENDARY;
    }

    function calculateRewardBipsFromEntropy(uint256 baseRewardBips, bytes32 entropy) external pure returns (uint256) {
        uint256 randomFactor = generateRandomFactorFromEntropy(entropy);
        uint256 finalRewardBips = (baseRewardBips * randomFactor) / 10000;
        return finalRewardBips;
    }
}
