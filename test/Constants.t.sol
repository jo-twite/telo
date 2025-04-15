// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import {Telo} from "../../src/Telo.sol";

contract Constants is Test {
    Telo public token;

    address public owner;
    address public operator;
    address public receiver;
    address public stranger;

    uint256 internal initialTokenId = 1;

    function setUp() public virtual {
        owner = makeAddr("Owner");
        operator = makeAddr("Operator");
        receiver = makeAddr("Receiver");
        stranger = makeAddr("Stranger");

        token = new Telo();
    }

    function mintToOwner() internal {
        vm.prank(owner);
        token.mint(owner);
    }
}
