# Ticket Mania Pre ICO and Token contracts

Baked with <3 by [secret_tech](http://secrettech.io) (formerly Jincor tech team https://github.com/JincorTech)

## TMT Token
TMT token is a standard ERC20 token

| Name           | Ticket Mania Token |
|----------------|--------------------|
| Symbol         | TMT                |
| Decimals       | 18                 |
| Maximum supply | 2000000000         |
| Mintable       | true               |
| Burnable       | true               |


### Token distribution

| Purpose                                   | % of tokens |
|-------------------------------------------|-------------|
| Team                                      | 15%         |
| Advisory board, early supporters, bounty  | 8%          |
| Reserve fund                              | 37%         |


## TMT Pre ICO

| Start date       | MARCH 2, 2018                |
|------------------|------------------------------|
| End date         | APRIL 12, 2018               |
| Payment method   | ETH                          |
| Soft Cap         | 428550 TMT (150 ETH)         |
| Token price      | 0.000350018 ETH              |
| Minimum purchase | 142.849796296 TMT (0.05 ETH) |

### Bonuses and discounts

| Week | Date                | above 50 ETH | 10-50 ETH | below 10 ETH |
|------|---------------------|--------------|-----------|--------------|
| 1    | March 2 - March 9   | 150%         | 125%      | 115%         |
| 2    | March 10 - March 17 | 125%         | 115%      | 105%         |
| 3    | March 18 - March 25 | 115%         | 105%      | 95%          |
| 4-6  | March 26 - April 12 | 105%         | 95%       | 85%          |

### Other terms and conditions

There is no Hard Cap during presale stage. If the soft cap is not reached, refunds will be available after the lock period. Users supposed to call `refund()` method of Pre ICO smart-contract.


## How to setup development environment and run tests?

1. Install `docker` if you don't have it.
1. Clone this repo.
1. Run `docker-compose build --no-cache`.
1. Run `docker-compose up -d`.
1. Install dependencies: `docker-compose exec workspace yarn`.
1. To run tests: `docker-compose exec workspace truffle test`.
1. To merge your contracts via sol-merger run: `docker-compose exec workspace yarn merge`.
Merged contracts will appear in `merge` directory.
