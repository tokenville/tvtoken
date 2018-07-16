'use strict';

const RATE = "500";

const TVCrowdsale = artifacts.require("./TVCrowdsale.sol");
const TVToken = artifacts.require("./TVToken.sol");

module.exports = function(deployer, network, accounts) {
  let wallet = accounts[0];
  return deployer.deploy(TVCrowdsale, RATE, process.env.WALLET || wallet, TVToken.address, wallet);
};
