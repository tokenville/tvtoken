'use strict';
const TVAirDrop = artifacts.require("./TVAirDrop.sol");
const TVToken = artifacts.require("./TVToken.sol");
const DEUS_TO_TVT_RATE = '300';
const deusToken = {
  'ropsten': '0xa9c5350921fbd899e62847e7b79f0f156e8b3a4a',
  'mainnet': ''
};

module.exports = function(deployer, network, accounts) {
  if (deusToken[network] && accounts[0]) {
    console.log('Owner address: ' + accounts[0]);
    return deployer.deploy(TVAirDrop, deusToken[network], TVToken.address, accounts[0], DEUS_TO_TVT_RATE);
  } else {
    deusToken[network] && console.error('DeusToken address is undefined.');
    accounts[0] && console.error('Owner address is undefined.')
  }
};
