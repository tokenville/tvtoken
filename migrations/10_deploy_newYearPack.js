'use strict';

const TVNewYearPack = artifacts.require("./TVNewYearPack.sol");


const conf = {
  'development': {
    MANAGER: '0x340A4E26B5bA8ac4f9518A29E189F7b26F40F852',
    TYPES_COUNT: 5

  },
  'ropsten': {
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    TYPES_COUNT: 5
  },
  'kovan': {
    MANAGER: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096',
    TYPES_COUNT: 5
  },
  'mainnet': {
    MANAGER: '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8',
    TYPES_COUNT: 0
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.MANAGER && params.TYPES_COUNT;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVNewYearPack,
      params.TYPES_COUNT,
      params.MANAGER
    );
  }
  params.MANAGER || console.error('MANAGER is undefined.');
  params.TYPES_COUNT || console.error('TYPES_COUNT is undefined.');
};
