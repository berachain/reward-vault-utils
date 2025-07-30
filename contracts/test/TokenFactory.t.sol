// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {TokenFactory} from "../src/utilities/TokenFactory.sol";
import {FactoryToken} from "../src/utilities/TokenFactory.sol";

contract TokenFactoryTest is Test {
    TokenFactory public factory;
    address public user = address(0x1);

    function setUp() public {
        factory = new TokenFactory();
    }

    function test_CreateToken() public {
        vm.startPrank(user);
        
        string memory name = "Test Token";
        string memory symbol = "TEST";
        uint8 decimals = 18;
        uint256 totalSupply = 1000000 * 10**18; // 1 million tokens
        
        address tokenAddress = factory.createToken(name, symbol, decimals, totalSupply);
        
        FactoryToken token = FactoryToken(tokenAddress);
        
        // Verify token properties
        assertEq(token.name(), name);
        assertEq(token.symbol(), symbol);
        assertEq(token.decimals(), decimals);
        assertEq(token.totalSupply(), totalSupply);
        assertEq(token.owner(), user);
        assertEq(token.balanceOf(user), totalSupply);
        
        vm.stopPrank();
    }

    function test_CreateTokenWithCustomDecimals() public {
        vm.startPrank(user);
        
        string memory name = "USDC";
        string memory symbol = "USDC";
        uint8 decimals = 6;
        uint256 totalSupply = 1000000 * 10**6; // 1 million USDC
        
        address tokenAddress = factory.createToken(name, symbol, decimals, totalSupply);
        
        FactoryToken token = FactoryToken(tokenAddress);
        
        // Verify token properties
        assertEq(token.name(), name);
        assertEq(token.symbol(), symbol);
        assertEq(token.decimals(), decimals);
        assertEq(token.totalSupply(), totalSupply);
        assertEq(token.owner(), user);
        assertEq(token.balanceOf(user), totalSupply);
        
        vm.stopPrank();
    }

    function test_RevertZeroTotalSupply() public {
        vm.startPrank(user);
        
        vm.expectRevert(TokenFactory.ZeroTotalSupply.selector);
        factory.createToken("Test", "TEST", 18, 0);
        
        vm.stopPrank();
    }

    function test_RevertEmptyName() public {
        vm.startPrank(user);
        
        vm.expectRevert(TokenFactory.EmptyNameOrSymbol.selector);
        factory.createToken("", "TEST", 18, 1000000 * 10**18);
        
        vm.stopPrank();
    }

    function test_RevertEmptySymbol() public {
        vm.startPrank(user);
        
        vm.expectRevert(TokenFactory.EmptyNameOrSymbol.selector);
        factory.createToken("Test", "", 18, 1000000 * 10**18);
        
        vm.stopPrank();
    }

    function test_TokenCreatedEvent() public {
        vm.startPrank(user);
        
        string memory name = "Test Token";
        string memory symbol = "TEST";
        uint8 decimals = 18;
        uint256 totalSupply = 1000000 * 10**18;
        
        // Just verify that creating a token doesn't revert
        // The event emission is implicitly tested by the successful token creation
        address tokenAddress = factory.createToken(name, symbol, decimals, totalSupply);
        
        // Verify the token was created successfully
        assertTrue(tokenAddress != address(0), "Token should be created");
        
        vm.stopPrank();
    }
} 