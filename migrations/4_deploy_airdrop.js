'use strict';
const TVAirDrop = artifacts.require("./TVAirDrop.sol");
const TVToken = artifacts.require("./TVToken.sol");
const deusToken = '0x46Eb72F2501795e2D3a3C27102b16CcB64D6B0fC';
const DEUS_TO_TVT_RATE = '300';

module.exports = function(deployer, network, accounts) {
  return deployer.deploy(TVAirDrop, deusToken, TVToken.address, DEUS_TO_TVT_RATE);
};
