// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20, Ownable {
    using SafeMath for uint256;
    uint BURN_FEE = 1;
    uint OWNER_FEE = 2;
    uint LIQUIDITY_FEE = 3;
    uint REFLECTION_FEE = 4;
    // address public router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // pancakeswap.finance (BSC Mainnet)
    //address public router = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3; // pancake.kiemtienonline360.com (BSC Testnet)
    // address public router = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; // quickswap.exchange (Polygon Mainnet)
    address public ownerAddress;
    mapping(address => bool) public excludedFromTax;

    constructor() ERC20("Tax Token", "TAX") {
        uint256 supply = 1000000000;
        uint8 decimals = 18;
        _mint(msg.sender, supply * 10**decimals);
        ownerAddress = msg.sender;
        setTaxExclusion(msg.sender, true);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] == true) {
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint burnAmount = amount.mul(BURN_FEE) / 100;
            uint ownerAmount = amount.mul(OWNER_FEE) / 100;
            uint liquidityAmount = amount.mul(LIQUIDITY_FEE) / 100;
            //TODO: REFLECTION FEE
            //TODO: LIQUIDITY FEE (somehow get LP pair contract from router contract address - send there liquidityAmount)
            _burn(_msgSender(), burnAmount);
            _transfer(_msgSender(), ownerAddress, ownerAmount);
            _transfer(_msgSender(), recipient, amount.sub(burnAmount).sub(ownerAmount).sub(liquidityAmount));
        }
        return true;
    }

    function setTaxExclusion(address excludedAddress, bool excluded) public onlyOwner {
        excludedFromTax[excludedAddress] = excluded;
    }
}
