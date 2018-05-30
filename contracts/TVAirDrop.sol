pragma solidity 0.4.21;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract TVAirDrop {
    ERC721 public deusContract;
    ERC20 public TVContract;
    uint256 public deusToTVRate;
    address public holder;

    mapping(uint256 => bool) internal droppedTokens;

    event AirDropped(uint256 deusTokenId, address sender, address holder, uint256 collectTVs);

    function TVAirDrop(address _TVContract, address _deusContract, address _holder, uint256 _deusToTVRate) public {
        deusContract = ERC721(_deusContract);
        TVContract = ERC20(_TVContract);
        deusToTVRate = _deusToTVRate;
        holder = _holder;
    }

    function getTVs() public {
        uint256 deusTokenCount = deusContract.balanceOf(msg.sender);
        for (uint8 i = 0; i < deusTokenCount; i++) {
            uint256 deusToken = deusContract.tokenOfOwnerByIndex(msg.sender, i);
            if (!droppedTokens[deusToken]) {
                droppedTokens[deusToken] = true;
                bool successful = TVContract.transferFrom(holder, msg.sender, deusToTVRate);
                if (!successful) revert("Transfer from holder to sender failed.");
                emit AirDropped(deusToken, msg.sender, holder, deusToTVRate);
            }
        }
    }
}
