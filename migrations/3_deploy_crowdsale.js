'use strict';

const RATE = "2000000000000000";

const TVCrowdsale = artifacts.require("./TVCrowdsale.sol");
const TVToken = artifacts.require("./TVToken.sol");

module.exports = function(deployer, network, accounts) {
  let wallet = accounts[0];
  return deployer.deploy(TVCrowdsale, RATE, wallet, TVToken.address, wallet);
};
