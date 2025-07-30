// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {TokenFactory} from "../src/utilities/TokenFactory.sol";
import {FactoryToken} from "../src/utilities/TokenFactory.sol";

/// @title CreateTestToken
/// @notice Script to test the TokenFactory by creating a test token
contract CreateTestToken is Script {
    // TokenFactory deployed on Bepolia
    address private constant TOKEN_FACTORY = 0xa85e0124d661152CDf522142AA184448bCCcC312;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TokenFactory factory = TokenFactory(TOKEN_FACTORY);
        
        // Create a test token
        string memory name = "Test Token";
        string memory symbol = "TEST";
        uint8 decimals = 18;
        uint256 totalSupply = 1000000 * 10**18; // 1 million tokens
        
        console.log("Creating token with parameters:");
        console.log("Name:", name);
        console.log("Symbol:", symbol);
        console.log("Decimals:", decimals);
        console.log("Total Supply:", totalSupply);
        
        address tokenAddress = factory.createToken(name, symbol, decimals, totalSupply);
        
        console.log("Token created at address:", tokenAddress);
        
        // Verify the token was created correctly
        FactoryToken token = FactoryToken(tokenAddress);
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Token decimals:", token.decimals());
        console.log("Token total supply:", token.totalSupply());
        console.log("Token owner:", token.owner());
        console.log("Deployer balance:", token.balanceOf(vm.addr(deployerPrivateKey)));

        vm.stopBroadcast();
    }
} 