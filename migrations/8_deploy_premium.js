'use strict';

const TVPremium = artifacts.require("./TVPremium.sol");
const TVToken = require('../../tvtoken/build/contracts/TVToken.json');
const TVCrowdsale = require('../../tvtoken/build/contracts/TVCrowdsale.json');
const TVCoupon = require('../../tvtoken/build/contracts/TVCoupon.json');


const conf = {
  'development': {
    WALLET: '0x8BD8B687b5FF6bb5cFf14BF57566b80061c0b945',
    MANAGER: '0x340A4E26B5bA8ac4f9518A29E189F7b26F40F852',
    TV_CROWDSALE: TVCrowdsale.networks['5777'] && TVCrowdsale.networks['5777'].address || '',
    TV_TOKEN: TVToken.networks['5777'] && TVToken.networks['5777'].address || '',
    TV_COUPON: TVCoupon.networks['5777'] && TVCoupon.networks['5777'].address || '',
    DISCOUNT_PERCENTAGE: 50
  },
  'ropsten': {
    WALLET: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    TV_CROWDSALE: TVCrowdsale.networks['3'] && TVCrowdsale.networks['3'].address || '',
    TV_TOKEN: TVToken.networks['3'] && TVToken.networks['3'].address || '',
    TV_COUPON: TVCoupon.networks['3'] && TVCoupon.networks['3'].address || '',
    DISCOUNT_PERCENTAGE: 50
  },
  'kovan': {
    WALLET: '0x718918c59Ae96489abA51981970E4FaD30c13911',
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    TV_CROWDSALE: TVCrowdsale.networks['42'] && TVCrowdsale.networks['42'].address || '',
    TV_TOKEN: TVToken.networks['42'] && TVToken.networks['42'].address || '',
    TV_COUPON: TVCoupon.networks['42'] && TVCoupon.networks['42'].address || '',
    DISCOUNT_PERCENTAGE: 50
  },
  'mainnet': {
    MANAGER: '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8',
    TV_TOKEN: '0xf3e693175db47264c99eca0f1c1c4a2c1aed3bd7',
    TV_CROWDSALE: '0xaae1be740222fb3f1125a7326fce947bbdb62b7e',
    WALLET: '',
    TV_COUPON: '',
    DISCOUNT_PERCENTAGE: 50
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.TV_TOKEN && params.TV_CROWDSALE && params.TV_COUPON &&
    params.MANAGER && params.WALLET && params.DISCOUNT_PERCENTAGE;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVPremium,
      params.TV_TOKEN,
      params.TV_CROWDSALE,
      params.TV_COUPON,
      params.MANAGER,
      params.DISCOUNT_PERCENTAGE,
      params.WALLET
    );
  }
  params.TV_TOKEN || console.error('TV_TOKEN is undefined.');
  params.TV_CROWDSALE || console.error('TV_CROWDSALE is undefined.');
  params.MANAGER || console.error('MANAGER is undefined.');
  params.WALLET || console.error('WALLET is undefined.');
  params.DISCOUNT_PERCENTAGE || console.error('DISCOUNT_PERCENTAGE is undefined.');
  params.TV_COUPON || console.error('TV_COUPON is undefined.');
};
