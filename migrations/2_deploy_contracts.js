var SafeMath = artifacts.require('./SafeMath.sol');
var TicketManiaToken = artifacts.require("./TicketManiaToken.sol");
var TicketManiaTokenPreSale = artifacts.require("./TicketManiaTokenPreSale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, TicketManiaToken);
  deployer.link(SafeMath, TicketManiaTokenPreSale);
  deployer.deploy(TicketManiaToken).then(function() {
    const hardCap = 350000; //in USD
    const softCap = 150000; //in USD
    const token = TicketManiaToken.address;
    const totalTokens = 1400000; //NOT in wei, converted by contract
    const limit = 50000; //in USD
    const beneficiary = web3.eth.accounts[0];
    const startBlock = web3.eth.blockNumber;
    const endBlock = web3.eth.blockNumber + 100;
    deployer.deploy(TicketManiaTokenPreSale, hardCap, softCap, token, beneficiary, totalTokens, 255, limit, startBlock, endBlock);
  });
};
