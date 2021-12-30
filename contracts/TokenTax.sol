// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenTax is ERC20 {
    using SafeMath for uint256;
    uint BURN_FEE = 5;
    uint TAX_FEE = 5;
    address public owner;
    mapping(address => bool) public excludedFromTax;

    constructor() ERC20("Tax Token", "TAX") {
        uint256 supply = 1000000000;
        uint8 decimals = 18;
        _mint(msg.sender, supply * 10**decimals);
        owner = msg.sender;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender]) {
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint burnAmount = amount.mul(BURN_FEE) / 100;
            uint adminAmount = amount.mul(TAX_FEE) / 100;
            _burn(_msgSender(), burnAmount);
            _transfer(_msgSender(), owner, adminAmount);
            _transfer(_msgSender(), recipient, amount.sub(burnAmount).sub(adminAmount));
        }
        return true;
    }
}
