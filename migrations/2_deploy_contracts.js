// const Token = artifacts.require("Token");
// const TokenXUSD = artifacts.require("TokenXUSD");
// const Airdropper = artifacts.require("Airdropper");
const Presale = artifacts.require("Presale");
// const Pool = artifacts.require("Pool");


module.exports = async function(deployer) {
 // await deployer.deploy(Token);
 // await Token.deployed();
 // await deployer.deploy(TokenXUSD);
 // await TokenXUSD.deployed();
 // await deployer.deploy(Airdropper);
 // await Airdropper.deployed();
 await deployer.deploy(Presale);
 await Presale.deployed();
 // await deployer.deploy(Pool);
 // await Pool.deployed();
};
