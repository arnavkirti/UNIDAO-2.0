// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DeadmanSwitch {
    address public owner;
    address public recipient;
    uint256 public lastBlockAlive;

    constructor(address _recipient) payable {
        owner = msg.sender;
        recipient = _recipient;
        lastBlockAlive = block.number;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert("Not the owner");
        }
        _;
    }

    function stillAlive() external onlyOwner {
        lastBlockAlive = block.number;
    }

    function check_Inactive() external {
        if (block.number <= lastBlockAlive + 10) {
            revert("Owner is still active");
        }
        _transferBalance();
    }

    function _transferBalance() internal {
        payable(recipient).transfer(address(this).balance);
    }

    function withdraw(uint256 amount) external onlyOwner {
        if (amount >= address(this).balance) {
            revert("Insufficient balance");
        }
        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert("Transfer Failed");
        }
    }

    receive() external payable {}
}
