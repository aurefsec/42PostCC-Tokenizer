// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Answer42} from "../src/Answer42.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract Answer42Multisig is Test
{
  Answer42 asr;
  uint256 initialSupply;
  address deployer;
  address owner2;
  address owner3;
  address owner4;
  address owner5;
  address userAddr1;

  function setUp() public
  {
    initialSupply = 2000;
    deployer = makeAddr("deployer");
    owner2 = makeAddr("owner2");
    owner3 = makeAddr("owner3");
    owner4 = makeAddr("owner4");
    owner5 = makeAddr("owner5");
    asr = new Answer42(initialSupply, deployer, owner2, owner3, owner4, owner5);
    userAddr1 = makeAddr("userAddr1");
  }

  function testMint() public
  {
    uint256 indexProp;

    vm.expectRevert();
    indexProp = asr.proposeAction(userAddr1, 2, 1000);

    indexProp = asr.proposeAction(userAddr1, 0, 1000);
    vm.expectRevert();
    asr.signProposal(indexProp, userAddr1);
    asr.signProposal(indexProp, deployer);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner2);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner3);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner4);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner5);
    assertEq(asr.balanceOf(deployer), 3000);
  }

  function testBurn() public
  {
    uint256 indexProp;

    indexProp = asr.proposeAction(userAddr1, 1, 1000);
    asr.signProposal(indexProp, deployer);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner2);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner3);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner4);
    assertEq(asr.balanceOf(deployer), 2000);
    asr.signProposal(indexProp, owner5);
    assertEq(asr.balanceOf(deployer), 1000);
  }

  function testTransfer() public
  {
    vm.prank(deployer);
    asr.transfer(address(userAddr1), 500);
    vm.prank(deployer);
    asr.transfer(address(userAddr1), 500);
    vm.prank(deployer);
    asr.transfer(address(userAddr1), 500);
    assertEq(asr.balanceOf(userAddr1), 1500);

    vm.prank(userAddr1);
    asr.transfer(address(deployer), 1500);
    assertEq(asr.balanceOf(deployer), 500);

    asr.signProposal(1, deployer);
    assertEq(asr.balanceOf(deployer), 500);
    asr.signProposal(1, owner2);
    assertEq(asr.balanceOf(deployer), 500);
    asr.signProposal(1, owner3);
    assertEq(asr.balanceOf(deployer), 500);
    asr.signProposal(1, owner4);
    assertEq(asr.balanceOf(deployer), 500);
    asr.signProposal(1, owner5);
    assertEq(asr.balanceOf(deployer), 2000);
  }
}
