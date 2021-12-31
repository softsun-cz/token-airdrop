// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    // constructor(string memory name, string memory symbol, uint256 supply, uint8 decimals) ERC20(name, symbol) {
    constructor() ERC20("Test Token", "TOK") {
        uint256 supply = 1000000000;
        uint8 decimals = 18;
        _mint(msg.sender, supply * 10**decimals);
    }
}
