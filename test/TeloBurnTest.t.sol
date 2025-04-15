// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/Telo.sol";
import "./Constants.t.sol";

contract TeloBurnTest is Constants {


    // Burning Tests
    function testBurn() public {
        mintToOwner();

        vm.prank(owner);
        token.burn(1);

        assertEq(token.balanceOf(owner), 0);
        
        vm.expectRevert(Telo.InValidNFTError.selector);
        token.ownerOf(1);
    }

    function testBurnNonExistent() public {
        vm.expectRevert(Telo.InValidNFTError.selector);
        token.burn(1);
    }

    function testBurnUnauthorized() public {
        mintToOwner();

        vm.expectRevert(Telo.UnauthorizedOperatorError.selector);
        token.burn(1);
    }
}