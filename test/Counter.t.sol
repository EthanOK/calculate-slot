// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    // 0x000000000000000000000000000000000000ABcD
    address public user = address(0xabcd);
    string USDT_NAME = "USDT";

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);

        vm.deal(user, 100 ether);
        vm.startPrank(user);
        counter.deposit{value: 1 ether}();
        vm.stopPrank();
    }

    function test_Increment() public {
        counter.increment();

        bytes32 slot_number = bytes32(uint256(0));
        printSlot(address(counter), slot_number);

        bytes32 slot_balanceOf = bytes32(uint256(1));
        // cast index address 0x000000000000000000000000000000000000ABcD 1
        // 0xa565e321bb2a38869f5e62291a0467f14d8e98f50311f06944f84dac05e02ea3
        bytes32 slot_balanceOf_user = calculateKeySlot(addressToBytes32(user), slot_balanceOf);

        printSlot(address(counter), slot_balanceOf_user);

        // console.log("tokenTypes[USDT]: ", uint256(counter.tokenTypes("USDT")));

        bytes32 slot_tokenTypes = bytes32(uint256(2));
        // cast index string USDT 2
        // 0x5b917b37580ae119971a3168e4741c39db3465a69b528cb37ad7d49de50be608
        bytes32 slot_tokenTypes_USDT = calculateStringKeySlot(USDT_NAME, slot_tokenTypes);
        printSlot(address(counter), slot_tokenTypes_USDT);

        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function test_Calculate_ArraySlot() public view {
        uint256 index_ = 1;
        uint256 tokenId_index = counter.tokenIds(index_);
        //  uint256[] public tokenIds; // slot 3
        bytes32 slot_tokenId_index = add_bytes32((keccak256(abi.encode(3))), bytes32(index_));
        bytes32 value_tokenId_index = printSlot(address(counter), slot_tokenId_index);
        assertEq(tokenId_index, uint256(value_tokenId_index));
    }

    function printSlot(address addr, bytes32 slot) internal view returns (bytes32) {
        /// Loads a storage slot from an address.
        /// function load(address target, bytes32 slot) external view returns (bytes32 data);

        bytes32 value = vm.load(addr, slot);
        console.log("bytes32 slot:");
        console.logBytes32(slot);
        console.log("uint256 value:");
        console.log(uint256(value));
        return value;
    }

    function calculateKeySlot(bytes32 key, bytes32 slot_map) internal pure returns (bytes32) {
        return keccak256(abi.encode(key, slot_map));
    }

    function calculateStringKeySlot(string memory key, bytes32 slot_map) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(key, slot_map));
    }

    function addressToBytes32(address addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }

    function add_bytes32(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return bytes32(uint256(a) + uint256(b));
    }
}
