// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script} from "forge-std/Script.sol";
import {DeadmanSwitch} from "../src/DeadmanSwitch.sol";

contract DeployDeadmanSwitch is Script {
    function run() external returns (DeadmanSwitch) {
        vm.startBroadcast();
        DeadmanSwitch deadmanSwitch = new DeadmanSwitch(
            0x6320EF6d165c1bD287F934F5570fF9803505963f // recipient
        );
        vm.stopBroadcast();
        return deadmanSwitch;
    }
}
