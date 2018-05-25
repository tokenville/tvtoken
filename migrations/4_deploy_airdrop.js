'use strict';
const TVAirDrop = artifacts.require("./TVAirDrop.sol");
const TVToken = artifacts.require("./TVToken.sol");
const DEUS_TO_TVT_RATE = {
  'ropsten': 300,
  'mainnet': null
};
const deusToken = {
  'ropsten': '0x28a6fe39463ceaaa714da8270f7eb95b8505fccd',
  'mainnet': ''
};

module.exports = function(deployer, network, accounts) {
  if (deusToken[network] && accounts[0]) {
    console.log('Owner address: ' + accounts[0]);
    return deployer.deploy(TVAirDrop, deusToken[network], TVToken.address, accounts[0], DEUS_TO_TVT_RATE[network]);
  } else {
    deusToken[network] && console.error('DeusToken address is undefined.');
    accounts[0] && console.error('Owner address is undefined.');
    DEUS_TO_TVT_RATE[network] && console.error('DEUS_TO_TVT_RATE is undefined.');
  }
};
