// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Answer42} from "../src/Answer42.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract Answer42Multisig is Test
{
  Answer42 asr;
  uint256 initialSupply;
  address myAddr;
  address owner2;
  address owner3;
  address owner4;
  address owner5;
  address userAddr1;

  function setUp() public
  {
    initialSupply = 1000;
    owner2 = makeAddr("owner2");
    owner3 = makeAddr("owner3");
    owner4 = makeAddr("owner4");
    owner5 = makeAddr("owner5");
    asr = new Answer42(initialSupply, msg.sender, owner2, owner3, owner4, owner5);
    userAddr1 = makeAddr("userAddr1");
  }

  function testMint() public
  {
    uint256 indexProp = 1000;

    vm.expectRevert();
    indexProp = asr.proposeAction(userAddr1, 2, 1000);

    indexProp = asr.proposeAction(userAddr1, 0, 1000);
    vm.expectRevert();
    asr.signProposal(indexProp, userAddr1);
    asr.signProposal(indexProp, msg.sender);
    assertEq(asr.balanceOf(msg.sender), 1000);
    asr.signProposal(indexProp, owner2);
    assertEq(asr.balanceOf(msg.sender), 1000);
    asr.signProposal(indexProp, owner3);
    assertEq(asr.balanceOf(msg.sender), 1000);
    asr.signProposal(indexProp, owner4);
    assertEq(asr.balanceOf(msg.sender), 1000);
    asr.signProposal(indexProp, owner5);
    assertEq(asr.balanceOf(msg.sender), 2000);
  }
}
