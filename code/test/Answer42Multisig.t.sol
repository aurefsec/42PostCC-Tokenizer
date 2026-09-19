// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Answer42} from "../src/Answer42.sol";

contract Answer42Multisig is Test
{
  Answer42 asr;
  uint256 initialSupply;
  address myAddr;
  address owner1;
  address owner2;
  address owner3;
  address owner4;
  address userAddr1;

  function setUp() public
  {
    initialSupply = 1000;
    asr = new Answer42(initialSupply, owner1, owner2, owner3, owner4);
    myAddr = address(this);
  }

  function testMint() public
  {
    uint256 indexProp;

    vm.expectRevert();
    indexProp = asr.proposeAction(userAddr1, type(Action)(0), 1000);

    indexProp = asr.proposeAction(userAddr1, type(Action)(0), 1000);
    vm.expectRevert();
    asr.signProposal(indexProp, userAddr1);
    asr.signProposal(indexProp, address(this));
    assertEq(asr.balanceOf(address(this), 1000));
    asr.signProposal(indexProp, owner1);
    assertEq(asr.balanceOf(address(this), 1000));
    asr.signProposal(indexProp, owner2);
    assertEq(asr.balanceOf(address(this), 1000));
    asr.signProposal(indexProp, owner3);
    assertEq(asr.balanceOf(address(this), 1000));
    asr.signProposal(indexProp, owner4);
    assertEq(asr.balanceOf(address(this), 2000));
  }
}
