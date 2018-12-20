pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';

contract TVCrowdsale is AllowanceCrowdsale, Ownable {
  uint256 public currentRate;
  address public manager;

  modifier onlyOwnerOrManager() {
    require(msg.sender == owner || manager == msg.sender);
    _;
  }
  
  constructor(uint256 _rate, address _wallet, ERC20 _token, address _tokenWallet, address _manager)
    Crowdsale(_rate, _wallet, _token)
    AllowanceCrowdsale(_tokenWallet) public {
    currentRate = _rate;
    manager = _manager;
  }
  
  function setRate(uint256 _rate) public onlyOwnerOrManager returns (bool) {
    currentRate = _rate;
    return true;
  }

  function changeTokenWallet(address _tokenWallet) public onlyOwnerOrManager {
    _tokenWallet = tokenWallet;
  }

  function changeWallet(address _wallet) public onlyOwnerOrManager {
    wallet = _wallet;
  }

  function changeToken(ERC20 _token) public onlyOwnerOrManager {
    token = _token;
  }

  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    return _weiAmount.mul(currentRate);
  }

  function setManager(address _manager) public onlyOwner {
    manager = _manager;
  }

}
