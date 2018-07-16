pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/AddressUtils.sol';


contract TokenReceiver {
  function onTokenReceived(address _from, uint256 _value, bytes _data) public returns(bytes4);
}


contract TVToken is PausableToken, MintableToken {
  using AddressUtils for address;
  string public name = 'TV Token';
  string public symbol = 'TV';
  uint8 public decimals = 18;
  bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));

  constructor() public {}

  function revertFunds(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  function safeTransfer(address _to, uint256 _value, bytes _data) public {
    super.transfer(_to, _value);
    require(checkAndCallSafeTransfer(msg.sender, _to, _value, _data));
  }

  function safeTransferFrom(address _from, address _to, uint256 _value, bytes _data) public {
    super.transferFrom(_from, _to, _value);
    require(checkAndCallSafeTransfer(_from, _to, _value, _data));
  }

  function checkAndCallSafeTransfer(address _from, address _to, uint256 _value, bytes _data) internal returns (bool) {
    if (!_to.isContract()) {
      return true;
    }
    bytes4 retval = TokenReceiver(_to).onTokenReceived(_from, _value, _data);
    return (retval == TOKEN_RECEIVED);
  }
}
