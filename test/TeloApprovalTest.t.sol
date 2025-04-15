// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;


import "forge-std/Test.sol";
import "src/Telo.sol";
import "./Constants.t.sol";

contract TeloApprovalTest is Constants {

    function testApproveAsOwnerSuccess() public {
        mintToOwner();

        vm.prank(owner);
        token.approve(operator, 1);

        assertEq(token.getApproved(1), operator);
    }

    function testUnauthorizedApproveRevert() public {
        mintToOwner();

        assertEq(token.ownerOf(1), owner);

        vm.prank(stranger);
        vm.expectRevert(Telo.UnauthorizedOperatorError.selector);        
        token.approve(operator, 1);
    }

    function testApproveAsOperatorSuccess() public {
        mintToOwner();

        // set stranger as operator
        vm.prank(owner);
        token.setApprovalForAll(stranger, true);

        vm.prank(stranger);
        token.approve(operator, 1);

        assertEq(token.getApproved(1), operator);
    }

    function testApproveZeroAddressSuccess() public {
        mintToOwner();

        vm.prank(owner);
        token.approve(address(0), 1);
        assertEq(token.getApproved(1), address(0));
    }
}
