const token = artifacts.require("Token");
const Contract = artifacts.require("GenerateCoupon");
const web3 = require("web3");
// const { default: Web3 } = require("web3");
const { assert, expect } = require("chai");

contract("basic behavioral test", async (account) => {
  const ngnRate = "500";
  it("should set usdtNgnRate", async () => {
    const contractInstance = await Contract.deployed();
    await contractInstance.setUSDNGNRate(ngnRate);
    const rate = await contractInstance.USDNGN();
    assert.equal(rate, ngnRate);
  });

  it("should add a supported token", async () => {
    const contractInstance = await Contract.deployed();
    const tokenInstance = await token.deployed();
    await contractInstance.setUsdtTokenAddress(tokenInstance.address);
    const usdt = await contractInstance.USDT();
    assert.equal(tokenInstance.address, usdt);
  });

  it("create a plan", async () => {
    const contractInstance = await Contract.deployed();
    const planNameString = "Rookie";
    const planName = web3.utils.asciiToHex(planNameString);
    // const planPrice = web3.utils.toWei("10000");
    const planPrice = 10000;
    const planId = 1;
    await contractInstance.createPlan(planId, planName, planPrice);
    const plan = await contractInstance.getSinglePlan(planId);
    assert.equal(
      planNameString,
      web3.utils.hexToAscii(plan.name).replace(/\u0000/g, "")
    );
    assert.equal(planPrice, plan.price);
  });

  it("paying for plan", async () => {
    const tokenInstance = await token.deployed();
    const contractInstance = await Contract.deployed();
    await tokenInstance.approve(
      contractInstance.address,
      web3.utils.toWei("100000")
    );
    const email = web3.utils.asciiToHex("radiancegeorge@gmail.com");
    const planId = 1;
    const balance = web3.utils.fromWei(
      await tokenInstance.balanceOf(account[0])
    );
    const amountSupposedToCharge = (
      await contractInstance.getSinglePlan(planId)
    ).price;

    const amountSupposedToChargeToUsd =
      Number(amountSupposedToCharge) / Number(ngnRate);
    const expectedBalance = balance - amountSupposedToChargeToUsd;

    await contractInstance.payForPlan(email, planId);
    const newBalance = web3.utils.fromWei(
      await tokenInstance.balanceOf(account[0])
    );

    assert.equal(expectedBalance, newBalance);
  });

  it("payout", async () => {
    const tokenInstance = await token.deployed();
    const contractInstance = await Contract.deployed();
    const planId = 1;
    await tokenInstance.transfer(
      contractInstance.address,
      web3.utils.toWei("10")
    );

    const balance = web3.utils.fromWei(
      await tokenInstance.balanceOf(account[1])
    );

    await contractInstance.payout([{ _address: account[1], plan: planId }]);
    const newBalance = web3.utils.fromWei(
      await tokenInstance.balanceOf(account[1])
    );

    console.log(
      web3.utils.fromWei(
        await tokenInstance.balanceOf(contractInstance.address)
      ),
      "balance in contract"
    );

    expect(Number(newBalance)).to.be.greaterThan(Number(balance));
    // console.log(newBalance);
  });
});
