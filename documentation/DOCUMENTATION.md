# Answer42 Token Documentation

## Overview

Answer42 is an ERC20 token deployed on Ethereum Sepolia with Multisig security layer. 

## Architectures

- Token standard : ERC20
- Security : 5-owner Multisig system (5 signatures required for high-value transactions, mint and burn)
- Implementation : Solidity + Yul

## Features

### ERC20 

ERC20 is a standard for the Ethereum blockchain. It is the standard to solve problems of compatibility
between different contracts, dApps, exchanges, wallets etc. ERC20  defines 6 essential functions :
"transfer()", "transferFrom()", "approve()", "allowance()", "balanceOf" and "totalSupply()".

### Ethereum Sepolia

Ethereum Sepolia is a testnet to deploy contracts and test them. Sepolia simulates the Ethereum 
mainnet with some differences, in particular we can use free faucets to get sepETH to deploy and 
make transactions.

### Multisig System

Transactions >= 1000 tokens, mint and burn tokens require all 5 owners signatures:

- `proposeAction()`: Any user can call this function to propose a mint or burn action
- `signProposal()`: This function is used by owners to sign a proposal
- `transfer()`: The function transfer was overridden to create a proposal when the token amount 
is >= 1000
- Automatic execution when 5 signatures reached

### Admin functions

- `mint()`: Create new tokens (Multisig protected)
- `burn()`: Destroy tokens (Multisig protected)

### Yul Optimization

Large transfers >= 1000 tokens use Yul assembly to:

- Optimize gas consumption
- Directly manipulate storage slots
- Improve execution efficiency

This was not mandatory and not required in this context but I implemented it to learn a little bit 
of Yul.

## Tests

Some tests are available in the code source (code/test/) to help you to understand the features, 
don't hesitate to make your own tests.

## Deployment informations

- Address: 0xd6e7624DbBEB3CC33B75Cfaafa4ecDD62b7c1cfc
- Network: Sepolia
- Verified on Etherscan: Yes
