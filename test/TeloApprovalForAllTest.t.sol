// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;


import "forge-std/Test.sol";
import "src/Telo.sol";
import "./Constants.t.sol";


contract TeloApprovalForAllTest is Constants {
    function testSetApprovalForAll() public {
        vm.prank(owner);

        token.setApprovalForAll(operator, true);

        assertTrue(token.isApprovedForAll(owner, operator));

        vm.prank(owner);
        token.setApprovalForAll(operator, false);
        assertFalse(token.isApprovedForAll(owner, operator));
    }

}

