// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Extsload} from "./Extsload.sol";

contract Counter is Extsload {
    uint256 public number; // slot 0

    mapping(address => uint256) public balanceOf; // slot 1

    mapping(string => uint256) public tokenTypes; // slot 2

    uint256[] public tokenIds; // slot 3

    constructor() {
        tokenTypes["ETH"] = 0;
        tokenTypes["USDC"] = 1111;
        tokenTypes["USDT"] = 2222;

        tokenIds.push(100);
        tokenIds.push(200);
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
