'use strict';

const TVComics = artifacts.require("./TVComics.sol");
const TVToken = require('../../tvtoken/build/contracts/TVToken.json');
const TVCrowdsale = require('../../tvtoken/build/contracts/TVCrowdsale.json');


const conf = {
  'development': {
    WALLET: '0x8BD8B687b5FF6bb5cFf14BF57566b80061c0b945',
    MANAGER: '0x340A4E26B5bA8ac4f9518A29E189F7b26F40F852',
    TV_CROWDSALE: TVCrowdsale.networks['5777'] && TVCrowdsale.networks['5777'].address || '',
    TV_TOKEN: TVToken.networks['5777'] && TVToken.networks['5777'].address || ''
  },
  'ropsten': {
    WALLET: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    TV_CROWDSALE: TVCrowdsale.networks['3'] && TVCrowdsale.networks['3'].address || '',
    TV_TOKEN: TVToken.networks['3'] && TVToken.networks['3'].address || ''
  },
  'kovan': {
    WALLET: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    TV_CROWDSALE: TVCrowdsale.networks['42'] && TVCrowdsale.networks['42'].address || '',
    TV_TOKEN: TVToken.networks['42'] && TVToken.networks['42'].address || ''
  },
  'mainnet': {
    MANAGER: '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8'
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.TV_TOKEN && params.TV_CROWDSALE && params.MANAGER && params.WALLET;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVComics,
      params.TV_TOKEN,
      params.TV_CROWDSALE,
      params.MANAGER,
      params.WALLET
    );
  }
  params.TV_TOKEN || console.error('TV_TOKEN is undefined.');
  params.TV_CROWDSALE || console.error('TV_CROWDSALE is undefined.');
  params.MANAGER || console.error('MANAGER is undefined.');
  params.WALLET || console.error('WALLET is undefined.');
};
