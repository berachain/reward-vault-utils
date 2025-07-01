// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ILiquidBGTMinter} from "../interfaces/ILiquidBGTMinter.sol";
import {IRewardVault} from "../interfaces/IRewardVault.sol";
import {Owned} from "@solmate/auth/Owned.sol";
import {FBGT} from "./FBGT.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";

/// @title LiquidBGTMinter
/// @notice A contract that mints liquid BGT tokens based on BGT rewards
/// @dev Implements the ILiquidBGTMinter interface
contract LiquidBGTMinter is ILiquidBGTMinter, Owned {
    // ============ State Variables ============

    /// @notice The FBGT token contract
    FBGT public immutable fbgt;

    /// @notice The BGT token contract on Bepolia
    ERC20 public constant BGT = ERC20(0x656b95E550C07a9ffe548bd4085c72418Ceb1dba);

    // ============ Events ============

    /// @notice Emitted when FBGT tokens are minted
    /// @param user The address of the user claiming the reward
    /// @param recipient The address that received the FBGT tokens
    /// @param amount The amount of FBGT tokens minted
    event FBGTMinted(address indexed user, address indexed recipient, uint256 amount);

    // ============ Errors ============

    /// @notice Error thrown when a zero address is provided
    error ZeroAddress();

    /// @notice Error thrown when no rewards were claimed
    error NoRewardsClaimed();

    // ============ Constructor ============

    /// @notice Creates a new LiquidBGTMinter
    /// @param _fbgt The address of the FBGT token contract
    /// @dev The deployer (msg.sender) becomes the owner
    constructor(address _fbgt) Owned(msg.sender) {
        if (_fbgt == address(0)) revert ZeroAddress();
        fbgt = FBGT(_fbgt);
    }

    // ============ External Functions ============

    /// @notice Mints FBGT tokens based on BGT rewards from a reward vault
    /// @param user The address of the user claiming the reward
    /// @param rewardVault The address of the reward vault
    /// @param recipient The address that will receive the liquid BGT
    /// @return The amount of liquid BGT minted
    function mint(address user, address rewardVault, address recipient) external override returns (uint256) {
        if (user == address(0)) revert ZeroAddress();
        if (rewardVault == address(0)) revert ZeroAddress();
        if (recipient == address(0)) revert ZeroAddress();

        // Get initial BGT balance
        uint256 initialBalance = BGT.balanceOf(address(this));

        // Claim rewards from vault
        IRewardVault(rewardVault).getReward(user, address(this));

        // Calculate amount of BGT received
        uint256 bgtReceived = BGT.balanceOf(address(this)) - initialBalance;
        if (bgtReceived == 0) revert NoRewardsClaimed();

        // Mint equivalent amount of FBGT to recipient
        fbgt.mint(recipient, bgtReceived);

        emit FBGTMinted(user, recipient, bgtReceived);

        return bgtReceived;
    }
}
