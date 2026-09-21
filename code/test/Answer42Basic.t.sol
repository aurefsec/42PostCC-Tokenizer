// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Answer42} from "../src/Answer42.sol";

contract Answer42Basic is Test
{
  // All the functions declares here can be used everywhere in the contract
  Answer42 asr;
  uint256 initialSupply;
  address myAddr;
  address owner1;
  address owner2;
  address owner3;
  address owner4;
  address userAddr1;
  address userAddr2;

  function setUp() public
  {
    initialSupply = 1000;
    asr = new Answer42(initialSupply, msg.sender, owner1, owner2, owner3, owner4);
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
    require(asr.transfer(userAddr1, 100)); // Use require() to make sure the function returns true, else the function fails
    require(asr.transfer(userAddr2, 100));
    
    // Check if the balance is correct after the two transfers
    assertEq(asr.balanceOf(address(this)), 800);
    assertEq(asr.balanceOf(address(userAddr1)), 100);
    assertEq(asr.balanceOf(address(userAddr2)), 100);
  }

  function testTransferOverflow() public
  {
    // vm = virtual machine to use cheated functions
    vm.expectRevert();  // Call vm.expectRevert when i want the test to fail
    require(asr.transfer(userAddr1, 1001));
  }

  function testTransferAfterApprove() public
  {
    require(asr.approve(userAddr1, 100)); 
    vm.prank(userAddr1); // Call prank to allow userAddr1 to use the next function
    require(asr.transferFrom(address(this), userAddr2, 100));

    assertEq(asr.balanceOf(address(this)), 900);
    assertEq(asr.balanceOf(address(userAddr1)), 0);
    assertEq(asr.balanceOf(address(userAddr2)), 100);
  }

  function testTransferOverflowAfterApprove() public
  {
    require(asr.approve(userAddr1, 100));
    vm.prank(userAddr1);
    vm.expectRevert();
    require(asr.transferFrom(address(this), userAddr2, 101));
  }
}
