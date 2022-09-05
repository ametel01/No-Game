// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.3.2 (token/erc721/IERC721.cairo)

%lang starknet

from starkware.cairo.common.uint256 import Uint256

from openzeppelin.introspection.erc165.IERC165 import IERC165

@contract_interface
namespace IERC721 {
    func balanceOf(owner: felt) -> (balance: Uint256) {
    }

    func ownerOf(tokenId: Uint256) -> (owner: felt) {
    }

    func safeTransferFrom(from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*) {
    }

    func transferFrom(from_: felt, to: felt, tokenId: Uint256) {
    }

    func approve(approved: felt, tokenId: Uint256) {
    }

    func setApprovalForAll(operator: felt, approved: felt) {
    }

    func getApproved(tokenId: Uint256) -> (approved: felt) {
    }

    func isApprovedForAll(owner: felt, operator: felt) -> (isApproved: felt) {
    }

    func mint(to: felt, token_id: Uint256) {
    }

    func ownerToPlanet(owner: felt) -> (tokenId: Uint256) {
    }
}
