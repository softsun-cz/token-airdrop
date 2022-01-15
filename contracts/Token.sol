// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20, Ownable {
    uint256 public burnFee = 1;
    uint256 public devFee = 1;
    address public devAddress;
    mapping(address => bool) public excludedFromTax;

    constructor(string memory _name, string memory _symbol, uint256 _supply, uint256 _decimals, uint256 _devFee, uint256 _burnFee) ERC20(_name, _symbol) {
        _mint(msg.sender, _supply * 10**_decimals);
        burnFee = _burnFee;
        devFee = _devFee;
        devAddress = msg.sender;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] || excludedFromTax[recipient]) {
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

    function setDevAddress(address _devAddress) public onlyOwner {
        devAddress = _devAddress;
    }

    function setTaxExclusion(address _excludedAddress, bool _excluded) public onlyOwner {
        excludedFromTax[_excludedAddress] = _excluded;
    }
}
