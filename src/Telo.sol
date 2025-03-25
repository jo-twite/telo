// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./interfaces/IERC721.sol";

contract Telo is IERC721 {

    uint256 private id;

    mapping(address => uint) balances;

    mapping(uint256 => address) owners;

    // Retrive approved address using token ID
    mapping(uint256 => address) private approvedAddresses;

    // Retrieve operator approvals from owner address
    mapping(address => mapping(address => bool)) private operatorApprovals;
    
    error TransferToZeroAddressError();
    error InValidNFTError();
    error UnauthorizedOperatorError();

    function balanceOf(address owner) external view returns (uint256) {
        return balances[owner];
    }


    function ownerOf(uint256 tokenId) external view returns (address) {
        address owner = owners[tokenId];
        if (owner == address(0)) revert InValidNFTError();
        return owner;
    }
    

    function transferFrom(address from, address to, uint256 tokenId) external payable {
        // shouldn't burn
        if(to == address(0)) {
            revert TransferToZeroAddressError();
        }


        // @tokenId should be owned by @from
        if(from != owners[tokenId]) {
            revert InValidNFTError();
        }
        
        // @sender should be the owner or an authorized operator
        if(msg.sender != from
        && msg.sender != approvedAddresses[tokenId]
        && !operatorApprovals[from][msg.sender]) {
            revert UnauthorizedOperatorError();
        }
        
        //require( msg.sender == from
        //|| msg.sender == approvedAddresses[tokenId]
        //|| operatorApprovals[from][msg.sender], 
        //UnauthorizedOperatorError());

        balances[from] -= 1;
        balances[to] += 1;        
        owners[tokenId] = to;

        approvedAddresses[tokenId] = address(0);
        emit Transfer(from, to, tokenId);
    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param approved The new approved NFT controller
    /// @param tokenId The NFT to approve
    function approve(address approved, uint256 tokenId) external payable {
        address owner = owners[tokenId];
        // sender should be owner or an authorized operator
        if(owner != msg.sender && !operatorApprovals[owner][msg.sender]) {
            revert UnauthorizedOperatorError(); 
        }
        //require(owner == msg.sender || operatorApprovals[owner][msg.sender], UnauthorizedOperatorError());
        approvedAddresses[tokenId] = approved;

        emit Approval(owner, approved, tokenId);
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external {
         operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 tokenId) external view returns (address) {
        if(owners[tokenId] == address(0)) {
            revert InValidNFTError();
        }
        //require(owners[_tokenId] != address(0), InValidNFTError());
        return approvedAddresses[tokenId];
    }

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }


    function mint(address to) external {
        if(to == address(0)) {
            revert TransferToZeroAddressError();
        }
        id += 1;
        owners[id] = to;
        balances[to] +=1;

        emit Transfer(address(0), to, id);
    }

    function burn(uint256 tokenId) external {
        address owner = owners[tokenId];
        if(owner == address(0)) {
            revert InValidNFTError();
        }
        if(owner != msg.sender) {
            revert UnauthorizedOperatorError();
        }

        approvedAddresses[tokenId] = address(0);
        balances[owner] -= 1;
        delete owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
}