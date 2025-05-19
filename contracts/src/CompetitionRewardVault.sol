// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Owned} from "@solmate/auth/Owned.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {MerkleProofLib} from "@solady/utils/MerkleProofLib.sol";
import {IRewardVault} from "@berachain/contracts/src/rewards/IRewardVault.sol";

/// @title CompetitionRewardVault
/// @notice This contract manages reward distributions for competitions using merkle proofs for efficient verification
/// @dev The contract uses a merkle tree to verify reward claims, which allows for gas-efficient verification of large reward distributions
/// @dev Each distribution has a unique ID and merkle root, allowing for multiple concurrent distributions
/// @dev The contract integrates with Berachain's RewardVault for staking and reward management
contract CompetitionRewardVault is Owned {
  using SafeTransferLib for address;
  using MerkleProofLib for bytes32[];

  /// @notice The RewardVault contract from Berachain that handles staking and rewards
  /// @dev This is the main contract we interact with for staking and reward management
  IRewardVault public immutable rewardVault;

  /// @notice The BGT token used for rewards
  /// @dev This is the token that will be distributed as rewards
  address public immutable bgtToken;

  /// @notice The competition token used for staking
  /// @dev This is the token that participants stake to earn rewards
  address public immutable competitionToken;

  /// @notice Tracks the total amount of BGT allocated across all distributions
  /// @dev This helps ensure we don't over-allocate rewards
  uint256 public totalAllocatedBGT;

  /// @notice Maps distribution IDs to their merkle roots
  /// @dev The merkle root is used to verify reward claims
  mapping(uint256 => bytes32) public merkleRoots;

  /// @notice Maps distribution IDs to their total reward amounts
  /// @dev This helps track how much BGT is allocated to each distribution
  mapping(uint256 => uint256) public distributionAmounts;

  /// @notice Maps user addresses to their claimed rewards for each distribution
  /// @dev This prevents double-claiming of rewards
  mapping(uint256 => mapping(address => bool)) public hasClaimed;

  /// @notice Emitted when a new distribution is created
  /// @param distributionId The unique identifier for the distribution
  /// @param merkleRoot The merkle root of the distribution
  /// @param amount The total amount of BGT allocated to the distribution
  event DistributionCreated(uint256 indexed distributionId, bytes32 merkleRoot, uint256 amount);

  /// @notice Emitted when a user claims their reward
  /// @param distributionId The ID of the distribution being claimed from
  /// @param user The address of the user claiming the reward
  /// @param amount The amount of BGT claimed
  event RewardClaimed(uint256 indexed distributionId, address indexed user, uint256 amount);

  /// @notice Custom errors for better gas efficiency and error handling
  error InvalidAmount();
  error InvalidMerkleProof();
  error AlreadyClaimed();
  error InsufficientBGT();
  error InvalidDistributionId();
  error NotRewardVaultOwner();

  /// @notice Creates a new CompetitionRewardVault
  /// @param _rewardVault The address of the Berachain RewardVault contract
  /// @param _bgtToken The address of the BGT token
  /// @dev The contract verifies that it owns the competition token in the reward vault
  constructor(address _rewardVault, address _bgtToken) Owned(msg.sender) {
    rewardVault = IRewardVault(_rewardVault);
    bgtToken = _bgtToken;
    competitionToken = rewardVault.stakingToken();

    // Verify that the reward vault's staking token is owned by this contract
    if (Owned(competitionToken).owner() != address(this)) {
      revert NotRewardVaultOwner();
    }
  }

  /// @notice Creates a new reward distribution
  /// @param distributionId A unique identifier for the distribution
  /// @param merkleRoot The merkle root of the distribution
  /// @param amount The total amount of BGT to allocate to the distribution
  /// @dev The merkle root should be generated off-chain using the distribution data
  /// @dev The amount must be available in the contract
  function createDistribution(uint256 distributionId, bytes32 merkleRoot, uint256 amount) external onlyOwner {
    if (amount == 0) revert InvalidAmount();
    if (merkleRoots[distributionId] != bytes32(0)) revert InvalidDistributionId();

    // Transfer BGT from owner to contract
    SafeTransferLib.safeTransferFrom(bgtToken, msg.sender, address(this), amount);

    merkleRoots[distributionId] = merkleRoot;
    distributionAmounts[distributionId] = amount;
    totalAllocatedBGT += amount;

    emit DistributionCreated(distributionId, merkleRoot, amount);
  }

  /// @notice Allows a user to claim their reward using a merkle proof
  /// @param distributionId The ID of the distribution to claim from
  /// @param amount The amount of BGT to claim
  /// @param proof The merkle proof verifying the claim
  /// @dev The merkle proof must be valid for the distribution's root
  /// @dev The user must not have already claimed their reward
  function claimReward(uint256 distributionId, uint256 amount, bytes32[] calldata proof) external {
    if (hasClaimed[distributionId][msg.sender]) revert AlreadyClaimed();

    bytes32 merkleRoot = merkleRoots[distributionId];
    if (merkleRoot == bytes32(0)) revert InvalidDistributionId();

    // Verify the merkle proof
    // The leaf is keccak256(abi.encodePacked(distributionId, msg.sender, amount))
    // This ensures the proof is specific to this distribution and user
    bytes32 leaf = keccak256(abi.encodePacked(distributionId, msg.sender, amount));
    if (!proof.verify(merkleRoot, leaf)) revert InvalidMerkleProof();

    hasClaimed[distributionId][msg.sender] = true;

    // Get reward from the reward vault directly to the claimer
    // Pass this contract as the account and msg.sender as the recipient
    rewardVault.getReward(address(this), msg.sender);

    emit RewardClaimed(distributionId, msg.sender, amount);
  }

  /// @notice Returns the total amount of BGT earned by this contract in the reward vault
  /// @return The total amount of BGT earned
  function getEarnedBGT() external view returns (uint256) {
    return rewardVault.earned(address(this));
  }

  /// @notice Returns the amount of BGT available for new distributions
  /// @return The amount of BGT that hasn't been allocated to any distribution
  function getAvailableBGT() external view returns (uint256) {
    return rewardVault.earned(address(this)) - totalAllocatedBGT;
  }

  /// @notice Returns information about a distribution
  /// @param distributionId The ID of the distribution to check
  /// @return merkleRoot The merkle root of the distribution
  /// @return amount The total amount of BGT allocated to the distribution
  /// @return isActive Whether the distribution is active (has a merkle root)
  /// @dev This is a view function that doesn't modify state
  function getDistributionInfo(
    uint256 distributionId
  ) external view returns (bytes32 merkleRoot, uint256 amount, bool isActive) {
    merkleRoot = merkleRoots[distributionId];
    amount = distributionAmounts[distributionId];
    isActive = merkleRoot != bytes32(0);
  }
} 