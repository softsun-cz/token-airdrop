// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20, Ownable {
    uint256 public burnFee = 1;
    uint256 public devFee = 1;
    address public devAddress;
    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    mapping(address => bool) public excludedFromTax;

    constructor(string memory _name, string memory _symbol, uint256 _supply, uint256 _decimals, uint256 _devFee, uint256 _burnFee) ERC20(_name, _symbol) {
        _mint(msg.sender, _supply * 10**_decimals);
        burnFee = _burnFee;
        devFee = _devFee;
        devAddress = msg.sender;
        excludedFromTax[msg.sender] = true;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] || excludedFromTax[recipient] || recipient == burnAddress) {
            _transfer(_msgSender(), recipient, amount);
        } else {
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
}

/* Liquidity tax example - line 1495 - https://testnet.bscscan.com/address/0x7ba7eed2c4426831d669586d3d611df6fe9d96bc#code

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        // split the contract balance into halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to uniswap
        addLiquidity(otherHalf, newBalance);

        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    */