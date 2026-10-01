pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Answer42} from "../../code/src/Answer42.sol";

// Need to inherit from Script (ERC-20) to deploy the contract
contract Deploy is Script
{
  function run() external
  {
    // All transactions between start and stop broadcast will be signed with my private key
    vm.startBroadcast();

    address owner2 = makeAddr("owner2");
    address owner3 = makeAddr("owner3");
    address owner4 = makeAddr("owner4");
    address owner5 = makeAddr("owner5");

    new Answer42(100000e18, msg.sender, owner2, owner3, owner4, owner5);

    vm.stopBroadcast();
  }
}
