// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenTax is ERC20 {
    using SafeMath for uint256;
    uint BURN_FEE = 1;
    uint OWNER_FEE = 2;
    uint LIQUIDITY_FEE = 3;
    uint REDISTRIBUTION_FEE = 4;
    // address public router = "0x10ED43C718714eb63d5aA57B78B54704E256024E"; // pancakeswap.finance (BSC Mainnet)
    address public router = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"; // pancake.kiemtienonline360.com (BSC Testnet)
    // address public router = "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff"; // quickswap.exchange (Polygon Mainnet)
    address public owner;
    mapping(address => bool) public excludedFromTax;

    constructor() ERC20("Tax Token", "TAX") {
        uint256 supply = 1000000000;
        uint8 decimals = 18;
        _mint(msg.sender, supply * 10**decimals);
        owner = msg.sender;
        setTaxExclusion(msg.sender);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] == true) {
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint burnAmount = amount.mul(BURN_FEE) / 100;
            uint ownerAmount = amount.mul(OWNER_FEE) / 100;
            uint liquidityAmount = amount.mul(LIQUIDITY_FEE) / 100;
            //TODO: REDISTRIBUTION FEE
            _burn(_msgSender(), burnAmount);
            _transfer(_msgSender(), owner, ownerAmount);
            _transfer(_msgSender(), router, liquidityAmount);
            _transfer(_msgSender(), recipient, amount.sub(burnAmount).sub(ownerAmount).sub(liquidityAmount));
        }
        return true;
    }

    function setTaxExclusion(address excludedAddress, bool excluded) public onlyOwner {
        excludedFromTax[excludedAddress] = excluded;
    }
}
