// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory name, string memory symbol, uint256 supply, uint8 decimals) ERC20(name, symbol) {
        _mint(msg.sender, supply**decimals);
    }
}
