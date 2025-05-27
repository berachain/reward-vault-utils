// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 ^0.8.19 ^0.8.26;

// lib/solmate/src/tokens/ERC20.sol

/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
abstract contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    /*//////////////////////////////////////////////////////////////
                            EIP-2612 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 internal immutable INITIAL_CHAIN_ID;

    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;

    mapping(address => uint256) public nonces;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        INITIAL_CHAIN_ID = block.chainid;
        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
    }

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount) public virtual returns (bool) {
        balanceOf[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /*//////////////////////////////////////////////////////////////
                             EIP-2612 LOGIC
    //////////////////////////////////////////////////////////////*/

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");

        // Unchecked because the only math done is incrementing
        // the owner's nonce which cannot realistically overflow.
        unchecked {
            address recoveredAddress = ecrecover(
                keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        DOMAIN_SEPARATOR(),
                        keccak256(
                            abi.encode(
                                keccak256(
                                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                                ),
                                owner,
                                spender,
                                value,
                                nonces[owner]++,
                                deadline
                            )
                        )
                    )
                ),
                v,
                r,
                s
            );

            require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");

            allowance[recoveredAddress][spender] = value;
        }

        emit Approval(owner, spender, value);
    }

    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
        return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
    }

    function computeDomainSeparator() internal view virtual returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                    keccak256(bytes(name)),
                    keccak256("1"),
                    block.chainid,
                    address(this)
                )
            );
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

// src/interfaces/IRewardVault.sol

interface IRewardVault {
    // Events
    event DelegateStaked(address indexed account, address indexed delegate, uint256 amount);
    event DelegateWithdrawn(address indexed account, address indexed delegate, uint256 amount);
    event Recovered(address token, uint256 amount);
    event OperatorSet(address account, address operator);
    event DistributorSet(address indexed distributor);
    event IncentiveManagerChanged(address indexed token, address newManager, address oldManager);
    event IncentiveTokenWhitelisted(address indexed token, uint256 minIncentiveRate, address manager);
    event IncentiveTokenRemoved(address indexed token);
    event MaxIncentiveTokensCountUpdated(uint8 maxIncentiveTokensCount);
    event IncentivesProcessed(bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount);
    event IncentivesProcessFailed(bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount);
    event IncentiveAdded(address indexed token, address sender, uint256 amount, uint256 incentiveRate);
    event BGTBoosterIncentivesProcessed(bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount);
    event BGTBoosterIncentivesProcessFailed(bytes indexed pubkey, address indexed token, uint256 bgtEmitted, uint256 amount);

    // Getters
    function distributor() external view returns (address);
    function operator(address account) external view returns (address);
    function getWhitelistedTokensCount() external view returns (uint256);
    function getWhitelistedTokens() external view returns (address[] memory);
    function getTotalDelegateStaked(address account) external view returns (uint256);
    function getDelegateStake(address account, address delegate) external view returns (uint256);
    function stakeToken() external view returns (address);
    function earned(address account) external view returns (uint256);

    // Admin
    function initialize(address _berachef, address _bgt, address _distributor, address _stakingToken) external;
    function setDistributor(address _rewardDistribution) external;
    function notifyRewardAmount(bytes calldata pubkey, uint256 reward) external;
    function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
    function setRewardsDuration(uint256 _rewardsDuration) external;
    function whitelistIncentiveToken(address token, uint256 minIncentiveRate, address manager) external;
    function removeIncentiveToken(address token) external;
    function setMaxIncentiveTokensCount(uint8 _maxIncentiveTokensCount) external;
    function pause() external;
    function unpause() external;

    // Mutative
    function exit(address recipient) external;
    function getReward(address account, address recipient) external returns (uint256);
    function stake(uint256 amount) external;
    function delegateStake(address account, uint256 amount) external;
    function withdraw(uint256 amount) external;
    function delegateWithdraw(address account, uint256 amount) external;
    function setOperator(address _operator) external;
    function updateIncentiveManager(address token, address newManager) external;
    function addIncentive(address token, uint256 amount, uint256 incentiveRate) external;
    function accountIncentives(address token, uint256 amount) external;
} 

// lib/solmate/src/utils/MerkleProofLib.sol

