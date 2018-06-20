'use strict';
const TVAirDrop = artifacts.require("./TVAirDrop.sol");
const TVToken = artifacts.require("./TVToken.sol");

const conf = {
  'development': {
    DEUS_TO_TV_RATE: 300,
    DEUS_TOKEN: '0x28a6fe39463ceaaa714da8270f7eb95b8505fccd',
    HOLDER_ADDRESS: '0xA720f241d13F2AE8ACffa45cbcDBe3879276A6a3'
  },
  'ropsten': {
    DEUS_TO_TV_RATE: 300,
    DEUS_TOKEN: '0x28a6fe39463ceaaa714da8270f7eb95b8505fccd',
    HOLDER_ADDRESS: '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8'
  },
  'mainnet': {
    DEUS_TO_TV_RATE: null,
    DEUS_TOKEN: '',
    HOLDER_ADDRESS: ''
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.DEUS_TO_TV_RATE && params.DEUS_TOKEN && params.HOLDER_ADDRESS;
  if (allParamsSet)  {
    return deployer.deploy(
      TVAirDrop,
      TVToken.address,
      params.DEUS_TOKEN,
      params.HOLDER_ADDRESS,
      params.DEUS_TO_TV_RATE
    );
  }
  params.DEUS_TOKEN && console.error('DEUS_TO_TV_RATE is undefined.');
  params.HOLDER_ADDRESS && console.error('DEUS_TOKEN is undefined.');
  params.DEUS_TO_TV_RATE && console.error('HOLDER_ADDRESS is undefined.');
};
