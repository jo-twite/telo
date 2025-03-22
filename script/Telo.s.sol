// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Telo} from "../src/Telo.sol";

contract TeloScript is Script {
    Telo public telo;


    function run() public {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(pk);

        telo = new Telo();

        vm.stopBroadcast();
    }
}