// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@solmate/tokens/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {RarityTypes} from "../libraries/RarityTypes.sol";

contract LootBox is ERC721, Ownable {
    address public controller;
    string public baseURI;
    uint256 public nextTokenId;

    struct LootBoxItem {
        RarityTypes.Rarity rarity;
        uint256 rewardBips;
        address rewardToken;
        bool claimed;
    }

    mapping(uint256 => LootBoxItem) public lootBoxItems;

    modifier onlyController() {
        require(msg.sender == controller, "NC");
        _;
    }

    constructor(string memory _name, string memory _symbol, string memory _baseURI, address _controller) ERC721(_name, _symbol) Ownable(msg.sender) {
        baseURI = _baseURI;
        controller = _controller;
    }

    function setController(address _controller) external onlyOwner {
        controller = _controller;
    }

    function mint(address to, LootBoxItem memory item) external onlyController returns (uint256 tokenId) {
        tokenId = nextTokenId++;
        _mint(to, tokenId);
        lootBoxItems[tokenId] = item;
    }

    function setClaimed(uint256 tokenId) external onlyController {
        lootBoxItems[tokenId].claimed = true;
    }

    function setBaseURI(string memory _baseURI) external onlyController {
        baseURI = _baseURI;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(ownerOf(id) != address(0), "NM");
        return string(abi.encodePacked(baseURI, _toString(id)));
    }

    function getLootBoxItem(uint256 tokenId) external view returns (LootBoxItem memory) {
        return lootBoxItems[tokenId];
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
} 