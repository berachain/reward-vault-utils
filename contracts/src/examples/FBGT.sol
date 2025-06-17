// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Owned} from "@solmate/auth/Owned.sol";

/// @title FBGT
/// @notice A mintable ERC20 token that represents Fake BGT
/// @dev Only the owner can mint new tokens
contract FBGT is ERC20, Owned {
    // ============ Events ============

    /// @notice Emitted when new tokens are minted
    /// @param to The address that received the tokens
    /// @param amount The amount of tokens minted
    event TokensMinted(address indexed to, uint256 amount);

    // ============ Errors ============

    /// @notice Error thrown when trying to mint zero tokens
    error ZeroAmount();

    // ============ Constructor ============

    /// @notice Creates a new FBGT token
    /// @dev The deployer (msg.sender) becomes the owner
    constructor() ERC20("Fake BGT", "FBGT", 18) Owned(msg.sender) {}

    // ============ External Functions ============

    /// @notice Mints new tokens to the specified address
    /// @param to The address to mint tokens to
    /// @param amount The amount of tokens to mint
    /// @dev Only callable by the owner
    function mint(address to, uint256 amount) external onlyOwner {
        if (amount == 0) revert ZeroAmount();
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }
} 