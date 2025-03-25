// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "forge-std/Test.sol";
import "src/Telo.sol";

contract TeloTest is Test {
    Telo private telo;
    address private owner = address(0x123);
    address private operator = address(0x456);
    address private receiver = address(0x789);

    function setUp() public {
        telo = new Telo();
    }

    // Minting Tests
    function testMint() public {
        vm.prank(owner);
        telo.mint(owner);

        assertEq(telo.balanceOf(owner), 1);
        assertEq(telo.ownerOf(1), owner);
    }

    function testMintToZeroAddress() public {
        vm.expectRevert(Telo.TransferToZeroAddressError.selector);
        telo.mint(address(0));
    }

    function testMintMultiple() public {
        vm.startPrank(owner);
        telo.mint(owner);
        telo.mint(owner);
        vm.stopPrank();

        assertEq(telo.balanceOf(owner), 2);
        assertEq(telo.ownerOf(1), owner);
        assertEq(telo.ownerOf(2), owner);
    }

    // Burning Tests
    function testBurn() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.prank(owner);
        telo.burn(1);

        assertEq(telo.balanceOf(owner), 0);
        
        vm.expectRevert(Telo.InValidNFTError.selector);
        telo.ownerOf(1);
    }

    function testBurnNonExistent() public {
        vm.expectRevert(Telo.InValidNFTError.selector);
        telo.burn(1);
    }

    function testBurnUnauthorized() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.expectRevert(Telo.UnauthorizedOperatorError.selector);
        telo.burn(1);
    }

    // Approval Tests
    function testApprove() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.prank(owner);
        telo.approve(operator, 1);

        assertEq(telo.getApproved(1), operator);
    }

    function testApproveZeroAddress() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.prank(owner);
        telo.approve(address(0), 1);
        assertEq(telo.getApproved(1), address(0));
    }

    // Approval For All Tests
    function testSetApprovalForAll() public {
        vm.prank(owner);
        telo.setApprovalForAll(operator, true);

        assertTrue(telo.isApprovedForAll(owner, operator));

        vm.prank(owner);
        telo.setApprovalForAll(operator, false);
        assertFalse(telo.isApprovedForAll(owner, operator));
    }

    // Transfer Tests
    function testTransferFrom() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.prank(owner);
        telo.transferFrom(owner, receiver, 1);

        assertEq(telo.ownerOf(1), receiver);
        assertEq(telo.balanceOf(owner), 0);
        assertEq(telo.balanceOf(receiver), 1);
    }

    function testTransferToZeroAddress() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.expectRevert(Telo.TransferToZeroAddressError.selector);
        telo.transferFrom(owner, address(0), 1);
    }

    function testUnauthorizedTransfer() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.expectRevert(Telo.UnauthorizedOperatorError.selector);
        telo.transferFrom(owner, receiver, 1);
    }

    function testTransferWithApproval() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.prank(owner);
        telo.approve(operator, 1);

        vm.prank(operator);
        telo.transferFrom(owner, receiver, 1);

        assertEq(telo.ownerOf(1), receiver);
    }

    function testTransferWithApprovalForAll() public {
        vm.prank(owner);
        telo.mint(owner);

        vm.prank(owner);
        telo.setApprovalForAll(operator, true);

        vm.prank(operator);
        telo.transferFrom(owner, receiver, 1);

        assertEq(telo.ownerOf(1), receiver);
    }
}
