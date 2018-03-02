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

  uint public bonus1BlockEnd;

  uint public bonus2BlockEnd;

  uint public bonus3BlockEnd;

  uint public bonus4BlockEnd;

  uint public startBlock;

  uint public endBlock;

  bool public softCapReached = false;

  bool public crowdsaleFinished = false;

  mapping (address => bool) refunded;

  event SoftCapReached(uint softCap);

  event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);

  event Refunded(address indexed holder, uint amount);

  modifier preSaleActive() {
    require(block.number >= startBlock && block.number < endBlock);
    _;
  }

  modifier preSaleEnded() {
    require(block.number >= endBlock);
    _;
  }

  function TicketManiaTokenPreSale(
    uint _hardCapUSD,
    uint _softCapUSD,
    address _token,
    address _beneficiary,
    uint _totalTokens,
    uint _priceETH,
    uint _bonus1BlockEnd,
    uint _bonus2BlockEnd,
    uint _bonus3BlockEnd,
    uint _bonus4BlockEnd,

    uint _startBlock,
    uint _endBlock
  ) {
    hardCap = _hardCapUSD.mul(1 ether).div(_priceETH);
    softCap = _softCapUSD.mul(1 ether).div(_priceETH);
    price = _totalTokens.mul(1 ether).div(hardCap);

    token = TicketManiaToken(_token);
    beneficiary = _beneficiary;

    bonus1BlockEnd = _bonus1BlockEnd;
    bonus2BlockEnd = _bonus2BlockEnd;
    bonus3BlockEnd = _bonus3BlockEnd;
    bonus4BlockEnd = _bonus4BlockEnd;

    startBlock = _startBlock;
    endBlock = _endBlock;
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

  function withdraw() external onlyOwner {
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
      uint bonus = 0;
      if (msg.value <= 10 ether) {
        if (block.number > startBlock && block.number <= bonus1BlockEnd) {
          bonus = tokens.div(100).mul(115);
        } else if (block.number > bonus1BlockEnd && block.number <= bonus2BlockEnd) {
          bonus = tokens.div(100).mul(105);
        } else if (block.number > bonus2BlockEnd && block.number <= bonus3BlockEnd) {
          bonus = tokens.div(100).mul(95);
        } else {
          bonus = tokens.div(100).mul(85);
        }
      } else if (msg.value > 10 ether && msg.value <= 50 ether) {
        if (block.number > startBlock && block.number <= bonus1BlockEnd) {
          bonus = tokens.div(100).mul(125);
        } else if (block.number > bonus1BlockEnd && block.number <= bonus2BlockEnd) {
          bonus = tokens.div(100).mul(115);
        } else if (block.number > bonus2BlockEnd && block.number <= bonus3BlockEnd) {
          bonus = tokens.div(100).mul(105);
        } else {
          bonus = tokens.div(100).mul(95);
        }
      } else {
        if (block.number > startBlock && block.number <= bonus1BlockEnd) {
          bonus = tokens.div(100).mul(150);
        } else if (block.number > bonus1BlockEnd && block.number <= bonus2BlockEnd) {
          bonus = tokens.div(100).mul(125);
        } else if (block.number > bonus2BlockEnd && block.number <= bonus3BlockEnd) {
          bonus = tokens.div(100).mul(115);
        } else {
          bonus = tokens.div(100).mul(105);
        }
        return bonus;
      }
  }


}
