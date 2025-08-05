# Next.js RewardVaultLootBox Deployment Example

This guide shows how to deploy `RewardVaultLootBox` directly from a Next.js application without using a factory contract.

## Prerequisites

```bash
npm install ethers@6.9.0 wagmi viem @tanstack/react-query
```

## Contract Artifacts

The playground includes the following contract artifacts:

- `RewardVaultLootBox.json` - Main contract for deployment
- `LootBox.json` - NFT contract for loot boxes
- `LootBoxFactory.json` - Factory contract (for reference)
- `RewardVaultLootBoxFactory.json` - Factory contract (for reference)

## Contract Addresses (Berachain Bepolia)

```javascript
const CONTRACT_ADDRESSES = {
  // Hardcoded entropy addresses for Berachain Bepolia
  ENTROPY_CONTRACT: "0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320",
  DEFAULT_ENTROPY_PROVIDER: "0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344",
  // Your deployed LootBox NFT address
  LOOTBOX_NFT: "0x1b42805C4276e9390383AcA1690efa4Db033a7e7"
};
```

## RewardVaultLootBox ABI

```javascript
const REWARD_VAULT_LOOTBOX_ABI = [
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_entropyContract",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "_lootBoxContract",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "_defaultEntropyProvider",
        "type": "address"
      },
      {
        "internalType": "uint256[]",
        "name": "_rarityProbabilities",
        "type": "uint256[]"
      },
      {
        "internalType": "uint256[]",
        "name": "_rarityRewardBips",
        "type": "uint256[]"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];
```

## Using Contract Artifacts

```typescript
// lib/contracts.ts
import RewardVaultLootBoxArtifact from '../docs/reward-vault-utils-playground/RewardVaultLootBox.json';

export const REWARD_VAULT_LOOTBOX_ABI = RewardVaultLootBoxArtifact.abi;
export const REWARD_VAULT_LOOTBOX_BYTECODE = RewardVaultLootBoxArtifact.bytecode.object;
```

## Deployment Hook

```typescript
// hooks/useRewardVaultLootBoxDeployment.ts
import { useState } from 'react';
import { useAccount, useContractWrite, useWaitForTransaction } from 'wagmi';
import { parseEther } from 'viem';
import { REWARD_VAULT_LOOTBOX_ABI, REWARD_VAULT_LOOTBOX_BYTECODE } from '../lib/contracts';

interface DeploymentParams {
  lootBoxContract: string;
  rarityProbabilities: number[];
  rarityRewardBips: number[];
}

export const useRewardVaultLootBoxDeployment = () => {
  const [isDeploying, setIsDeploying] = useState(false);
  const [deployedAddress, setDeployedAddress] = useState<string | null>(null);
  const { address } = useAccount();

  // Validate parameters
  const validateParams = (params: DeploymentParams) => {
    const { rarityProbabilities, rarityRewardBips } = params;
    
    if (rarityProbabilities.length !== 5) {
      throw new Error('Must have exactly 5 rarity probabilities');
    }
    
    if (rarityRewardBips.length !== 5) {
      throw new Error('Must have exactly 5 reward rates');
    }
    
    const totalProbability = rarityProbabilities.reduce((sum, prob) => sum + prob, 0);
    if (totalProbability !== 10000) {
      throw new Error('Probabilities must sum to 10000 (100%)');
    }
    
    return true;
  };

  // Deploy contract
  const deployContract = async (params: DeploymentParams) => {
    try {
      setIsDeploying(true);
      validateParams(params);

      const { lootBoxContract, rarityProbabilities, rarityRewardBips } = params;

      // Constructor arguments
      const constructorArgs = [
        CONTRACT_ADDRESSES.ENTROPY_CONTRACT,
        lootBoxContract,
        CONTRACT_ADDRESSES.DEFAULT_ENTROPY_PROVIDER,
        rarityProbabilities,
        rarityRewardBips
      ];

      // Deploy using ethers
      const { ethers } = await import('ethers');
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();

      const factory = new ethers.ContractFactory(
        REWARD_VAULT_LOOTBOX_ABI,
        REWARD_VAULT_LOOTBOX_BYTECODE,
        signer
      );

      const contract = await factory.deploy(...constructorArgs);
      await contract.waitForDeployment();

      const deployedAddress = await contract.getAddress();
      setDeployedAddress(deployedAddress);

      return deployedAddress;
    } catch (error) {
      console.error('Deployment failed:', error);
      throw error;
    } finally {
      setIsDeploying(false);
    }
  };

  return {
    deployContract,
    isDeploying,
    deployedAddress
  };
};
```

## React Component Example

