// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Owned} from "@solmate/auth/Owned.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {MerkleProofLib} from "@solmate/utils/MerkleProofLib.sol";
import {CompetitionManager} from "./CompetitionManager.sol";
import {IRewardVault} from "./interfaces/IRewardVault.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

/// @title CompetitionManagerMerkle
/// @notice Extends CompetitionManager with merkle-based reward distribution
/// @dev Uses merkle proofs to efficiently verify and distribute rewards
contract CompetitionManagerMerkle is CompetitionManager {
    using MerkleProofLib for bytes32[];
    using SafeTransferLib for address;

    /// @notice Represents a competition with its reward allocation
    struct Competition {
        uint256 rewardAmount;
    }

    /// @notice Represents a user's participation in competitions
    struct UserParticipation {
        bytes32[] merkleRoots;
        mapping(bytes32 => bool) hasClaimed;
    }

    /// @notice Maps merkle roots to their competition details
    mapping(bytes32 => Competition) public competitions;

    /// @notice Maps user addresses to their participation details
    mapping(address => UserParticipation) internal userParticipations;

    /// @notice Tracks the total amount of BGT allocated to competitions
    uint256 public totalAllocatedBGT;

    /// @notice Whether the contract has been initialized
    bool public initialized;

    /// @notice Emitted when a new competition is created
    /// @param merkleRoot The merkle root of the competition
    /// @param rewardAmount The amount of BGT allocated to the competition
    event CompetitionCreated(bytes32 indexed merkleRoot, uint256 rewardAmount);

    /// @notice Emitted when a user claims their reward
    /// @param merkleRoot The merkle root of the competition being claimed from
    /// @param user The address of the user claiming the reward
    /// @param amount The amount of BGT claimed
    event RewardClaimed(bytes32 indexed merkleRoot, address indexed user, uint256 amount);

    /// @notice Custom errors for better gas efficiency and error handling
    error AlreadyInitialized();
    error NotInitialized();
    error InvalidAmount();
    error InvalidMerkleProof();
    error AlreadyClaimed();
    error InsufficientBGT();
    error CompetitionExists();

    /// @notice Initializes the contract by registering the reward vault and staking a competition token
    /// @dev Can only be called once, after reward vault is deployed
    function initialize(address _rewardVault) external onlyOwner {
        if (initialized) revert AlreadyInitialized();
        if (_rewardVault == address(0)) revert NotInitialized();

        IRewardVault vault = IRewardVault(_rewardVault);
        if (vault.stakeToken() != address(competitionToken)) revert InvalidAmount();
        rewardVault = vault;

        // Mint one token and stake it permanently
        competitionToken.mint(address(this), 1 ether);
        competitionToken.approve(address(rewardVault), type(uint256).max);
        rewardVault.stake(1 ether);

        initialized = true;
    }

    /// @notice Creates a new competition with a merkle root and reward allocation
    /// @param merkleRoot The merkle root of the competition
    /// @param rewardAmount The amount of BGT to allocate to the competition
    /// @dev The reward amount must be available in earned rewards
    function createCompetition(bytes32 merkleRoot, uint256 rewardAmount) external onlyOwner {
        if (!initialized) revert NotInitialized();
        if (competitions[merkleRoot].rewardAmount != 0) revert CompetitionExists();
        if (rewardAmount == 0) revert InvalidAmount();

        uint256 availableBGT = rewardVault.earned(address(this)) - totalAllocatedBGT;
        if (rewardAmount > availableBGT) revert InsufficientBGT();

        competitions[merkleRoot] = Competition({
            rewardAmount: rewardAmount
        });

        totalAllocatedBGT += rewardAmount;
        emit CompetitionCreated(merkleRoot, rewardAmount);
    }

    /// @notice Allows a user to claim their reward using a merkle proof
    /// @param merkleRoot The merkle root of the competition to claim from
    /// @param amount The amount of BGT to claim
    /// @param proof The merkle proof verifying the claim
    /// @dev The merkle proof must be valid for the competition's root
    /// @dev The user must not have already claimed their reward
    function claimReward(bytes32 merkleRoot, uint256 amount, bytes32[] calldata proof) external {
        Competition storage competition = competitions[merkleRoot];
        if (competition.rewardAmount == 0) revert InvalidMerkleProof();
        if (userParticipations[msg.sender].hasClaimed[merkleRoot]) revert AlreadyClaimed();

        // Verify the merkle proof
        bytes32 leaf = keccak256(abi.encodePacked(merkleRoot, msg.sender, amount));
        if (!MerkleProofLib.verify(proof, merkleRoot, leaf)) revert InvalidMerkleProof();

        // Mark as claimed and add to user's participation
        userParticipations[msg.sender].hasClaimed[merkleRoot] = true;
        userParticipations[msg.sender].merkleRoots.push(merkleRoot);

        // Get reward from the reward vault directly to the claimer
        rewardVault.getReward(address(this), msg.sender);

        emit RewardClaimed(merkleRoot, msg.sender, amount);
    }

    /// @notice Returns all merkle roots a user has participated in
    /// @param user The address of the user to check
    /// @return Array of merkle roots the user has participated in
    function getUserCompetitions(address user) external view returns (bytes32[] memory) {
        return userParticipations[user].merkleRoots;
    }

    /// @notice Returns whether a user has claimed their reward for a specific competition
    /// @param user The address of the user to check
    /// @param merkleRoot The merkle root of the competition to check
    /// @return Whether the user has claimed their reward
    function hasUserClaimed(address user, bytes32 merkleRoot) external view returns (bool) {
        return userParticipations[user].hasClaimed[merkleRoot];
    }

    /// @notice Returns the total amount of BGT earned by this contract in the reward vault
    /// @return The total amount of BGT earned
    function getEarnedBGT() external view returns (uint256) {
        return rewardVault.earned(address(this));
    }

    /// @notice Returns the amount of BGT available for new competitions
    /// @return The amount of BGT that hasn't been allocated to any competition
    function getAvailableBGT() external view returns (uint256) {
        return rewardVault.earned(address(this)) - totalAllocatedBGT;
    }
} 