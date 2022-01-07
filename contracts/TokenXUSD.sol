// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract TokenXUSD is ERC20 {
    constructor() ERC20("XUSD Token", "XUSD") {
        uint256 supply = 1000000000000;
        uint8 decimals = 18;
        _mint(msg.sender, supply * 10**decimals);
    }
}
