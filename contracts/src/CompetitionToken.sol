// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Owned} from "@solmate/auth/Owned.sol";

/// @title CompetitionToken
/// @notice A token used for staking in competitions, with minting and burning capabilities
/// @dev This token is designed to be used as the staking token in the CompetitionRewardVault
/// @dev Only the owner (CompetitionRewardVault) can mint and burn tokens
contract CompetitionToken is ERC20, Owned {
    /// @notice Creates a new CompetitionToken
    /// @param name The name of the token
    /// @param symbol The symbol of the token
    /// @param decimals The number of decimals the token uses
    /// @dev The token uses 18 decimals by default, matching most ERC20 tokens
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) ERC20(name, symbol, decimals) Owned(msg.sender) {}

    /// @notice Mints new tokens to a specified address
    /// @param to The address to mint tokens to
    /// @param amount The amount of tokens to mint
    /// @dev Only the owner (CompetitionRewardVault) can mint tokens
    /// @dev This is used when participants stake in a competition
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Burns tokens from a specified address
    /// @param from The address to burn tokens from
    /// @param amount The amount of tokens to burn
    /// @dev Only the owner (CompetitionRewardVault) can burn tokens
    /// @dev This is used when participants unstake from a competition
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
} 