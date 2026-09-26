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
  uint8 public constant TRANSACTION = 2;

  struct Proposal
  { 
    address proposer;
    address receiver;
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

    // Check if owners are valid address
    require(owner1 != address(0));
    require(owner2 != address(0));
    require(owner3 != address(0));
    require(owner4 != address(0));
    require(owner5 != address(0));

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
    proposals[id].signatureCount += 1;
    if (proposals[id].signatureCount == 5)
    {
      if (proposals[id].action == MINT)
        _mint(deployer, proposals[id].amount);
      else if (proposals[id].action == BURN)
        _burn(deployer, proposals[id].amount);
      else if (proposals[id].action == TRANSACTION)
        _transfer(proposals[id].proposer, proposals[id].receiver, proposals[id].amount);
    }
  }

  // Rewrite the parent transfer function from ERC20 using the keyword override
  function transfer(address to, uint256 amount) public override returns (bool)
  {
    if (amount >= 1000)
    {
      assembly
      {
        // Slot size: 32 bytes (256 bits)
        // Retrieve indexProp and proposals to generate key
        mstore(0, sload(indexProp.slot)) // mstore: temporary storage to calcul the key, sload(): read the value
        mstore(0x20, proposals.slot) // 0x20: 32 in hexadecimal (for one slot);
        let key := keccak256(0, 0x40)
  
        // Struct Proposal size :slot 0: 20, slot 1: 20 + 8, slot 2: 256, slot 3: 256, slot4+: x bits;
        // sstore(): permanent storage to store value of mapping proposals
        sstore(key, caller()) // caller(), the function caller
        sstore(add(key, 1), add(to, shl(160, 2))) // shl(): bytes shit of x bits to the left
        sstore(add(key, 2), amount)

        // Increment indexProp
        sstore(indexProp.slot, add(sload(indexProp.slot), 1))
      }
      return true;
    }
    return super.transfer(to, amount);
  }
}
