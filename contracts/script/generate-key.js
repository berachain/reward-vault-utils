const { ethers } = require('ethers');
const fs = require('fs');
const path = require('path');

// Generate a new random wallet
const wallet = ethers.Wallet.createRandom();

// Create .env content
const envContent = `# Private key for deployment (without 0x prefix)
PRIVATE_KEY=${wallet.privateKey.slice(2)}

# Etherscan API key for contract verification
ETHERSCAN_API_KEY=

# RPC URL for deployment network
RPC_URL=
`;

// Write to .env file
const envPath = path.join(__dirname, '..', '.env');
fs.writeFileSync(envPath, envContent);

console.log('Generated new wallet:');
console.log('Address:', wallet.address);
console.log('Private Key:', wallet.privateKey);
console.log('\n.env file has been created with the private key.');
console.log('Please add your Etherscan API key and RPC URL to the .env file.'); 