pragma solidity 0.4.21;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol';

contract TVAirDrop {
    ERC721 public deusContract;
    ERC20Basic public TVTContract;
    uint256 deusToTVTRate;

    mapping(uint256 => bool) internal droppedTokens;

    event AirDropped(uint256 id_deus, address sender_address, uint256 collectTVTs);

    function TVAirDrop(address _deusContract, address _TVTContract, uint _deusToTVTRate) public {
        deusContract = ERC721(_deusContract);
        TVTContract = ERC20Basic(_TVTContract);
        deusToTVTRate = _deusToTVTRate;
    }

    function getTVTs() public {
        var deusTokenCount = deusContract.balanceOf(msg.sender);
        for (uint8 i = 0; i < deusTokenCount; i++) {
            var deusToken = deusContract.tokenOfOwnerByIndex(msg.sender, i);
            if (!droppedTokens[deusToken]) {
                TVTContract.transfer(msg.sender, deusToTVTRate);
                droppedTokens[deusToken] = true;
                emit AirDropped(deusToken, msg.sender, deusToTVTRate);
            }
        }
    }
}
