'use strict';

const TVArtWork = artifacts.require("./TVArtWork.sol");
const TVToken = artifacts.require('./TVToken.sol');
const TVCrowdsale = artifacts.require('./TVCrowdsale.sol');


const conf = {
  'development': {
    HOLDER: '0x8BD8B687b5FF6bb5cFf14BF57566b80061c0b945',
    MANAGER: '0x340A4E26B5bA8ac4f9518A29E189F7b26F40F852',
    PRICE: 50000000000000000000
  },
  'ropsten': {
    HOLDER: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    PRICE: 50000000000000000000
  },
  'kovan': {
    HOLDER: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    PRICE: 50000000000000000000
  },
  'mainnet': {
    MANAGER: '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8',
    HOLDER: '0xb8579B19DA2108249D4391d73430ABba665515ca',
    PRICE: 50000000000000000000
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.MANAGER && params.HOLDER && params.PRICE;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVArtWork,
      TVToken.address,
      TVCrowdsale.address,
      params.MANAGER,
      params.PRICE,
      params.HOLDER
    );
  }
  params.MANAGER || console.error('MANAGER is undefined.');
  params.HOLDER || console.error('HOLDER is undefined.');
  params.PRICE || console.error('PRICE is undefined.');
};