/// @notice Gas optimized merkle proof verification library.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/MerkleProofLib.sol)
/// @author Modified from Solady (https://github.com/Vectorized/solady/blob/main/src/utils/MerkleProofLib.sol)
library MerkleProofLib {
    function verify(
        bytes32[] calldata proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool isValid) {
        /// @solidity memory-safe-assembly
        assembly {
            if proof.length {
                // Left shifting by 5 is like multiplying by 32.
                let end := add(proof.offset, shl(5, proof.length))

                // Initialize offset to the offset of the proof in calldata.
                let offset := proof.offset

                // Iterate over proof elements to compute root hash.
                // prettier-ignore
                for {} 1 {} {
                    // Slot where the leaf should be put in scratch space. If
                    // leaf > calldataload(offset): slot 32, otherwise: slot 0.
                    let leafSlot := shl(5, gt(leaf, calldataload(offset)))

                    // Store elements to hash contiguously in scratch space.
                    // The xor puts calldataload(offset) in whichever slot leaf
                    // is not occupying, so 0 if leafSlot is 32, and 32 otherwise.
                    mstore(leafSlot, leaf)
                    mstore(xor(leafSlot, 32), calldataload(offset))

                    // Reuse leaf to store the hash to reduce stack operations.
                    leaf := keccak256(0, 64) // Hash both slots of scratch space.

                    offset := add(offset, 32) // Shift 1 word per cycle.

                    // prettier-ignore
                    if iszero(lt(offset, end)) { break }
                }
            }

            isValid := eq(leaf, root) // The proof is valid if the roots match.
        }
    }
}

// lib/solmate/src/auth/Owned.sol

/// @notice Simple single owner authorization mixin.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
abstract contract Owned {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event OwnershipTransferred(address indexed user, address indexed newOwner);

    /*//////////////////////////////////////////////////////////////
                            OWNERSHIP STORAGE
    //////////////////////////////////////////////////////////////*/

    address public owner;

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _owner) {
        owner = _owner;

        emit OwnershipTransferred(address(0), _owner);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNERSHIP LOGIC
    //////////////////////////////////////////////////////////////*/

    function transferOwnership(address newOwner) public virtual onlyOwner {
        owner = newOwner;

        emit OwnershipTransferred(msg.sender, newOwner);
    }
}

// lib/solmate/src/utils/SafeTransferLib.sol

/// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
/// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
library SafeTransferLib {
    /*//////////////////////////////////////////////////////////////
                             ETH OPERATIONS
    //////////////////////////////////////////////////////////////*/

    function safeTransferETH(address to, uint256 amount) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Transfer the ETH and store if it succeeded or not.
            success := call(gas(), to, amount, 0, 0, 0, 0)
        }

        require(success, "ETH_TRANSFER_FAILED");
    }

    /*//////////////////////////////////////////////////////////////
                            ERC20 OPERATIONS
    //////////////////////////////////////////////////////////////*/

    function safeTransferFrom(
        ERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
            mstore(add(freeMemoryPointer, 4), and(from, 0xffffffffffffffffffffffffffffffffffffffff)) // Append and mask the "from" argument.
            mstore(add(freeMemoryPointer, 36), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
            // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
            success := call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)

            // Set success to whether the call reverted, if not we check it either
            // returned exactly 1 (can't just be non-zero data), or had no return data and token has code.
            if and(iszero(and(eq(mload(0), 1), gt(returndatasize(), 31))), success) {
                success := iszero(or(iszero(extcodesize(token)), returndatasize())) 
            }
        }

        require(success, "TRANSFER_FROM_FAILED");
    }

    function safeTransfer(
        ERC20 token,
        address to,
        uint256 amount
    ) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
            mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
            // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
            success := call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)

            // Set success to whether the call reverted, if not we check it either
            // returned exactly 1 (can't just be non-zero data), or had no return data and token has code.
            if and(iszero(and(eq(mload(0), 1), gt(returndatasize(), 31))), success) {
                success := iszero(or(iszero(extcodesize(token)), returndatasize())) 
            }
        }

        require(success, "TRANSFER_FAILED");
    }

    function safeApprove(
        ERC20 token,
        address to,
        uint256 amount
    ) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)
            mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
            // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
            success := call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)

            // Set success to whether the call reverted, if not we check it either
            // returned exactly 1 (can't just be non-zero data), or had no return data and token has code.
            if and(iszero(and(eq(mload(0), 1), gt(returndatasize(), 31))), success) {
                success := iszero(or(iszero(extcodesize(token)), returndatasize())) 
            }
        }

        require(success, "APPROVE_FAILED");
    }
}

