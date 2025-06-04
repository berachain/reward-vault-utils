// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ILiquidBGTMinter
/// @notice Interface for minting liquid BGT tokens
interface ILiquidBGTMinter {
    /// @notice Mints liquid BGT tokens for BGT
    /// @param user The address of the user claiming the reward
    /// @param rewardVault The address of the reward vault
    /// @param recipient The address that will receive the liquid BGT
    /// @return The amount of liquid BGT minted
    function mint(address user, address rewardVault, address recipient) external returns (uint256);
}
