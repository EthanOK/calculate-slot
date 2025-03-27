```solidity
contract Counter {
    uint256 public number; // slot 0

    mapping(address => uint256) public balanceOf; // slot 1

    mapping(string => uint256) public tokenTypes; // slot 2
}

```

## mapping slot

对应于映射键 k 的值位于 keccak256(h(k) . p)， 其中 . 是连接符， h 是一个函数，根据键的类型应用于键。

- 对于值类型， 函数 h 将与在内存中存储值的相同方式来将值填充为 32 字节。

```solidity
// balanceOf key is address type
bytes32 balanceOf_slot = 1;

address key_address = 0x1234567890123456789012345678901234567890;
// 将键 address 填充为 32 字节
bytes32 balanceOf_key_slot = keccak256(abi.encode(key_address, balanceOf_slot));

```

- 对于字符串和字节数组， h(k) 只是未填充的数据。

```solidity
// tokenTypes key is string type
bytes32 tokenTypes_slot = 2;

string key_string = "USDT";

bytes32 tokenTypes_key_slot = keccak256(abi.encodePacked(key_string, tokenTypes_slot));

```
