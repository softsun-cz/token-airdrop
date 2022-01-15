// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20, Ownable {
    uint256 public burnFee = 1;
    uint256 public devFee = 1;
    address public devAddress;
    mapping(address => bool) public excludedFromTax;

    constructor(uint256 _supply, uint256 _decimals, string _name, string _symbol, uint256 _devFee, uint256 _burnFee) ERC20(_name, _symbol) {
        burnFee = _burnFee;
        devFee = _devFee;
        _mint(msg.sender, _supply * 10**_decimals);
        devAddress = msg.sender;
        setTaxExclusion(msg.sender, true);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] == true) {
            // TODO: now it's excluded only when sending TO such address - also make it FROM such address
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint burnAmount = amount * burnFee / 100;
            uint devAmount = amount * devFee / 100;
            _transfer(_msgSender(), 0x000000000000000000000000000000000000dEaD, burnAmount);
            _transfer(_msgSender(), devAddress, devAmount);
            _transfer(_msgSender(), recipient, amount - burnAmount - devAmount);
        }
        return true;
    }

    function setTaxExclusion(address excludedAddress, bool excluded) public onlyOwner {
        excludedFromTax[excludedAddress] = excluded;
    }
}
