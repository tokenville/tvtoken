pragma solidity 0.4.21;

import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract TVFreezeAirDrop {
    uint256 public unfreezeBlockNumber;
    ERC20 public TVContract;
    address public holder;

    mapping(address => uint256) internal frozenTVs;

    event Withdraw(address to, uint256 amount, uint blockNumber);
    event SendTVs(address to, uint256 amount);
    event RevertTVs(address from, uint256 amount);

    function TVFreezeAirDrop(address _TVContract, address _holder, uint256 _unfreezeBlockNumber) public {
        unfreezeBlockNumber = _unfreezeBlockNumber;
        TVContract = ERC20(_TVContract);
        holder = _holder;
    }

    function revertFreezeTVs(address from) onlyOwner public {
        require(frozenTokens[from] > 0);
        
        TVContract.revertFunds(this, holder, frozenTokens[from]);
        frozenTokens[to] = 0;

        emit RevertTVs(to, amount);
    }

    function sendFreezeTVs(address to, uint256 amount) onlyOwner public {
        TVContract.transferFrom(holder, this, amount);
        frozenTokens[to] = amount;

        emit SendTVs(to, amount);
    }

    function withdrawTVs() public {
        require(block.number > unfreezeBlockNumber);

        uint256 amount = frozenTokens[msg.sender];
        TVContract.transferFrom(this, msg.sender, amount);
        frozenTokens[msg.sender] = 0;

        emit Withdraw(msg.sender, amount, block.number);
    }

    function balanceOf() public view returns(uint256) {
        return frozenTVs[msg.sender] || 0;
    }
}