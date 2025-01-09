// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script, console} from "forge-std/Script.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    function run() external returns(MyNFT) {
        vm.startBroadcast();
        MyNFT nft = new MyNFT();
        console.log("MyNFT contract deployed at:", address(nft));
        vm.stopBroadcast();
        return nft;
    }
}
