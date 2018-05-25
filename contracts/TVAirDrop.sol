pragma solidity 0.4.21;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract TVAirDrop {
    ERC721 public deusContract;
    ERC20 public TVContract;
    uint256 public deusToTVRate;
    address public holderAddress;

    mapping(uint256 => bool) internal droppedTokens;

    event AirDropped(uint256 deusTokenId, address senderAddress, address holderAddress, uint256 collectTVs);

    function TVAirDrop(address _TVContract, address _deusContract, address _holderAddress, uint256 _deusToTVRate) public {
        deusContract = ERC721(_deusContract);
        TVContract = ERC20(_TVContract);
        deusToTVRate = _deusToTVRate;
        holderAddress = _holderAddress;
    }

    function getTVs() public {
        uint256 deusTokenCount = deusContract.balanceOf(msg.sender);
        for (uint8 i = 0; i < deusTokenCount; i++) {
            uint256 deusToken = deusContract.tokenOfOwnerByIndex(msg.sender, i);
            if (!droppedTokens[deusToken]) {
                TVContract.transferFrom(holderAddress, msg.sender, deusToTVRate);
                droppedTokens[deusToken] = true;
                emit AirDropped(deusToken, msg.sender, holderAddress, deusToTVRate);
            }
        }
    }
}
