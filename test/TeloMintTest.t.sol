// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "src/Telo.sol";
import "./Constants.t.sol";


contract TeloMintTest is Constants {

    // Minting Tests
    function testMint() public {
        mintToOwner();

        assertEq(token.balanceOf(owner), 1);
        assertEq(token.ownerOf(1), owner);
    }

    function testMintToZeroAddress() public {
        vm.expectRevert(Telo.TransferToZeroAddressError.selector);
        token.mint(address(0));
    }

    function testMintMultiple() public {
        vm.startPrank(owner);
        token.mint(owner);
        token.mint(owner);
        vm.stopPrank();

        assertEq(token.balanceOf(owner), 2);
        assertEq(token.ownerOf(1), owner);
        assertEq(token.ownerOf(2), owner);
    }
}