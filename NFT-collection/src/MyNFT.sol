// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {
    ERC721,
    ERC721URIStorage
} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    uint256 public constant MAX_SUPPLY = 3000;
    uint256 public totalSupply;

    constructor() ERC721("MyNFT", "NFT") Ownable(msg.sender) {
        totalSupply = 0;
    }

    function mint(string memory tokenUri) external onlyOwner {
        require(totalSupply < MAX_SUPPLY, "Max supply reached");
        _safeMint(msg.sender, totalSupply);
        _setTokenURI(totalSupply, tokenUri);
        totalSupply++;
    }

    function changeImage(uint256 tokenId, string memory newURI) public {
        require(ownerOf(tokenId) == msg.sender, "Not the token Owner");
        _setTokenURI(tokenId, newURI);
    }
}
