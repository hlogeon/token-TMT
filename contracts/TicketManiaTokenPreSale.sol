pragma solidity ^0.4.11;


import "./Haltable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./TicketManiaToken.sol";


contract TicketManiaTokenPreSale is Haltable {
  using SafeMath for uint;

  string public constant name = "Ticket Mania Token PreSale";

  TicketManiaToken public token;

  address public beneficiary;

  uint public hardCap;

  uint public softCap;

  uint public price;

  uint public collected = 0;

  uint public tokensSold = 0;

  uint public investorCount = 0;

  uint public weiRefunded = 0;

  uint public bonus1End;

  uint public bonus2End;

  uint public bonus3End;

  uint public startTimestamp;

  uint public endTimestamp;

  bool public softCapReached = false;

  bool public crowdsaleFinished = false;

  mapping (address => bool) refunded;

  event SoftCapReached(uint softCap);

  event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);

  event Refunded(address indexed holder, uint amount);

  modifier preSaleActive() {
    require(block.timestamp >= startTimestamp && block.timestamp < endTimestamp);
    _;
  }

  modifier preSaleEnded() {
    require(block.timestamp >= endTimestamp);
    _;
  }

  function TicketManiaTokenPreSale(
    uint _hardCapUSD,
    uint _softCapUSD,
    address _token,
    address _beneficiary,
    uint _totalTokens,
    uint _priceETH,
    uint _bonus1End,
    uint _bonus2End,
    uint _bonus3End,

    uint _start,
    uint _end
  ) {
    hardCap = _hardCapUSD.mul(1 ether).div(_priceETH);
    softCap = _softCapUSD.mul(1 ether).div(_priceETH);
    price = _totalTokens.mul(1 ether).div(hardCap);

    token = TicketManiaToken(_token);
    beneficiary = _beneficiary;

    bonus1End = _bonus1End;
    bonus2End = _bonus2End;
    bonus3End = _bonus3End;

    startTimestamp = _start;
    endTimestamp = _end;
  }

  function() payable {
    require(msg.value >= 0.1 * 1 ether);
    doPurchase(msg.sender);
  }

  function refund() external preSaleEnded inNormalState {
    require(softCapReached == false);
    require(refunded[msg.sender] == false);

    uint balance = token.balanceOf(msg.sender);
    require(balance > 0);

    uint refund = balance.div(price);
    if (refund > this.balance) {
      refund = this.balance;
    }

    msg.sender.transfer(refund);
    refunded[msg.sender] = true;
    weiRefunded = weiRefunded.add(refund);
    Refunded(msg.sender, refund);
  }

  function withdraw() public onlyOwner {
    require(softCapReached);
    beneficiary.transfer(collected);
    token.transfer(beneficiary, token.balanceOf(this));
    crowdsaleFinished = true;
  }

  function doPurchase(address _owner) private preSaleActive inNormalState {
    require(!crowdsaleFinished);
    require(collected.add(msg.value) <= hardCap);

    if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
      softCapReached = true;
      SoftCapReached(softCap);
    }

    uint tokens = msg.value.mul(price);
    uint bonus = calculateBonus(tokens);
    uint totalTokens = tokens + bonus;

    if (token.balanceOf(msg.sender) == 0) investorCount++;

    collected = collected.add(msg.value);

    token.transfer(msg.sender, totalTokens);

    tokensSold = tokensSold.add(totalTokens);

    NewContribution(_owner, totalTokens, msg.value);
  }

  function calculateBonus(uint tokens) internal constant returns (uint bonus) {
      uint _bonus = 0;
      if (msg.value <= 10 ether) {
        if (block.timestamp > startTimestamp && block.timestamp <= bonus1End) {
          _bonus = tokens.div(100).mul(115);
        } else if (block.timestamp > bonus1End && block.timestamp <= bonus2End) {
          _bonus = tokens.div(100).mul(105);
        } else if (block.timestamp > bonus2End && block.timestamp <= bonus3End) {
          _bonus = tokens.div(100).mul(95);
        } else {
          _bonus = tokens.div(100).mul(85);
        }
      } else if (msg.value > 10 ether && msg.value <= 50 ether) {
        if (block.timestamp > startTimestamp && block.timestamp <= bonus1End) {
          _bonus = tokens.div(100).mul(125);
        } else if (block.timestamp > bonus1End && block.timestamp <= bonus2End) {
          _bonus = tokens.div(100).mul(115);
        } else if (block.timestamp > bonus2End && block.timestamp <= bonus3End) {
          _bonus = tokens.div(100).mul(105);
        } else {
          _bonus = tokens.div(100).mul(95);
        }
      } else {
        if (block.timestamp > startTimestamp && block.timestamp <= bonus1End) {
          _bonus = tokens.div(100).mul(150);
        } else if (block.timestamp > bonus1End && block.timestamp <= bonus2End) {
          _bonus = tokens.div(100).mul(125);
        } else if (block.timestamp > bonus2End && block.timestamp <= bonus3End) {
          _bonus = tokens.div(100).mul(115);
        } else {
          _bonus = tokens.div(100).mul(105);
        }
      }
      return _bonus;
  }


}
