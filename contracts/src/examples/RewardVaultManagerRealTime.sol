// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Owned} from "@solmate/auth/Owned.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {RewardVaultManager} from "../core/RewardVaultManager.sol";
import {IRewardVault} from "../interfaces/IRewardVault.sol";
import {ILiquidBGTMinter} from "../interfaces/ILiquidBGTMinter.sol";

/// @title RewardVaultManagerRealTime
/// @notice Extends RewardVaultManager with real-time reward distribution
/// @dev Allows whitelisted addresses to distribute rewards instantly using liquid BGT
contract RewardVaultManagerRealTime is RewardVaultManager {
    /// @notice Maps addresses to their whitelist status for real-time distribution
    mapping(address => bool) public isWhitelistedDistributor;

    /// @notice Emitted when a distributor is whitelisted or removed
    /// @param distributor The address of the distributor
    /// @param isWhitelisted Whether the distributor is whitelisted
    event DistributorWhitelistUpdated(address indexed distributor, bool isWhitelisted);

    /// @notice Emitted when a real-time reward is successfully distributed
    /// @param distributor The address that distributed the reward
    /// @param recipient The address that received the reward
    /// @param amount The amount of BGT distributed
    event RealTimeRewardDistributed(address indexed distributor, address indexed recipient, uint256 amount);

    /// @notice Emitted when a real-time reward distribution fails due to insufficient balance
    /// @param distributor The address that attempted to distribute the reward
    /// @param recipient The address that was supposed to receive the reward
    /// @param requestedAmount The amount of BGT that was requested
    /// @param availableBalance The available balance at the time of the attempt
    event RealTimeRewardDistributionFailed(
        address indexed distributor, address indexed recipient, uint256 requestedAmount, uint256 availableBalance
    );

    /// @notice Custom errors for better gas efficiency and error handling
    error NotWhitelistedDistributor();
    error InvalidRecipient();
    error InvalidAmount();

    /// @notice Modifier to ensure only whitelisted distributors can call functions
    modifier onlyWhitelistedDistributor() {
        if (!isWhitelistedDistributor[msg.sender]) revert NotWhitelistedDistributor();
        _;
    }

    /// @notice Whitelists or removes a distributor address
    /// @param distributor The address to whitelist or remove
    /// @param isWhitelisted Whether to whitelist (true) or remove (false) the distributor
    /// @dev Can only be called by the owner
    function setDistributorWhitelist(address distributor, bool isWhitelisted) external onlyOwner {
        isWhitelistedDistributor[distributor] = isWhitelisted;
        emit DistributorWhitelistUpdated(distributor, isWhitelisted);
    }

    /// @notice Distributes a real-time BGT reward to a recipient
    /// @param recipient The address to receive the BGT reward
    /// @param amount The amount of BGT to distribute
    /// @dev Can only be called by whitelisted distributors
    /// @dev If liquid BGT token not set, does nothing
    /// @dev If insufficient balance, emits failure event and does nothing
    function distributeRealTimeReward(address recipient, uint256 amount) external onlyWhitelistedDistributor {
        if (recipient == address(0)) revert InvalidRecipient();
        if (amount == 0) revert InvalidAmount();

        // If liquid BGT token not set, do nothing
        if (liquidBGTToken == address(0)) {
            return;
        }

        // Check FBGT balance in this contract
        uint256 availableBalance = ERC20(liquidBGTToken).balanceOf(address(this));

        if (amount > availableBalance) {
            // Emit failure event and do nothing
            emit RealTimeRewardDistributionFailed(msg.sender, recipient, amount, availableBalance);
            return;
        }

        ERC20(liquidBGTToken).transfer(recipient, amount);

        emit RealTimeRewardDistributed(msg.sender, recipient, amount);
    }
}
