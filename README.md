# Tokenizer

## 1. Short description + Token name

The goal of this project is to create a Token on the blockchain of my choice. I chose to code my 
own token on Ethereum blockchain because this is the most used. The name of my token is "Answer42" 
with the tag "ASR" because it's a project for the 42 School and the project asks to use "42" in 
the name. I used the word "Answer" to refer to "The Hitchhiker's Guide to the Galaxy" where the 
number 42 is the answer of the universe.

## 2. Technical choices

- Blockchain : Ethereum Sepolia (The project asks to use testnet to avoid using real money)
- Langage : Solidity + Yul (Use of Yul is my personal choice to learn a little bit of low level)
- Framework : Foundry (This is the most used and efficient Framework actually)

## 3. Features

- ERC20 Standard
- Multisig System
- Protected transaction
- Mint/Burn functions
- Yul optimization

To have more informations of the different features I recommend checking the "documentation" folder.

## 4. Deployment

- Creator address : 0xd0A7cC972Ba8D0A759D2480CE05E712d7c536Ea1
- Contract address : 0xd6e7624DbBEB3CC33B75Cfaafa4ecDD62b7c1cfc
- Network : Sepolia via Infura
- Transaction hash : 0x7f1524b73c5240af131ce575425444dda720842f464b0e795f05ef06a5c24d96
- Etherscan URL : https://sepolia.etherscan.io/address/0xd6e7624DbBEB3CC33B75Cfaafa4ecDD62b7c1cfc

## 5. Installation/Use

- Compilation : "forge build"
- Test : "forge test"
- Private key generation : "openssl rand -hex 32"
- Retrieve public key from private key : "cast wallet address --private-key $PRIVATE_KEY"
- Test Deployment : "forge script deployment/script/Deploy.s.sol:Deploy --rpc-url $SEPOLIA_RPC_URL"
- Deployment : "forge script deployment/script/Deploy.s.sol:Deploy --rpc-url $SEPOLIA_RPC_URL 
    --private-key $PRIVATE_KEY --broadcast"
