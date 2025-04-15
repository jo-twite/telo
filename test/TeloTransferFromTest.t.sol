// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "src/Telo.sol";
import "./Constants.t.sol";


/**
 * transferFrom par owner DONE
 * transferFrom par approved DONE
 * transferFrom par opérateur autorisé DONE
 * Reverts :
 *  to == address(0) DONE
 *  unauthorizedOperator DONE
 * 
 * 
 * transferFrom: 
  *     WHEN from is not the deployer
  *         AND the deployer hasn't tokenId's approval
  *             AND depoloyer isn't an operator of from (i.e operatorApprovals[from][msg.sender]) 
  *                 THEN transfert should revert UnauthorizedOperatorError()
  *             WHEN depoloyer is an operaor of from (i.e operatorApprovals[from][msg.sender]) 
  *                 THEN transfer should be successful
  *                 AND should emit Transfer(from, to, tokenId)
  *         WHEN the depolyer has tokenId's approval
  *             THEN transfer should be successful
  *             AND should emit Transfer(from, to, tokenId)
  *     WHEN from is the deployer
  *         THEN transfer should be successful
  *         AND should emit Transfer(from, to, tokenId)
 */
contract TeloTransferFromTest is Constants {

    
    function testTransferAsOwnerIsSuccessful() public {
        vm.prank(owner);
        token.mint(owner);

        vm.prank(owner);
        token.transferFrom(owner, receiver, 1);

        assertEq(token.ownerOf(1), receiver);
        assertEq(token.balanceOf(owner), 0);
        assertEq(token.balanceOf(receiver), 1);
    }

    function testTransferAsApprovedIsSuccessful() public {
        vm.prank(owner);
        token.mint(owner);

        vm.prank(owner);
        token.approve(operator, 1);

        vm.prank(operator);
        token.transferFrom(owner, receiver, 1);

        assertEq(token.ownerOf(1), receiver);
    }

    function testTransferAsOperatorIsSuccessful() public {
        vm.prank(owner);
        token.mint(owner);

        vm.prank(owner);
        token.setApprovalForAll(operator, true);

        vm.prank(operator);
        token.transferFrom(owner, receiver, 1);

        assertEq(token.ownerOf(1), receiver);
    }

    function testTransferToZeroAddressIsReverted() public {
        mintToOwner();

        vm.expectRevert(Telo.TransferToZeroAddressError.selector);
        token.transferFrom(owner, address(0), 1);
    }

    function testUnauthorizedTransferIsReverted() public {
        mintToOwner();

        vm.prank(stranger);
        vm.expectRevert(Telo.UnauthorizedOperatorError.selector);
        token.transferFrom(owner, receiver, 1);
    }
    
}

