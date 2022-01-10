// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20, Ownable {
    using SafeMath for uint256;
    uint BURN_FEE = 1;
    uint DEV_FEE = 1;
    // uint LIQUIDITY_FEE = 1;
    // uint REFLECTION_FEE = 1;
    // address public router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // pancakeswap.finance (BSC Mainnet)
    // address public router = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3; // pancake.kiemtienonline360.com (BSC Testnet)
    // address public router = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; // quickswap.exchange (Polygon Mainnet)
    address public devAddress;
    mapping(address => bool) public excludedFromTax;

    constructor() ERC20("Tax Token", "TAX") {
        uint256 supply = 1000000000;
        uint8 decimals = 18;
        _mint(msg.sender, supply * 10**decimals);
        devAddress = msg.sender;
        setTaxExclusion(msg.sender, true);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] == true) {
            // TODO: now it's excluded only when sending TO such address - also make it FROM such address
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint burnAmount = amount * BURN_FEE / 100;
            uint devAmount = amount * DEV_FEE / 100;
            // uint liquidityAmount = amount * LIQUIDITY_FEE / 100;
            //TODO: REFLECTION FEE
            //TODO: LIQUIDITY FEE (somehow get LP pair contract from router contract address - send there liquidityAmount)
            _burn(_msgSender(), burnAmount);
            _transfer(_msgSender(), devAddress, devAmount);
            _transfer(_msgSender(), recipient, amount - burnAmount - devAmount);
            // - liquidityAmount);
        }
        return true;
    }

    function setTaxExclusion(address excludedAddress, bool excluded) public onlyOwner {
        excludedFromTax[excludedAddress] = excluded;
    }
}
