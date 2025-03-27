// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    mapping(address => uint256) public balanceOf;

    mapping(string => uint256) public tokenTypes;

    constructor() {
        tokenTypes["ETH"] = 0;
        tokenTypes["USDC"] = 1111;
        tokenTypes["USDT"] = 2222;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
