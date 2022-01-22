// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './libs/IUniswapV2Router.sol';
import './libs/IUniswapV2Factory.sol';

contract Token is ERC20, Ownable {
    uint256 public burnFee;
    uint256 public devFee;
    address public devAddress;
    address public routerAddress;
    address public usdAddress;
    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    address public zeroAddress = 0x0000000000000000000000000000000000000000;
    mapping(address => bool) public excludedFromTax;

    constructor(string memory _name, string memory _symbol, uint256 _supply, uint256 _decimals, uint256 _devFee, uint256 _burnFee, address _routerAddress, address _usdAddress) ERC20(_name, _symbol) {
        _mint(msg.sender, _supply * 10**_decimals);
        burnFee = _burnFee;
        devFee = _devFee;
        routerAddress = _routerAddress;
        usdAddress = _usdAddress;
        devAddress = msg.sender;
        excludedFromTax[msg.sender] = true;
        address factory = IUniswapV2Router(routerAddress).factory();
        IUniswapV2Factory(factory).createPair(address(this), address(usdAddress));
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] || excludedFromTax[recipient] || recipient == burnAddress) _transfer(_msgSender(), recipient, amount);
        else {
            uint burnAmount = amount * burnFee / 100;
            uint devAmount = amount * devFee / 100;
            _transfer(_msgSender(), burnAddress, burnAmount);
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

    function getPairAddress() public view returns (address) {
        address factory = IUniswapV2Router(routerAddress).factory();
        return IUniswapV2Factory(factory).getPair(address(this), address(usdAddress));
    }
}
