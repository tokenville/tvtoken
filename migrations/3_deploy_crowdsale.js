'use strict';

const TVCrowdsale = artifacts.require("./TVCrowdsale.sol");
const TVToken = artifacts.require("./TVToken.sol");

module.exports = function(deployer, network, accounts) {
  let wallet = accounts[0];
  return deployer.deploy(TVCrowdsale, "2000000000000000", "0x20AC118ef91569f33Ba81D4AA6ea8f0E0f855a21", TVToken.address, wallet);
};
