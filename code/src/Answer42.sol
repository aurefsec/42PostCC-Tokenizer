// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

struct Proposal
{
  address proposer;
  string action;
  uint256 amount;
}

contract Answer42 is ERC20
{
  constructor (uint256 initialSupply) ERC20("Answer42", "ASR") // Answer42 inherits from ERC20 
  {
    _mint(msg.sender, initialSupply); // The creator (msg.sender) of the contract will receive the initial supply
  }

  uint256 indexProp = 0;
  mapping(uint256 => Proposal) proposals; // Key => value like dict in python

  proposeAction(address proposer, string action, uint256 amount) public returns bool
  {
    if (action != "mint" && action != "burn" && action != "changeOwner")
      return false;

    proposals[indexProp] = newProposal;
    newProposal.proposer = proposer;
    newProposal.action = action;
    newProposal.amount = amount;
    indexProp += 1;

    return true;
  }
}
