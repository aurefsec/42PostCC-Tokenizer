// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Answer42} from "../src/Answer42.sol";

contract Answer42Basic is Test
{
  // All the functions declares here can be used everywhere in the contract
  Answer42 asr;
  uint256 initialSupply;
  address deployer;
  address owner2;
  address owner3;
  address owner4;
  address owner5;
  address userAddr1;
  address userAddr2;

  function setUp() public
  {
    initialSupply = 1000;
    deployer = makeAddr("deployer");
    owner2 = makeAddr("owner2");
    owner3 = makeAddr("owner3");
    owner4 = makeAddr("owner4");
    owner5 = makeAddr("owner5");
    asr = new Answer42(initialSupply, deployer, owner2, owner3, owner4, owner5);
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
    assertEq(asr.balanceOf(address(deployer)), initialSupply);
  }

  function testTransfer() public
  {
    // vm = virtual machine to use cheated functions
    vm.prank(deployer); // Call prank to allow userAddr1 to use the next function
    require(asr.transfer(userAddr1, 100)); // Use require() to make sure the function returns true, else the function fails
    vm.prank(deployer);
    require(asr.transfer(userAddr2, 100));
    
    // Check if the balance is correct after the two transfers
    assertEq(asr.balanceOf(address(deployer)), 800);
    assertEq(asr.balanceOf(address(userAddr1)), 100);
    assertEq(asr.balanceOf(address(userAddr2)), 100);
  }

  function testTransferOverflow() public
  {
    vm.prank(deployer);
    vm.expectRevert();  // Call vm.expectRevert when i want the test to fail
    asr.transfer(userAddr1, 1001);
  }

  function testTransferAfterApprove() public
  {
    vm.prank(deployer);
    require(asr.approve(userAddr1, 100)); 
    vm.prank(userAddr1); 
    require(asr.transferFrom(address(deployer), userAddr2, 100));

    assertEq(asr.balanceOf(address(deployer)), 900);
    assertEq(asr.balanceOf(address(userAddr1)), 0);
    assertEq(asr.balanceOf(address(userAddr2)), 100);
  }

  function testTransferOverflowAfterApprove() public
  {
    vm.prank(deployer);
    require(asr.approve(userAddr1, 100));
    vm.prank(userAddr1);
    vm.expectRevert();
    asr.transferFrom(address(deployer), userAddr2, 101);
  }
}
