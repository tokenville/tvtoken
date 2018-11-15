pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract ITVCrowdsale {
    uint256 public currentRate;
    function buyTokens(address _beneficiary) public payable;
}

contract ITVToken {
    function transfer(address _to, uint256 _value) public returns (bool);
    function safeTransfer(address _to, uint256 _value, bytes _data) public;
}

contract TVArtWork is Ownable, ERC721Token {
    uint public price;
    address public manager;
    address public holder;
    address public TVTokenAddress;
    address public TVCrowdsaleAddress;

    bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));
    uint internal incrementId = 0;
    address internal checkAndBuySender;

    modifier onlyOwnerOrManager() {
        require(msg.sender == owner || manager == msg.sender);
        _;
    }

    event TokenReceived(address from, uint value, bytes data, uint tokenId);
    event ChangeAndBuyPremium(address buyer, uint rate, uint price, uint tokenId);

    constructor(
        address _TVTokenAddress,
        address _TVCrowdsaleAddress,
        address _manager,
        uint _price,
        address _holder
    ) public ERC721Token("TVArtWork Token", "TVAW")  {
        manager = _manager;
        price = _price;
        TVCrowdsaleAddress = _TVCrowdsaleAddress;
        TVTokenAddress = _TVTokenAddress;
        holder = _holder;
    }

    function mint(address to) public onlyOwnerOrManager {
        incrementId++;
        super._mint(to, incrementId);
    }

    function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4) {
        require(msg.sender == TVTokenAddress);
        uint tokenId = uint256(convertBytesToBytes32(_data));
        require(super.ownerOf(tokenId) == holder);
        require(price == _value);

        ITVToken(TVTokenAddress).transfer(holder, _value);
        _from = this == _from ? checkAndBuySender : _from;
        checkAndBuySender = address(0);

        require(_from != address(0));
        require(holder != address(0));
        super.removeTokenFrom(holder, tokenId);
        addTokenTo(_from, tokenId);

        emit TokenReceived(_from, _value, _data, tokenId);
        return TOKEN_RECEIVED;
    }

    function changeAndBuy(uint tokenId) public payable {
        uint rate = ITVCrowdsale(TVCrowdsaleAddress).currentRate();

        uint priceWei = price / rate;
        require(priceWei == msg.value);

        ITVCrowdsale(TVCrowdsaleAddress).buyTokens.value(msg.value)(this);
        bytes memory data = toBytes(tokenId);
        checkAndBuySender = msg.sender;
        ITVToken(TVTokenAddress).safeTransfer(this, price, data);

        emit ChangeAndBuyPremium(msg.sender, rate, priceWei, tokenId);
    }

    function changePrice(uint _price) public onlyOwnerOrManager {
        price = _price;
    }

    function changeHolder(address _holder) public onlyOwnerOrManager {
        holder = _holder;
    }

    function changeTVTokenAddress(address newAddress) public onlyOwnerOrManager {
        TVTokenAddress = newAddress;
    }

    function changeTVCrowdsaleAddress(address newAddress) public onlyOwnerOrManager {
        TVCrowdsaleAddress = newAddress;
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }

    function convertBytesToBytes32(bytes inBytes) internal pure returns (bytes32 out) {
        if (inBytes.length == 0) {
            return 0x0;
        }

        assembly {
            out := mload(add(inBytes, 32))
        }
    }

    function toBytes(uint256 x) internal pure returns (bytes b) {
        b = new bytes(32);
        assembly {mstore(add(b, 32), x)}
    }
}
