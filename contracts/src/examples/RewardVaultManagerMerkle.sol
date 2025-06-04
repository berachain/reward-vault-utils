// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Owned} from "@solmate/auth/Owned.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {MerkleProofLib} from "@solmate/utils/MerkleProofLib.sol";
import {RewardVaultManager} from "../core/RewardVaultManager.sol";
import {IRewardVault} from "../interfaces/IRewardVault.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

/// @title RewardVaultManagerMerkle
/// @notice Extends RewardVaultManager with merkle-based token allocation and distribution
/// @dev Uses merkle proofs to efficiently verify and distribute token rewards
contract RewardVaultManagerMerkle is RewardVaultManager {
    using MerkleProofLib for bytes32[];
    using SafeTransferLib for address;

    /// @notice Represents a token allocation with its merkle root
    struct TokenAllocation {
        uint256 allocationAmount;
        uint256 claimedAmount;
        address rewardToken;
    }

    /// @notice Represents a user's claims
    struct UserClaims {
        bytes32[] merkleRoots;
        mapping(bytes32 => bool) hasClaimed;
    }

    /// @notice Maps merkle roots to their token allocation details
    mapping(bytes32 => TokenAllocation) public tokenAllocations;

    /// @notice Maps user addresses to their claim details
    mapping(address => UserClaims) internal userClaims;

    /// @notice Tracks the total amount of tokens allocated
    uint256 public totalAllocatedTokens;

    /// @notice Whether the contract has been initialized
    bool public initialized;

    /// @notice Emitted when a new token allocation is created
    /// @param merkleRoot The merkle root of the allocation
    /// @param allocationAmount The amount of tokens allocated
    /// @param rewardToken The token that will be used for rewards
    event TokenAllocationCreated(bytes32 indexed merkleRoot, uint256 allocationAmount, address indexed rewardToken);

    /// @notice Emitted when a user claims their reward
    /// @param merkleRoot The merkle root of the allocation being claimed from
    /// @param user The address of the user claiming the reward
    /// @param amount The amount of tokens claimed
    event TokenClaimed(bytes32 indexed merkleRoot, address indexed user, uint256 amount);

    /// @notice Custom errors for better gas efficiency and error handling
    error AlreadyInitialized();
    error NotInitialized();
    error InvalidAmount();
    error InvalidMerkleProof();
    error AlreadyClaimed();
    error AllocationExists();
    error InvalidRewardToken();

    /// @notice Initializes the contract by registering the reward vault and staking a reward vault token
    /// @dev Can only be called once, after reward vault is deployed
    function initialize(address _rewardVault) external onlyOwner {
        if (initialized) revert AlreadyInitialized();
        if (_rewardVault == address(0)) revert NotInitialized();

        IRewardVault vault = IRewardVault(_rewardVault);
        if (vault.stakeToken() != address(rewardVaultToken)) revert InvalidAmount();
        rewardVault = vault;

        // Mint one token and stake it permanently
        rewardVaultToken.mint(address(this), 1 ether);
        rewardVaultToken.approve(address(rewardVault), type(uint256).max);
        rewardVault.stake(1 ether);

        initialized = true;
    }

    /// @notice Creates a new token allocation with a merkle root
    /// @param merkleRoot The merkle root of the allocation
    /// @param allocationAmount The amount of tokens to allocate
    /// @param rewardToken The token that will be used for rewards
    /// @dev The allocation amount must be available in minted tokens
    function createAllocation(bytes32 merkleRoot, uint256 allocationAmount, address rewardToken) external onlyOwner {
        if (!initialized) revert NotInitialized();
        if (tokenAllocations[merkleRoot].allocationAmount != 0) revert AllocationExists();
        if (allocationAmount == 0) revert InvalidAmount();
        if (rewardToken == address(0)) revert InvalidRewardToken();

        // Check if we have enough tokens available
        uint256 availableTokens = tokensMinted[rewardToken] - tokensAllocated[rewardToken];
        if (allocationAmount > availableTokens) revert InsufficientTokens();

        // Update token accounting
        tokensAllocated[rewardToken] += allocationAmount;

        // @audit trusted external contract
        tokenAllocations[merkleRoot] =
            TokenAllocation({allocationAmount: allocationAmount, claimedAmount: 0, rewardToken: rewardToken});

        totalAllocatedTokens += allocationAmount;
        emit TokenAllocationCreated(merkleRoot, allocationAmount, rewardToken);
    }

    /// @notice Allows a user to claim their reward using a merkle proof
    /// @param merkleRoot The merkle root of the allocation to claim from
    /// @param claimId The unique identifier for this claim
    /// @param token The token address for this claim
    /// @param amount The amount of tokens to claim
    /// @param proof The merkle proof verifying the claim
    /// @dev The merkle proof must be valid for the allocation's root
    /// @dev The user must not have already claimed their reward
    function claim(bytes32 merkleRoot, bytes32 claimId, address token, uint256 amount, bytes32[] calldata proof)
        external
    {
        TokenAllocation storage allocation = tokenAllocations[merkleRoot];
        if (allocation.allocationAmount == 0) revert InvalidMerkleProof();
        if (userClaims[msg.sender].hasClaimed[merkleRoot]) revert AlreadyClaimed();
        if (token != allocation.rewardToken) revert InvalidRewardToken();

        // Verify the merkle proof
        bytes32 leaf = keccak256(abi.encodePacked(claimId, msg.sender, token, amount));
        if (!MerkleProofLib.verify(proof, merkleRoot, leaf)) revert InvalidMerkleProof();

        // Mark as claimed and add to user's claims
        userClaims[msg.sender].hasClaimed[merkleRoot] = true;
        userClaims[msg.sender].merkleRoots.push(merkleRoot);

        // Update accounting
        allocation.claimedAmount += amount;
        tokensClaimed[allocation.rewardToken] += amount;

        // Transfer tokens to the user
        // @audit trusted external contract
        ERC20(allocation.rewardToken).transfer(msg.sender, amount);

        emit TokenClaimed(merkleRoot, msg.sender, amount);
    }
}
