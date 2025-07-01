// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@solmate/tokens/ERC20.sol";

/// @title RewardVaultToken
/// @notice A token used for staking in reward vaults
/// @dev This token is designed to be used as the staking token in the RewardVault
contract RewardVaultToken is ERC20 {
    /// @notice Creates a new RewardVaultToken
    /// @param name The name of the token
    /// @param symbol The symbol of the token
    /// @param decimals The number of decimals the token uses
    /// @dev The token uses 18 decimals by default, matching most ERC20 tokens
    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol, decimals) {
        _mint(msg.sender, 1 ether);
    }
}