// src/CompetitionToken.sol

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

    /// @notice Overrides transferFrom to allow owner to skip allowance checks
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        if (msg.sender == owner) {
            balanceOf[from] -= amount;
            unchecked {
                balanceOf[to] += amount;
            }
            emit Transfer(from, to, amount);
            return true;
        }
        uint256 allowed = allowance[from][msg.sender];
        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
        balanceOf[from] -= amount;
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(from, to, amount);
        return true;
    }
} 

// src/CompetitionManager.sol

/// @title CompetitionManager
/// @notice This contract manages competitions by creating and owning a competition token
/// @dev The contract can register a reward vault that uses the competition token for staking
contract CompetitionManager is Owned {
    using SafeTransferLib for address;

    /// @notice The competition token used for staking
    /// @dev This token is created and owned by this contract
    CompetitionToken public immutable competitionToken;

    /// @notice The RewardVault contract from Berachain that handles staking and rewards
    /// @dev This is initialized to address(0) and can be set once
    IRewardVault public rewardVault;

    /// @notice Emitted when a reward vault is registered
    /// @param rewardVault The address of the registered reward vault
    event RewardVaultRegistered(address indexed rewardVault);

    /// @notice Custom errors for better gas efficiency and error handling
    error RewardVaultAlreadySet();
    error InvalidRewardVault();
    error NotRewardVaultOwner();

    /// @notice Creates a new CompetitionManager
    /// @dev Creates a new CompetitionToken with name "Competition Token" and symbol "CT"
    constructor() Owned(msg.sender) {
        competitionToken = new CompetitionToken("Competition Token", "CT", 18);
    }

    /// @notice Registers a reward vault to be used with this competition manager
    /// @param _rewardVault The address of the reward vault to register
    /// @dev The reward vault must use the competition token as its staking token
    /// @dev Can only be called once
    function registerRewardVault(address _rewardVault) external onlyOwner {
        if (address(rewardVault) != address(0)) revert RewardVaultAlreadySet();
        if (_rewardVault == address(0)) revert InvalidRewardVault();

        IRewardVault vault = IRewardVault(_rewardVault);
        if (vault.stakeToken() != address(competitionToken)) revert InvalidRewardVault();

        rewardVault = vault;
        emit RewardVaultRegistered(_rewardVault);
    }
} 

// src/CompetitionManagerMerkle.sol

