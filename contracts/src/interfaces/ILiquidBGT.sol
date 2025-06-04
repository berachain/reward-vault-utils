// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ILiquidBGT
/// @notice Interface for redeeming liquid BGT tokens
interface ILiquidBGT {
    /// @notice Redeems liquid BGT tokens for BGT
    /// @param amount The amount of liquid BGT to redeem
    /// @return The amount of BGT received
    function redeem(uint256 amount) external returns (uint256);
}
