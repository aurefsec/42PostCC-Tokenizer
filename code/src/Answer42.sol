// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Answer42 is ERC20
{
  error InvalidAction();
  error NotAnOwner();
  error AlreadySigned();

  struct Proposal
  {

    uint8 public constant MINT = 0;
    uint8 public constant BURN = 1;

    address proposer;
    uint8 action;
    uint256 amount;
    uint256 signatureCount;
    mapping (address => bool) signatureOwners;
  }

  uint256 indexProp = 0;
  mapping (address => bool) owners; // To stoch each owners for multisig
  mapping(uint256 => Proposal) proposals; // Key => value like dict in python

  constructor (uint256 initialSupply, address owner1, address owner2, address owner3, address owner4) ERC20("Answer42", "ASR") // Answer42 inherits from ERC20 
  {
    _mint(msg.sender, initialSupply); // The creator (msg.sender) of the contract will receive the initial supply

    // Deployer and 4 more address will be owners
    owners[msg.sender] = true;
    owners[owner1] = true;
    owners[owner2] = true;
    owners[owner3] = true;
    owners[owner4] = true;
  }
  
  function proposeAction(address proposer, uint8 action, uint256 amount) public returns (uint256)
  {
    if (action != MINT && action != BURN)
      revert InvalidAction(); // Revert to stop the function

    proposals[indexProp].proposer = proposer;
    proposals[indexProp].action = action;
    proposals[indexProp].amount = amount;
    proposals[indexProp].signatureCount = 0;
    indexProp += 1;

    return indexProp;
  }

  function signProposal(uint256 id, address owner) public
  {
    if (!owners[owner])
      revert NotAnOwner();
    if (proposals[id].signatureOwners[owner])
      revert AlreadySigned();

    proposals[id].signatureOwners[owner] = true;
    proposals[id].signatureCount += 1;
    if (proposals[id].signatureCount == 5)
    {
      if (proposals[id].action == Action.MINT)
        _mint(msg.sender, proposals[id].amount);
      else if (proposals[id].action == Action.BURN)
        _burn(msg.sender, proposals[id].amount);
    }
  }
}
