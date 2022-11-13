// https://github.com/playoasis/starknet-contracts/blob/main/contracts/token/ERC721_Metadata_base.cairo

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_check
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.introspection.erc165.library import ERC165
from utils.lib import uint256_to_ss, concat_arr

//
// Storage
//

@storage_var
func ERC721_base_token_uri(index: felt) -> (res: felt) {
}

@storage_var
func ERC721_base_token_uri_len() -> (res: felt) {
}

//
// Constructor
//

func ERC721_Metadata_initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    // register IERC721_Metadata
    ERC165.register_interface(0x5b5e139f);
    return ();
}

func ERC721_Metadata_tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (token_uri_len: felt, token_uri: felt*) {
    alloc_locals;
    with_attr error_message("token_id is not a valid Uint256") {
        uint256_check(token_id);
    }
    let exists = ERC721._exists(token_id);
    assert exists = TRUE;

    let (local base_token_uri) = alloc();
    let (local base_token_uri_len) = ERC721_base_token_uri_len.read();

    _ERC721_Metadata_baseTokenURI(base_token_uri_len, base_token_uri);

    let (token_id_ss_len, token_id_ss) = uint256_to_ss(token_id);
    let postfix_len = 5;
    tempvar postfix: felt* = new (46, 106, 115, 111, 110);
    let (token_uri, token_uri_len) = concat_arr(
        base_token_uri_len, base_token_uri, token_id_ss_len, token_id_ss
    );
    let (final_uri, final_uri_len) = concat_arr(token_uri_len, token_uri, postfix_len, postfix);

    return (token_uri_len=final_uri_len, token_uri=final_uri);
}

func _ERC721_Metadata_baseTokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    base_token_uri_len: felt, base_token_uri: felt*
) {
    if (base_token_uri_len == 0) {
        return ();
    }
    let (base) = ERC721_base_token_uri.read(base_token_uri_len);
    assert [base_token_uri] = base;
    _ERC721_Metadata_baseTokenURI(
        base_token_uri_len=base_token_uri_len - 1, base_token_uri=base_token_uri + 1
    );
    return ();
}

func ERC721_Metadata_setBaseTokenURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(token_uri_len: felt, token_uri: felt*) {
    _ERC721_Metadata_setBaseTokenURI(token_uri_len, token_uri);
    ERC721_base_token_uri_len.write(token_uri_len);
    return ();
}

func _ERC721_Metadata_setBaseTokenURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(token_uri_len: felt, token_uri: felt*) {
    if (token_uri_len == 0) {
        return ();
    }
    ERC721_base_token_uri.write(index=token_uri_len, value=[token_uri]);
    _ERC721_Metadata_setBaseTokenURI(token_uri_len=token_uri_len - 1, token_uri=token_uri + 1);
    return ();
}