```tsx
// components/RewardVaultLootBoxDeployer.tsx
import { useState } from 'react';
import { useRewardVaultLootBoxDeployment } from '../hooks/useRewardVaultLootBoxDeployment';

export const RewardVaultLootBoxDeployer = () => {
  const [lootBoxContract, setLootBoxContract] = useState('');
  const [rarityProbabilities, setRarityProbabilities] = useState([5000, 4000, 900, 90, 10]);
  const [rarityRewardBips, setRarityRewardBips] = useState([10, 100, 500, 2000, 5000]);
  
  const { deployContract, isDeploying, deployedAddress } = useRewardVaultLootBoxDeployment();

  const handleDeploy = async () => {
    try {
      const address = await deployContract({
        lootBoxContract,
        rarityProbabilities,
        rarityRewardBips
      });
      
      console.log('Deployed at:', address);
    } catch (error) {
      console.error('Deployment failed:', error);
    }
  };

  return (
    <div className="p-6 bg-white rounded-lg shadow-md">
      <h2 className="text-2xl font-bold mb-4">Deploy RewardVaultLootBox</h2>
      
      <div className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">
            LootBox Contract Address
          </label>
          <input
            type="text"
            value={lootBoxContract}
            onChange={(e) => setLootBoxContract(e.target.value)}
            placeholder="0x..."
            className="w-full p-2 border rounded"
          />
        </div>

        <div>
          <label className="block text-sm font-medium mb-2">
            Rarity Probabilities (basis points)
          </label>
          <div className="grid grid-cols-5 gap-2">
            {rarityProbabilities.map((prob, index) => (
              <input
                key={index}
                type="number"
                value={prob}
                onChange={(e) => {
                  const newProbs = [...rarityProbabilities];
                  newProbs[index] = parseInt(e.target.value) || 0;
                  setRarityProbabilities(newProbs);
                }}
                className="p-2 border rounded"
                placeholder={`Rarity ${index + 1}`}
              />
            ))}
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium mb-2">
            Reward Rates (basis points)
          </label>
          <div className="grid grid-cols-5 gap-2">
            {rarityRewardBips.map((reward, index) => (
              <input
                key={index}
                type="number"
                value={reward}
                onChange={(e) => {
                  const newRewards = [...rarityRewardBips];
                  newRewards[index] = parseInt(e.target.value) || 0;
                  setRarityRewardBips(newRewards);
                }}
                className="p-2 border rounded"
                placeholder={`Reward ${index + 1}`}
              />
            ))}
          </div>
        </div>

        <button
          onClick={handleDeploy}
          disabled={isDeploying || !lootBoxContract}
          className="w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 disabled:opacity-50"
        >
          {isDeploying ? 'Deploying...' : 'Deploy RewardVaultLootBox'}
        </button>

        {deployedAddress && (
          <div className="mt-4 p-4 bg-green-100 rounded">
            <p className="font-medium">Deployed Successfully!</p>
            <p className="text-sm text-gray-600">Address: {deployedAddress}</p>
            <a
              href={`https://bepolia.beratrail.io/address/${deployedAddress}`}
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 hover:underline"
            >
              View on Berascan
            </a>
          </div>
        )}
      </div>
    </div>
  );
};
```

## Wagmi Configuration

```typescript
// lib/wagmi.ts
import { createConfig, configureChains } from 'wagmi';
import { berachainBepolia } from 'wagmi/chains';
import { publicProvider } from 'wagmi/providers/public';
import { MetaMaskConnector } from 'wagmi/connectors/metaMask';

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [berachainBepolia],
  [publicProvider()]
);

export const config = createConfig({
  autoConnect: true,
  connectors: [
    new MetaMaskConnector({ chains })
  ],
  publicClient,
  webSocketPublicClient,
});
```

## Usage in Next.js App

```tsx
// pages/deploy.tsx
import { WagmiConfig } from 'wagmi';
import { config } from '../lib/wagmi';
import { RewardVaultLootBoxDeployer } from '../components/RewardVaultLootBoxDeployer';

export default function DeployPage() {
  return (
    <WagmiConfig config={config}>
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="max-w-2xl mx-auto">
          <RewardVaultLootBoxDeployer />
        </div>
      </div>
    </WagmiConfig>
  );
}
```

## Key Points

1. **Direct Deployment**: No factory needed - deploy `RewardVaultLootBox` directly
2. **Parameter Validation**: Client-side validation before deployment
3. **Hardcoded Addresses**: Uses the same entropy addresses as the factory
4. **Error Handling**: Comprehensive error handling and user feedback
5. **Transaction Tracking**: Shows deployment progress and final address

## Alternative: Using Foundry Script

If you prefer to use Foundry for deployment:

```bash
# Create deployment script
forge script DeployRewardVaultLootBox --rpc-url https://bepolia.rpc.berachain.com --broadcast --verify
```

This approach gives you full control over the deployment process without the size constraints of a factory contract! 