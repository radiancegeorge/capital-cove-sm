const baseContract = artifacts.require("GenerateCoupon");

module.exports = (deployer) => {
  deployer.deploy(baseContract);
};
