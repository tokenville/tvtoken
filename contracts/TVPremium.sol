pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract ITVCoupon {

}

contract TVCrowdsale {
    uint256 public currentRate;
    function buyTokens(address _beneficiary) public payable;
}

contract TVToken {
    function transfer(address _to, uint256 _value) public returns (bool);
    function safeTransfer(address _to, uint256 _value, bytes _data) public;
}

contract TVPremium is Ownable, ERC721Token {
    uint public discountPercentage;
    uint public price;
    address public manager;
    address public TVCouponAddress;
    address public wallet;
    address public TVTokenAddress;
    address public TVCrowdsaleAddress;

    bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));
    uint internal incrementId = 0;
    address internal checkAndBuySender;

    mapping(uint => bool) usedCoupons;

    modifier onlyOwnerOrManager() {
        require(msg.sender == owner || manager == msg.sender);
        _;
    }

    event TokenReceived(address from, uint value, bytes data, uint couponId);
    event ChangeAndBuyPremium(address buyer, uint rate, uint price, uint couponId);

    constructor(
        address _TVTokenAddress,
        address _TVCrowdsaleAddress,
        address _TVCouponAddress,
        address _manager,
        uint _discountPercentage,
        address _wallet
    ) {
        TVCouponAddress = _TVCouponAddress;
        manager = _manager;
        discountPercentage = _discountPercentage;
        TVCrowdsaleAddress = _TVCrowdsaleAddress;
        TVTokenAddress = _TVTokenAddress;
        wallet = _wallet;
    }

    function mint(address to) public onlyOwnerOrManager {
        incrementId++;
        super._mint(to, incrementId);
    }

    function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4) {
        require(msg.sender == TVTokenAddress);
        uint couponId = uint256(convertBytesToBytes32(_data));
        uint premiumPrice = couponId == 0 ? price : price - (price * discountPercentage) / 100;
        require(premiumPrice == _value);
        if (couponId > 0) {
            require(!usedCoupons[couponId]);
            usedCoupons[couponId] = true;
        }
        TVToken(TVTokenAddress).transfer(wallet, _value);
        _from = this == _from ? checkAndBuySender : _from;
        checkAndBuySender = address(0);

        incrementId++;
        super._mint(_from, incrementId);

        emit TokenReceived(_from, _value, _data, couponId);
        return TOKEN_RECEIVED;
    }

    function changeAndBuyPremium(uint couponId) public payable {
        uint rate = TVCrowdsale(TVCrowdsaleAddress).currentRate();
        uint premiumPrice = couponId == 0 ? price : price - (price * discountPercentage) / 100;

        uint priceWei = price / rate;
        require(priceWei == msg.value);

        TVCrowdsale(TVCrowdsaleAddress).buyTokens.value(msg.value)(this);
        bytes memory data = toBytes(couponId);
        checkAndBuySender = msg.sender;
        TVToken(TVTokenAddress).safeTransfer(this, premiumPrice, data);

        emit ChangeAndBuyPremium(msg.sender, rate, priceWei, couponId);
    }

    function changePrice(uint _price) public onlyOwnerOrManager {
        price = _price;
    }

    function changeTVCouponAddress(address _address) public onlyOwnerOrManager {
        TVCouponAddress = _address;
    }

    function changeDiscountPercentage(uint percentage) public onlyOwnerOrManager {
        require(discountPercentage <= 100);
        discountPercentage = percentage;
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

    function toBytes(uint256 x) internal pure returns (bytes b) {
        b = new bytes(32);
        assembly {mstore(add(b, 32), x)}
    }
}
