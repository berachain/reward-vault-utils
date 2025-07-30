// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Owned} from "@solmate/auth/Owned.sol";

/// @title TokenFactory
/// @notice A factory contract for creating ERC20 tokens
/// @dev Creates tokens with the deployer as owner and mints them the full supply
contract TokenFactory {
    // ============ Events ============

    /// @notice Emitted when a new token is created
    /// @param token The address of the created token
    /// @param name The name of the token
    /// @param symbol The symbol of the token
    /// @param decimals The decimals of the token
    /// @param totalSupply The total supply of the token
    /// @param owner The owner of the token
    event TokenCreated(
        address indexed token,
        string name,
        string symbol,
        uint8 decimals,
        uint256 totalSupply,
        address indexed owner
    );

    // ============ Errors ============

    /// @notice Error thrown when trying to create a token with zero total supply
    error ZeroTotalSupply();
    /// @notice Error thrown when trying to create a token with empty name or symbol
    error EmptyNameOrSymbol();

    // ============ External Functions ============

    /// @notice Creates a new ERC20 token
    /// @param name The name of the token
    /// @param symbol The symbol of the token
    /// @param decimals The decimals of the token
    /// @param totalSupply The total supply of the token
    /// @return token The address of the created token
    function createToken(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply
    ) external returns (address token) {
        if (totalSupply == 0) revert ZeroTotalSupply();
        if (bytes(name).length == 0 || bytes(symbol).length == 0) revert EmptyNameOrSymbol();

        // Deploy the new token
        FactoryToken newToken = new FactoryToken(
            name,
            symbol,
            decimals,
            totalSupply,
            msg.sender
        );

        token = address(newToken);

        emit TokenCreated(token, name, symbol, decimals, totalSupply, msg.sender);
    }
}

/// @title FactoryToken
/// @notice An ERC20 token created by the TokenFactory
/// @dev Inherits from ERC20 and Owned, with the creator as the owner
contract FactoryToken is ERC20, Owned {
    // ============ Constructor ============

    /// @notice Creates a new FactoryToken
    /// @param name The name of the token
    /// @param symbol The symbol of the token
    /// @param decimals The decimals of the token
    /// @param totalSupply The total supply of the token
    /// @param owner The owner of the token
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply,
        address owner
    ) ERC20(name, symbol, decimals) Owned(owner) {
        // Mint the full supply to the owner
        _mint(owner, totalSupply);
    }
} 