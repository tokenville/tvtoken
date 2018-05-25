pragma solidity 0.4.21;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract TVAirDrop {
    ERC721 public deusContract;
    ERC20 public TVTContract;
    uint256 public deusToTVTRate;
    address public ownerAddress;

    mapping(uint256 => bool) internal droppedTokens;

    event AirDropped(uint256 id_deus, address sender_address, address ownerAddress, uint256 collectTVTs);

    function TVAirDrop(address _deusContract, address _TVTContract, address _ownerAddress, uint256 _deusToTVTRate) public {
        deusContract = ERC721(_deusContract);
        TVTContract = ERC20(_TVTContract);
        deusToTVTRate = _deusToTVTRate;
        ownerAddress = _ownerAddress;
    }

    function getTVTs() public {
        uint256 deusTokenCount = deusContract.balanceOf(msg.sender);
        for (uint8 i = 0; i < deusTokenCount; i++) {
            uint256 deusToken = deusContract.tokenOfOwnerByIndex(msg.sender, i);
            if (!droppedTokens[deusToken]) {
                TVTContract.transferFrom(ownerAddress, msg.sender, deusToTVTRate);
                droppedTokens[deusToken] = true;
                emit AirDropped(deusToken, msg.sender, ownerAddress, deusToTVTRate);
            }
        }
    }
}
