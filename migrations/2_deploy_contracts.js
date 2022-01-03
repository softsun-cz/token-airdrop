const Token = artifacts.require("Token");
const Airdropper = artifacts.require("Airdropper");
const Presale = artifacts.require("Presale");

module.exports = async function(deployer) {
  await deployer.deploy(Token);
  await Token.deployed();
  // await deployer.deploy(Airdropper);
  // await Airdropper.deployed();
  // await deployer.deploy(Presale);
};
