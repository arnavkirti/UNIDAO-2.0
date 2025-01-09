// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Test} from "forge-std/Test.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract TestMyNFT is Test {
    MyNFT private nft;
    address private owner = address(0x123);
    address private nonOwner = address(0x456);

    function setUp() public {
        vm.prank(owner);
        nft = new MyNFT();
    }

    function testInitialSetup() public view {
        assertEq(nft.totalSupply(), 0, "Initial total supply should be 0");
        assertEq(nft.MAX_SUPPLY(), 3000, "Max supply should be 3000");
    }

    function testMinting() public {
        vm.prank(owner);
        nft.mint("https://abcd.com/metadata");

        assertEq(nft.totalSupply(), 1, "Total supply increase");
        assertEq(nft.ownerOf(0), owner, "Owner == deployer");
    }

    function testMintingFailsWhenMaxSupplyReached() public {
        vm.startPrank(owner);
        for (uint256 i = 0; i < nft.MAX_SUPPLY(); i++) {
            nft.mint(string(abi.encodePacked("https://abcd.com/metadata/", i)));
        }
        vm.stopPrank();

        vm.prank(owner);
        vm.expectRevert("Max supply reached");
        nft.mint("https://abcd.com/metadata/3001");
    }

    function testMintByOwner() public {
        vm.prank(owner);
        nft.mint("https://example.com/metadata/0");

        assertEq(nft.totalSupply(), 1, "Total supply should increment");
        assertEq(nft.tokenURI(0), "https://example.com/metadata/0", "Token URI should match");
        assertEq(nft.ownerOf(0), owner, "Token owner should be the deployer");
    }

    function testMintFailsWhenMaxSupplyReached() public {
        vm.startPrank(owner);
        for (uint256 i = 0; i < nft.MAX_SUPPLY(); i++) {
            nft.mint(string(abi.encodePacked("https://example.com/metadata/", i)));
        }
        vm.stopPrank();

        vm.prank(owner);
        vm.expectRevert("Max supply reached");
        nft.mint("https://example.com/metadata/3000");
    }

    function testChangeImageByOwner() public {
        vm.prank(owner);
        nft.mint("https://example.com/metadata/0");

        vm.prank(owner);
        nft.changeImage(0, "https://example.com/updated-metadata/0");

        assertEq(nft.tokenURI(0), "https://example.com/updated-metadata/0", "Token URI should be updated");
    }

    function testChangeImageFailsForNonOwner() public {
        vm.prank(owner);
        nft.mint("https://example.com/metadata/0");

        vm.prank(nonOwner);
        vm.expectRevert("Not the token Owner");
        nft.changeImage(0, "https://example.com/updated-metadata/0");
    }
}
