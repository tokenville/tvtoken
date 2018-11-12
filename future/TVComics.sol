pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract TVCrowdsale {
    uint256 public currentRate;
    function buyTokens(address _beneficiary) public payable;
}

contract TVToken {
    function transfer(address _to, uint256 _value) public returns (bool);
    function safeTransfer(address _to, uint256 _value, bytes _data) public;
}

contract TVComics is Ownable, ERC721Token {

    address public wallet;
    address public TVTokenAddress;
    address public TVCrowdsaleAddress;
    address public manager;

    uint internal incrementId = 0;
    address internal checkAndBuySender;
    bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));

    modifier onlyOwnerOrManager() {
        require(msg.sender == owner || manager == msg.sender);
        _;
    }

    struct Comics {
        uint id;
        uint typeId;
    }

    struct ComicsType {
        uint id;
        uint price;
    }

    mapping(uint => Comics) public comicsMap;
    mapping(uint => ComicsType) public comicsTypesMap;

    event TokenReceived(address from, uint value, bytes data, uint typeId);
    event ChangeAndBuy(address buyer, uint rate, uint price, uint typeId);

    constructor(
        address _TVTokenAddress,
        address _TVCrowdsaleAddress,
        address _manager,
        address _wallet) public ERC721Token("TVComics Token", "TVC") {

        manager = _manager;
        wallet = _wallet;
        TVTokenAddress = _TVTokenAddress;
        TVCrowdsaleAddress = _TVCrowdsaleAddress;
    }

    function mint(address to, uint typeId) public onlyOwnerOrManager {
        incrementId++;
        super._mint(to, incrementId);
        comicsMap[incrementId] = Comics(incrementId, typeId);
    }

    function burn(uint tokenId) public onlyOwnerOf(tokenId) {
        super._burn(msg.sender, tokenId);
        delete comicsMap[tokenId];
    }

    function setComicsType(uint id, uint price) public onlyOwnerOrManager {
        comicsTypesMap[id] = ComicsType(id, price);
    }

    function changeAndBuy(uint typeId) public payable {
        require(comicsTypesMap[typeId].price > 0);
        uint rate = TVCrowdsale(TVCrowdsaleAddress).currentRate();
        uint priceWei = comicsTypesMap[typeId].price / rate;
        require(priceWei == msg.value);

        TVCrowdsale(TVCrowdsaleAddress).buyTokens.value(msg.value)(this);
        bytes memory data = toBytes(typeId);
        checkAndBuySender = msg.sender;
        TVToken(TVTokenAddress).safeTransfer(this, comicsTypesMap[typeId].price, data);

        emit ChangeAndBuy(msg.sender, rate, priceWei, typeId);
    }

    function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4) {
        require(msg.sender == TVTokenAddress);
        uint typeId = uint256(convertBytesToBytes32(_data));
        require(comicsTypesMap[typeId].price > 0);
        require(comicsTypesMap[typeId].price == _value);
        TVToken(TVTokenAddress).transfer(wallet, _value);
        _from = this == _from ? checkAndBuySender : _from;
        checkAndBuySender = address(0);
        super._mint(_from, incrementId);
        emit TokenReceived(_from, _value, _data, typeId);
        return TOKEN_RECEIVED;
    }

    function changeWallet(address _wallet) public onlyOwnerOrManager {
        wallet = _wallet;
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

    function bytesToUint(bytes32 b) internal pure returns (uint number){
        for (uint i = 0; i < b.length; i++) {
            number = number + uint(b[i]) * (2 ** (8 * (b.length - (i + 1))));
        }
    }

    function toBytes(uint256 x) internal pure returns (bytes b) {
        b = new bytes(32);
        assembly {mstore(add(b, 32), x)}
    }

}