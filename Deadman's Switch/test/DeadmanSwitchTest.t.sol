// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Test, console} from "forge-std/Test.sol";
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

    function testWithdrawByOwner() public {
        vm.startPrank(owner);

        uint256 initialContractBalance = address(deadmanswitch).balance;
        assertEq(initialContractBalance, 1 ether);

        uint256 initialOwnerBalance = owner.balance;
        deadmanswitch.withdraw(0.5 ether);

        uint256 finalContractBalance = address(deadmanswitch).balance;
        uint256 finalOwnerBalance = owner.balance;

        assertEq(finalContractBalance, initialContractBalance - 0.5 ether);
        assertEq(finalOwnerBalance, initialOwnerBalance + 0.5 ether);

        vm.stopPrank();
    }

    function testCannotWithdrawByNonOwner() public {
        vm.expectRevert("Not the owner");
        deadmanswitch.withdraw(0.5 ether);
    }

    function testCannotTriggerBeforeTimeout() public {
        vm.expectRevert("Owner is still active");
        deadmanswitch.check_Inactive();
    }
}
