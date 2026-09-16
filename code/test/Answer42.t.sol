// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13
;
import {Test} from "forge-std/Test.sol";
import {Answer42} from "../src/Answer42.sol";

contract Answer42Test is Test
{
  // All the functions declares here can be used everywhere in the contract
  Answer42 asr;
  uint256 initialSupply;
  address myAddr;
  address userAddr1;
  address userAddr2;

  function setUp() public
  {
    initialSupply = 1000;
    asr = new Answer42(initialSupply);
    myAddr = address(this);
    userAddr1 = makeAddr("userAddr1");
    userAddr2 = makeAddr("userAddr2");
  }

  // All the test functions have to start by "test" keyword
  function testCheckContractValues() public view // public fonctions that does not change any values (view)
  {
    // assert used to check values, not if
    assertEq(asr.name(), "Answer42");
    assertEq(asr.symbol(), "ASR");
    assertEq(asr.totalSupply(), initialSupply);
    assertEq(asr.balanceOf(address(this)), initialSupply);
  }

  function testTransfer() public
  {
    asr.transfer(userAddr1, 100);
    asr.transfer(userAddr2, 100);

    assertEq(asr.balanceOf(address(this)), 800);
    assertEq(asr.balanceOf(address(userAddr1)), 100);
    assertEq(asr.balanceOf(address(userAddr2)), 100);
  }
}
