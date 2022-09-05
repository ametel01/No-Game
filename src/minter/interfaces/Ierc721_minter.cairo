%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace Ierc721_minter {
    func setNFTaddress(address: felt) {
    }

    func setNFTapproval(operator: felt, approved: felt) {
    }

    func mintAll(n: felt, token_id: Uint256) {
    }
}
