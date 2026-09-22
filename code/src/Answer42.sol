// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/console.sol";

contract Answer42 is ERC20
{
  error InvalidAction();
  error InvalidId();
  error NotAnOwner();
  error AlreadySigned();

  uint8 public constant MINT = 0;
  uint8 public constant BURN = 1;

  struct Proposal
  { 
    address proposer;
    uint8 action;
    uint256 amount;
    uint256 signatureCount;
    mapping (address => bool) signatureOwners;
  }

  uint256 indexProp = 1;
  address deployer; // The creator of the contract
  mapping (address => bool) isOwners; // To check if address in an owner
  mapping(uint256 => Proposal) proposals; // Key => value like dict in python

  constructor (uint256 initialSupply, address owner1, address owner2, address owner3, address owner4, address owner5) ERC20("Answer42", "ASR") // Answer42 inherits from ERC20 
  {
    _mint(owner1, initialSupply); // The creator (deployer) of the contract will receive the initial supply

    // Deployer and 4 more address will be owners
    deployer = owner1;
    isOwners[owner1] = true;
    isOwners[owner2] = true;
    isOwners[owner3] = true;
    isOwners[owner4] = true;
    isOwners[owner5] = true;
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

    return indexProp - 1;
  }

  function signProposal(uint256 id, address owner) public
  {
    if (!isOwners[owner])
      revert NotAnOwner();
    if (proposals[id].proposer == address(0))
      revert InvalidId();
    if (proposals[id].signatureOwners[owner])
      revert AlreadySigned();

    proposals[id].signatureOwners[owner] = true;
    console.log("before signatureCount: ", proposals[id].signatureCount);
    proposals[id].signatureCount += 1;
    console.log("id: ", id);
    console.log("signatureCount: ", proposals[id].signatureCount);
    if (proposals[id].signatureCount == 5)
    {
      console.log("deployer1: ", deployer);
      if (proposals[id].action == MINT)
        _mint(deployer, proposals[id].amount);
      else if (proposals[id].action == BURN)
        _burn(deployer, proposals[id].amount);
    }
  }
}
