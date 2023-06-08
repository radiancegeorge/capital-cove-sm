const token = artifacts.require("Token");
// const { default: Web3 } = require("web3");
const web3 = require("web3");
module.exports = (deployer) => {
  deployer.deploy(token, web3.utils.toWei("10000000"));
};
