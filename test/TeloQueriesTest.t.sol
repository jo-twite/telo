// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;


import "forge-std/Test.sol";
import "src/Telo.sol";
import "./Constants.t.sol";


/**
 * Covers: 
 * - balanceOf
 * - ownerOf
 * - getApproved
 * - isApprovedForAll
 * - reverts for non-existing tokens (ownerOf, getApproved)
 * 
 */

contract TeloQueriesTest is Constants {

    function testBalanceOfOwnerIsCorrect() public {
        mintToOwner();    
        assertEq(token.balanceOf(owner), 1);
    }

    function testBalanceOfOtherAddressIsZero() public view {
        assertEq(token.balanceOf(receiver), 0);
    }

    function testBalanceOfZeroAddressReturnsZero() public view {
        assertEq(token.balanceOf(address(0)), 0);
    }

    function testOwnerOfValidTokenId() public {
        mintToOwner();
        assertEq(token.ownerOf(1), owner);
    }

    function testOwnerOfInvalidTokenIdReverts() public {
        vm.expectRevert();
        token.ownerOf(999); // non-existent token
    }

    function testGetApprovedDefaultIsZeroAddress() public {
        vm.expectRevert(Telo.InValidNFTError.selector);
        assertEq(token.getApproved(999), address(0));
    }

    function testGetApprovedAfterApproval() public {
        mintToOwner();
        
        vm.prank(owner);
        token.approve(operator, 1);

        assertEq(token.getApproved(initialTokenId), operator);
    }

    function testGetApprovedInvalidTokenIdReverts() public {
        vm.expectRevert(Telo.InValidNFTError.selector);
        token.getApproved(999);
    }

    function testIsApprovedForAllDefaultIsFalse() public view {
        assertFalse(token.isApprovedForAll(owner, operator));
    }

    function testIsApprovedForAllAfterApprovalIsTrue() public {
        vm.prank(owner);
        token.setApprovalForAll(operator, true);

        assertTrue(token.isApprovedForAll(owner, operator));
    }

    function testIsApprovedForAllAfterRevokingIsFalse() public {
        vm.prank(owner);
        token.setApprovalForAll(operator, true);

        vm.prank(owner);
        token.setApprovalForAll(operator, false);

        assertFalse(token.isApprovedForAll(owner, operator));
    }

}