// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title FBGTFaucet
/// @notice Simple faucet contract for distributing FBGT tokens
contract FBGTFaucet is Ownable {
    ERC20 public immutable fbgtToken;

    event TokensDistributed(address indexed recipient, uint256 amount);
    event TokensWithdrawn(address indexed owner, uint256 amount);

    /// @notice Creates a new FBGT faucet
    /// @param _fbgtToken The address of the FBGT token contract
    constructor(address _fbgtToken) Ownable(msg.sender) {
        require(_fbgtToken != address(0), "Invalid FBGT address");
        fbgtToken = ERC20(_fbgtToken);
    }

    /// @notice Distribute FBGT tokens to a specified address
    /// @param recipient The address to receive the tokens
    /// @param amount The amount of tokens to distribute
    function distributeTokens(address recipient, uint256 amount) external onlyOwner {
        require(recipient != address(0), "Invalid recipient");
        require(amount > 0, "Amount must be greater than 0");
        require(fbgtToken.balanceOf(address(this)) >= amount, "Insufficient balance");

        bool success = fbgtToken.transfer(recipient, amount);
        require(success, "Transfer failed");

        emit TokensDistributed(recipient, amount);
    }

    /// @notice Distribute FBGT tokens to multiple addresses
    /// @param recipients Array of addresses to receive tokens
    /// @param amounts Array of amounts to distribute (must match recipients length)
    function distributeTokensBatch(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Arrays length mismatch");
        require(recipients.length > 0, "Empty arrays");

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        require(fbgtToken.balanceOf(address(this)) >= totalAmount, "Insufficient balance");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient");
            require(amounts[i] > 0, "Amount must be greater than 0");

            bool success = fbgtToken.transfer(recipients[i], amounts[i]);
            require(success, "Transfer failed");

            emit TokensDistributed(recipients[i], amounts[i]);
        }
    }

    /// @notice Withdraw FBGT tokens from the faucet (owner only)
    /// @param amount The amount of tokens to withdraw
    function withdrawTokens(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(fbgtToken.balanceOf(address(this)) >= amount, "Insufficient balance");

        bool success = fbgtToken.transfer(msg.sender, amount);
        require(success, "Transfer failed");

        emit TokensWithdrawn(msg.sender, amount);
    }

    /// @notice Get the current FBGT balance of the faucet
    /// @return The current balance
    function getFaucetBalance() external view returns (uint256) {
        return fbgtToken.balanceOf(address(this));
    }

    /// @notice Get the FBGT token address
    /// @return The FBGT token address
    function getFBGTAddress() external view returns (address) {
        return address(fbgtToken);
    }
}
