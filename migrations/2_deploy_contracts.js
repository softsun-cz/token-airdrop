const Token = artifacts.require("Token");
const Airdropper = artifacts.require("Airdropper");

module.exports = async function(deployer) {
  await deployer.deploy(Token);
  await Token.deployed();
  await deployer.deploy(Airdropper);
};
