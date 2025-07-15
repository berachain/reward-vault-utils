// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {RewardVaultEntropy} from "../core/RewardVaultEntropy.sol";
import {ERC721} from "@solmate/tokens/ERC721.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {LootBoxLogic} from "../libraries/LootBoxLogic.sol";
import {RarityTypes} from "../libraries/RarityTypes.sol";
import {LootBox} from "./LootBox.sol";

/// @title RewardVaultLootBox
/// @notice A loot box system that uses Pyth Entropy for random rewards and mints ERC-721 tokens
/// @dev Extends RewardVaultEntropy and implements ERC-721 for loot box NFTs
contract RewardVaultLootBox is RewardVaultEntropy {
    /// @notice Loot box rarity levels
    enum Rarity {
        COMMON,
        UNCOMMON,
        RARE,
        EPIC,
        LEGENDARY
    }

    /// @notice Loot box item structure
    struct LootBoxItem {
        RarityTypes.Rarity rarity;
        uint256 rewardBips; // Reward amount in basis points
        address rewardToken;
        bool claimed;
    }

    /// @notice Maps token IDs to loot box items
    mapping(uint256 => LootBoxItem) public lootBoxItems;

    /// @notice Maps sequence numbers to pending loot box opens
    mapping(uint64 => PendingLootBox) public pendingLootBoxes;

    /// @notice Current token ID counter
    uint256 public nextTokenId;

    /// @notice Base URI for token metadata
    string public baseURI;

    /// @notice Rarity probabilities (in basis points, 10000 = 100%)
    mapping(RarityTypes.Rarity => uint256) public rarityProbabilities;

    /// @notice Reward amounts in basis points (bips) for each rarity
    mapping(RarityTypes.Rarity => uint256) public rarityRewardBips;

    /// @notice Struct for pending loot box opens
    struct PendingLootBox {
        address opener;
        bool processed;
    }

    /// @notice Emitted when a loot box opening is initiated
    /// @param opener The address that initiated the loot box opening
    /// @param sequenceNumber The entropy sequence number
    event LootBoxOpeningInitiated(address indexed opener, uint64 indexed sequenceNumber);

    /// @notice Emitted when a loot box is opened and NFT is minted
    /// @param tokenId The token ID of the loot box
    /// @param opener The address that opened the loot box
    /// @param sequenceNumber The entropy sequence number
    /// @param rarity The rarity of the loot box
    /// @param rewardBips The reward amount in basis points
    event LootBoxOpened(
        uint256 indexed tokenId,
        address indexed opener,
        uint64 indexed sequenceNumber,
        RarityTypes.Rarity rarity,
        uint256 rewardBips
    );

    /// @notice Emitted when a loot box item is claimed
    /// @param tokenId The token ID of the loot box
    /// @param owner The owner of the loot box
    /// @param rewardAmount The amount of rewards claimed
    /// @param rewardToken The token address of the rewards
    event LootBoxClaimed(uint256 indexed tokenId, address indexed owner, uint256 rewardAmount, address rewardToken);

    /// @notice Mapping of approved addresses for loot box creation
    mapping(address => bool) public isApprovedCreator;

    /// @notice Modifier to restrict to approved creators
    modifier onlyApprovedCreator() {
        require(isApprovedCreator[msg.sender], "NA");
        _;
    }

    /// @notice Set approval for a creator address (true = approve, false = revoke)
    /// @param creator The address to approve or revoke
    /// @param approved Whether the address is approved
    function setCreatorApproval(address creator, bool approved) external onlyOwner {
        isApprovedCreator[creator] = approved;
    }

    LootBox public immutable lootBoxContract;

    /// @notice Creates a new RewardVaultLootBox
    /// @param _entropyContract The address of the Pyth Entropy contract
    /// @param _lootBoxContract The address of the LootBox contract
    /// @param _rarityProbabilities Array of probabilities (basis points) for each rarity
    /// @param _rarityRewardBips Array of reward bips for each rarity
    constructor(
        address _entropyContract,
        address _lootBoxContract,
        uint256[] memory _rarityProbabilities,
        uint256[] memory _rarityRewardBips
    ) RewardVaultEntropy(_entropyContract) {
        lootBoxContract = LootBox(_lootBoxContract);
        require(_rarityProbabilities.length == 5, "PL");
        require(_rarityRewardBips.length == 5, "RL");
        uint256 totalProbability = 0;
        for (uint256 i = 0; i < 5; i++) {
            rarityProbabilities[RarityTypes.Rarity(i)] = _rarityProbabilities[i];
            rarityRewardBips[RarityTypes.Rarity(i)] = _rarityRewardBips[i];
            totalProbability += _rarityProbabilities[i];
        }
        require(totalProbability == 10000, "PS");
    }

    /// @notice Create a loot box using entropy (was openLootBox)
    /// @param provider The entropy provider address
    /// @param userRandomNumber A secret random number generated by the user
    /// @return sequenceNumber The sequence number for the entropy request
    function createLootBox(address provider, bytes32 userRandomNumber) external payable onlyApprovedCreator returns (uint64 sequenceNumber) {
        // Get the required fee from the entropy contract
        uint256 requiredFee = entropyContract.getFee(provider);
        require(msg.value >= requiredFee, "IF"); // Insufficient Fee
        
        // Request entropy with callback data containing the opener's address
        bytes memory callbackData = abi.encode(msg.sender);
        // trusted: Pyth Entropy contract
        sequenceNumber = this.requestEntropyWithCallback{value: requiredFee}(provider, userRandomNumber, callbackData);

        // Store pending loot box information
        pendingLootBoxes[sequenceNumber] =
            PendingLootBox({opener: msg.sender, processed: false});

        emit LootBoxOpeningInitiated(msg.sender, sequenceNumber);
    }

    /// @notice Process entropy callback and mint loot box NFT
    /// @param sequence The sequence number for the entropy request
    /// @param randomNumber The random number from Pyth Entropy
    /// @param callback The callback data associated with the request
    function _processEntropy(
        uint64 sequence,
        address,
        bytes32 randomNumber,
        EntropyCallbackData memory callback
    ) internal virtual override {
        address opener = abi.decode(callback.data, (address));
        PendingLootBox storage pending = pendingLootBoxes[sequence];
        if (pending.opener != opener) revert IO();
        if (pending.processed) revert AP();
        pending.processed = true;
        uint256[5] memory rarityProbs;
        for (uint256 i = 0; i < 5; i++) {
            rarityProbs[i] = rarityProbabilities[RarityTypes.Rarity(i)];
        }
        RarityTypes.Rarity rarity = LootBoxLogic.determineRarityFromEntropy(randomNumber, rarityProbs);
        uint256 rewardBips = LootBoxLogic.calculateRewardBipsFromEntropy(rarityRewardBips[rarity], randomNumber);
        LootBox.LootBoxItem memory item = LootBox.LootBoxItem({
            rarity: rarity,
            rewardBips: rewardBips,
            rewardToken: liquidBGTToken,
            claimed: false
        });
        uint256 tokenId = lootBoxContract.mint(opener, item);
        emit LootBoxOpened(tokenId, opener, sequence, rarity, rewardBips);
    }

    /// @notice Open rewards from a loot box (was claimLootBox)
    /// @param tokenId The token ID of the loot box
    function openLootBox(uint256 tokenId) external {
        LootBox.LootBoxItem memory item = lootBoxContract.getLootBoxItem(tokenId);
        if (item.rarity == RarityTypes.Rarity.COMMON && item.rewardBips == 0 && item.rewardToken == address(0) && !item.claimed) revert NM();
        if (item.claimed) revert AC();
        if (lootBoxContract.ownerOf(tokenId) != msg.sender) revert NO();
        lootBoxContract.setClaimed(tokenId);
        if (item.rewardBips > 0 && item.rewardToken != address(0)) {
            ERC20(item.rewardToken).transfer(msg.sender, _calculateRewardAmount(item.rarity, item.rewardBips));
        }
        emit LootBoxClaimed(tokenId, msg.sender, _calculateRewardAmount(item.rarity, item.rewardBips), item.rewardToken);
    }

    /// @notice Set rarity probabilities
    /// @param rarities Array of rarity levels
    /// @param probabilities Array of probabilities in basis points
    function setRarityProbabilities(RarityTypes.Rarity[] calldata rarities, uint256[] calldata probabilities) external onlyOwner {
        if (rarities.length != probabilities.length) revert IP(); // Invalid Probabilities

        uint256 totalProbability = 0;
        for (uint256 i = 0; i < rarities.length; i++) {
            rarityProbabilities[rarities[i]] = probabilities[i];
            totalProbability += probabilities[i];
        }

        if (totalProbability != 10000) revert IP();
    }

    /// @notice Set rarity reward bips
    /// @param rarities Array of rarity levels
    /// @param bips Array of reward bips
    function setRarityRewardBips(RarityTypes.Rarity[] calldata rarities, uint256[] calldata bips) external onlyOwner {
        if (rarities.length != bips.length) revert IR(); // Invalid Reward Bips

        for (uint256 i = 0; i < rarities.length; i++) {
            rarityRewardBips[rarities[i]] = bips[i];
        }
    }

    /// @notice Set base URI for token metadata
    /// @param _baseURI The new base URI
    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    /// @notice Set the liquid BGT token for loot box rewards
    /// @param _liquidBGTToken The address of the liquid BGT token
    /// @dev This function allows setting the liquid BGT token without requiring a reward vault
    function setLiquidBGTToken(address _liquidBGTToken) external onlyOwner {
        if (_liquidBGTToken == address(0)) revert InvalidLiquidBGTToken();
        liquidBGTToken = _liquidBGTToken;
        emit LiquidBGTMinterSet(address(0), _liquidBGTToken);
    }

    /// @notice Calculate the actual reward amount at claim time based on current contract balance
    /// @param rarity The rarity of the loot box (unused but kept for interface consistency)
    /// @param rewardBips The reward bips for the loot box
    /// @return The calculated reward amount in tokens
    function _calculateRewardAmount(RarityTypes.Rarity rarity, uint256 rewardBips) internal view returns (uint256) {
        // Use rarity to silence linter warning
        rarity;
        // Get the available liquid BGT balance in this contract
        uint256 availableBalance = 0;
        if (liquidBGTToken != address(0)) {
            // trusted: ERC20 token contract
            availableBalance = ERC20(liquidBGTToken).balanceOf(address(this));
        }

        if (availableBalance == 0) return 0;

        // Calculate reward based on reward bips of available balance
        uint256 rewardAmount = (availableBalance * rewardBips) / 10000;

        return rewardAmount;
    }

    /// @notice Get the current fee required for entropy requests
    /// @param provider The entropy provider address
    /// @return The fee amount in wei
    function getFee(address provider) external view returns (uint256) {
        return entropyContract.getFee(provider);
    }

    // Add concise custom errors
    error NM(); // Not Minted
    error AC(); // Already Claimed
    error NO(); // Not Owner
    error IO(); // Invalid Opener
    error AP(); // Already Processed
    error IP(); // Invalid Probabilities
    error IR(); // Invalid Reward Bips
    error IF(); // Insufficient Fee
}
