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


## TMT Pre ICO


## How to setup development environment and run tests?

1. Install `docker` if you don't have it.
1. Clone this repo.
1. Run `docker-compose build --no-cache`.
1. Run `docker-compose up -d`.
1. Install dependencies: `docker-compose exec workspace yarn`.
1. To run tests: `docker-compose exec workspace truffle test`.
1. To merge your contracts via sol-merger run: `docker-compose exec workspace yarn merge`.
Merged contracts will appear in `merge` directory.
