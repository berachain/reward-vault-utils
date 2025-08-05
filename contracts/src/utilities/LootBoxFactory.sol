// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {LootBox} from "../examples/LootBox.sol";

/// @title LootBoxFactory
/// @notice Minimal factory for deploying LootBox contracts
contract LootBoxFactory {
    // Hardcoded entropy addresses for Berachain Bepolia
    address public constant ENTROPY_CONTRACT = 0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320;
    address public constant DEFAULT_ENTROPY_PROVIDER = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;

    event LootBoxDeployed(address indexed lootBox, address indexed deployer);

    /// @notice Deploy a new LootBox contract
    /// @param name The name of the NFT collection
    /// @param symbol The symbol of the NFT collection
    /// @param baseURI The base URI for metadata
    /// @return lootBox The address of the deployed LootBox contract
    function createLootBox(string memory name, string memory symbol, string memory baseURI)
        external
        returns (address lootBox)
    {
        lootBox = address(new LootBox(name, symbol, baseURI));

        // Transfer ownership to deployer
        LootBox(lootBox).transferOwnership(msg.sender);

        emit LootBoxDeployed(lootBox, msg.sender);
    }
}