/// @title CompetitionManagerMerkle
/// @notice Extends CompetitionManager with merkle-based reward distribution
/// @dev Uses merkle proofs to efficiently verify and distribute rewards
contract CompetitionManagerMerkle is CompetitionManager {
    using MerkleProofLib for bytes32[];
    using SafeTransferLib for address;

    /// @notice Represents a competition with its reward allocation
    struct Competition {
        uint256 rewardAmount;
    }

    /// @notice Represents a user's participation in competitions
    struct UserParticipation {
        bytes32[] merkleRoots;
        mapping(bytes32 => bool) hasClaimed;
    }

    /// @notice Maps merkle roots to their competition details
    mapping(bytes32 => Competition) public competitions;

    /// @notice Maps user addresses to their participation details
    mapping(address => UserParticipation) internal userParticipations;

    /// @notice Tracks the total amount of BGT allocated to competitions
    uint256 public totalAllocatedBGT;

    /// @notice Whether the contract has been initialized
    bool public initialized;

    /// @notice Emitted when a new competition is created
    /// @param merkleRoot The merkle root of the competition
    /// @param rewardAmount The amount of BGT allocated to the competition
    event CompetitionCreated(bytes32 indexed merkleRoot, uint256 rewardAmount);

    /// @notice Emitted when a user claims their reward
    /// @param merkleRoot The merkle root of the competition being claimed from
    /// @param user The address of the user claiming the reward
    /// @param amount The amount of BGT claimed
    event RewardClaimed(bytes32 indexed merkleRoot, address indexed user, uint256 amount);

    /// @notice Custom errors for better gas efficiency and error handling
    error AlreadyInitialized();
    error NotInitialized();
    error InvalidAmount();
    error InvalidMerkleProof();
    error AlreadyClaimed();
    error InsufficientBGT();
    error CompetitionExists();

    /// @notice Initializes the contract by registering the reward vault and staking a competition token
    /// @dev Can only be called once, after reward vault is deployed
    function initialize(address _rewardVault) external onlyOwner {
        if (initialized) revert AlreadyInitialized();
        if (_rewardVault == address(0)) revert NotInitialized();

        IRewardVault vault = IRewardVault(_rewardVault);
        if (vault.stakeToken() != address(competitionToken)) revert InvalidAmount();
        rewardVault = vault;

        // Mint one token and stake it permanently
        competitionToken.mint(address(this), 1 ether);
        competitionToken.approve(address(rewardVault), type(uint256).max);
        rewardVault.stake(1 ether);

        initialized = true;
    }

    /// @notice Creates a new competition with a merkle root and reward allocation
    /// @param merkleRoot The merkle root of the competition
    /// @param rewardAmount The amount of BGT to allocate to the competition
    /// @dev The reward amount must be available in earned rewards
    function createCompetition(bytes32 merkleRoot, uint256 rewardAmount) external onlyOwner {
        if (!initialized) revert NotInitialized();
        if (competitions[merkleRoot].rewardAmount != 0) revert CompetitionExists();
        if (rewardAmount == 0) revert InvalidAmount();

        uint256 availableBGT = rewardVault.earned(address(this)) - totalAllocatedBGT;
        if (rewardAmount > availableBGT) revert InsufficientBGT();

        competitions[merkleRoot] = Competition({
            rewardAmount: rewardAmount
        });

        totalAllocatedBGT += rewardAmount;
        emit CompetitionCreated(merkleRoot, rewardAmount);
    }

    /// @notice Allows a user to claim their reward using a merkle proof
    /// @param merkleRoot The merkle root of the competition to claim from
    /// @param amount The amount of BGT to claim
    /// @param proof The merkle proof verifying the claim
    /// @dev The merkle proof must be valid for the competition's root
    /// @dev The user must not have already claimed their reward
    function claimReward(bytes32 merkleRoot, uint256 amount, bytes32[] calldata proof) external {
        Competition storage competition = competitions[merkleRoot];
        if (competition.rewardAmount == 0) revert InvalidMerkleProof();
        if (userParticipations[msg.sender].hasClaimed[merkleRoot]) revert AlreadyClaimed();

        // Verify the merkle proof
        bytes32 leaf = keccak256(abi.encodePacked(merkleRoot, msg.sender, amount));
        if (!MerkleProofLib.verify(proof, merkleRoot, leaf)) revert InvalidMerkleProof();

        // Mark as claimed and add to user's participation
        userParticipations[msg.sender].hasClaimed[merkleRoot] = true;
        userParticipations[msg.sender].merkleRoots.push(merkleRoot);

        // Get reward from the reward vault directly to the claimer
        rewardVault.getReward(address(this), msg.sender);

        emit RewardClaimed(merkleRoot, msg.sender, amount);
    }

    /// @notice Returns all merkle roots a user has participated in
    /// @param user The address of the user to check
    /// @return Array of merkle roots the user has participated in
    function getUserCompetitions(address user) external view returns (bytes32[] memory) {
        return userParticipations[user].merkleRoots;
    }

    /// @notice Returns whether a user has claimed their reward for a specific competition
    /// @param user The address of the user to check
    /// @param merkleRoot The merkle root of the competition to check
    /// @return Whether the user has claimed their reward
    function hasUserClaimed(address user, bytes32 merkleRoot) external view returns (bool) {
        return userParticipations[user].hasClaimed[merkleRoot];
    }

    /// @notice Returns the total amount of BGT earned by this contract in the reward vault
    /// @return The total amount of BGT earned
    function getEarnedBGT() external view returns (uint256) {
        return rewardVault.earned(address(this));
    }

    /// @notice Returns the amount of BGT available for new competitions
    /// @return The amount of BGT that hasn't been allocated to any competition
    function getAvailableBGT() external view returns (uint256) {
        return rewardVault.earned(address(this)) - totalAllocatedBGT;
    }
}
