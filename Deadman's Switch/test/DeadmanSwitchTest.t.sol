// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Test} from "forge-std/Test.sol";
import {DeadmanSwitch} from "../src/DeadmanSwitch.sol";

contract DeadmanSwitchTest is Test {
    DeadmanSwitch public deadmanswitch;
    address public owner = address(0x1);
    address public recipient = address(0x2);

    function setUp() public {
        vm.deal(owner, 10 ether);
        vm.startPrank(owner);
        deadmanswitch = new DeadmanSwitch{value: 1 ether}(recipient);
        vm.stopPrank();
    }

    function testStillAliveUpdatesLastBlockAlive() public {
        vm.startPrank(owner);
        uint256 initialBlock = deadmanswitch.lastBlockAlive();
        vm.roll(block.number + 1);
        deadmanswitch.stillAlive();
        assertEq(deadmanswitch.lastBlockAlive(), block.number);
        vm.stopPrank();
    }

    function testCheckInactiveTransferBalance() public {
        vm.roll(block.number + 11);
        uint256 initialBalance = recipient.balance;

        vm.prank(address(0x3));
        deadmanswitch.check_Inactive();

        assertEq(recipient.balance, initialBalance + 1 ether);
    }


}