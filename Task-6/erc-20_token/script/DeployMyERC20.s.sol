// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/MyERC20.sol";

contract DeployMyToken is Script {
    function run() external returns(MyERC20) {
        uint256 initialSupply = 1_000_000 * 10 ** 18;
        vm.startBroadcast();
        MyERC20 erc20 = new MyERC20(initialSupply);
        vm.stopBroadcast();
        return erc20;
    }
}
