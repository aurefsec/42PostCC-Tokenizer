// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Answer42 is ERC20
{
  constructor (uint256 initialSupply) ERC20("Answer42", "ASR") // Answer42 inherits from ERC20 
  {
    _mint(msg.sender, initialSupply); // The creator (msg.sender) of the contract will receive the initial supply
  }
}
