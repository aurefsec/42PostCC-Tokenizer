// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13
;
import {Test} from "forge-std/Test.sol";
import {Answer42} from "../src/Answer42.sol";

contract Answer42Test is Test
{
  // All the functions declares here can be used everywhere in the contract
  Answer42 asr;
  uint256 initialSupply = 1000;

  function setUp() public
  {
    asr = new Answer42(initialSupply);
  }

  // All the test functions have to start by "test" keyword
  function testCheckContractValues() public view // public fonctions that does not change any values (view)
  {
    // assert used to check values, not if
    assertEq(asr.name(), "Answer42");
    assertEq(asr.symbol(), "ASR");
    assertEq(asr.totalSupply(), initialSupply);
  }
}
