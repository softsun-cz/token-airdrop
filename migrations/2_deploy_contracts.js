const Token = artifacts.require('Token');
const TokenXUSD = artifacts.require('TokenXUSD');
const Airdrop = artifacts.require('Airdrop');
const Presale = artifacts.require('Presale');
const Pool = artifacts.require('Pool');
const Dice = artifacts.require('Dice');

module.exports = async function(deployer) {
 const token = {address: '0xAD531A13b61E6Caf50caCdcEebEbFA8E6F5Cbc4D'};
 const tokenUSD = {address: '0xF42a4429F107bD120C5E42E069FDad0AC625F615'};
 // const router = '0x10ED43C718714eb63d5aA57B78B54704E256024E'; // pancakeswap.finance (BSC Mainnet)
 // const router = '0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3'; // pancake.kiemtienonline360.com (BSC Testnet)
 // const router = '0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff'; // quickswap.exchange (Polygon Mainnet)
 const router = '0x8954AfA98594b838bda56FE4C12a09D7739D179b'; // quickswap.exchange (Polygon Testnet)
 const dev = '0x650E5c6071f31065d7d5Bf6CaD5173819cA72c41';
 const airdropAmount = '1000000000000000000'; // 1
 const presalePricePresale = '1000000000000000000'; // 1
 const presalePriceLiquidity = '2000000000000000000'; // 2
 const presaleDepositTime = '600';
 const presaleClaimTime = '900';
 const poolTokensPerBlock = '100000000000000000'; // 0.1

 // const tokenSupply = 1000000;
 // const tokenDecimals = 18;
 // const tokenName = 'Test token';
 // const tokenSymbol = 'TEST';
 // const tokenDevFee = 1;
 // const tokenBurnFee = 2;
 // await deployer.deploy(Token, tokenSupply, tokenDecimals, tokenName, tokenSymbol, tokenDevFee, tokenBurnFee);
 // const token = await Token.deployed();

 // TODO: MOVE XUSD TOKEN TO STANDALONE PROJECT
 // await deployer.deploy(TokenXUSD);
 // const tokenUSD = await TokenXUSD.deployed();

 await deployer.deploy(Airdrop, token.address, airdropAmount);
 const airdrop = await Airdrop.deployed();
 await deployer.deploy(Presale, token.address, tokenUSD.address, router, dev, presalePricePresale, presalePriceLiquidity, presaleDepositTime, presaleClaimTime);
 const presale = await Presale.deployed();
 await deployer.deploy(Pool, token.address, poolTokensPerBlock);
 const pool = await Pool.deployed();

 // TODO: MOVE DICE TO STANDALONE PROJECT (CASINO?)
 // const diceMinBet = '1000000000000000000';
 // const diceMaxBet = '100000000000000000000';
 // const diceFeePercent = '3';
 // await deployer.deploy(Dice, token.address, dev, diceMinBet, diceMaxBet, diceFeePercent);
 // const dice = await Dice.deployed();

 airdrop.start(300);

 // TODO: ADD TAX EXCEPTION ADDRESSES
 // TODO: token.transfer WORKS ONLY IF I DEPLOY A NEW TOKEN, NOT WITH JUST ADDRESS
 // token.transfer(presale.address, '500000000000000000000000'); // 500 000
 // token.transfer(airdrop.address, '250000000000000000000000'); // 250 000
 // token.transfer(pool.address, '250000000000000000000000'); // 250 000
};
