'use strict';

const TVPremium = artifacts.require("./TVPremium.sol");
const TVCrowdsale = artifacts.require('./TVCrowdsale.sol');
const TVCoupon = artifacts.require("./TVCoupon.sol");
const TVToken = artifacts.require("./TVToken.sol");


const conf = {
  'development': {
    WALLET: '0x8BD8B687b5FF6bb5cFf14BF57566b80061c0b945',
    MANAGER: '0x340A4E26B5bA8ac4f9518A29E189F7b26F40F852',
    DISCOUNT_PERCENTAGE: 50
  },
  'ropsten': {
    WALLET: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    DISCOUNT_PERCENTAGE: 50
  },
  'kovan': {
    WALLET: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    DISCOUNT_PERCENTAGE: 50
  },
  'mainnet': {
    MANAGER: '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8',
    WALLET: '0xb8579B19DA2108249D4391d73430ABba665515ca',
    DISCOUNT_PERCENTAGE: 50
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.MANAGER && params.WALLET && params.DISCOUNT_PERCENTAGE;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVPremium,
      TVToken.address,
      TVCrowdsale.address,
      TVCoupon.address,
      params.MANAGER,
      params.DISCOUNT_PERCENTAGE,
      params.WALLET
    );
  }
  params.MANAGER || console.error('MANAGER is undefined.');
  params.WALLET || console.error('WALLET is undefined.');
  params.DISCOUNT_PERCENTAGE || console.error('DISCOUNT_PERCENTAGE is undefined.');
};
