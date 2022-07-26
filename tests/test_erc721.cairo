%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256

const ERC721_NAME = 0x4e6f47616d6520
const ERC721_SYMBOL = 0x4f474d302e31
const URI_LEN = 1
const URI = 10101010
const PK = 11111

@external
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        context.owner_address = deploy_contract("lib/cairo_contracts_git/cairo_contracts/src/openzeppelin/account/Account.cairo", [ids.PK]).contract_address
        context.minter_address = deploy_contract("src/minter/erc721_minter.cairo", [context.owner_address]).contract_address
        context.erc721_address = deploy_contract("src/token/erc721/ERC721.cairo",[ids.ERC721_NAME, ids.ERC721_SYMBOL, context.minter_address, ids.URI_LEN, ids.URI]).contract_address
    %}
    return ()
end

@contract_interface
namespace ERC721:
    func balanceOf(owner : felt) -> (balance : Uint256):
    end

    func ownerOf(tokenId : Uint256) -> (owner : felt):
    end

    func name() -> (res : felt):
    end

    func symbol() -> (res : felt):
    end

    func owner() -> (res : felt):
    end

    func tokenURI() -> (uri_len, uri):
    end

    func ownerToPlanet(owner : felt) -> (tokenId : Uint256):
    end

    func isApprovedForAll(owner : felt, operator : felt) -> (res : felt):
    end
end

@contract_interface
namespace Minter:
    func setNFTaddress(address : felt):
    end

    func setNFTapproval(operator : felt, approved : felt):
    end

    func mintAll(n : felt, token_id : Uint256):
    end
end

@external
func test_erc721_constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    tempvar owner : felt
    tempvar minter : felt
    tempvar erc721 : felt
    %{
        ids.owner = context.owner_address
        ids.minter = context.minter_address
        ids.erc721 = context.erc721_address
    %}
    let (name) = ERC721.name(erc721)
    assert name = ERC721_NAME

    let (symbol) = ERC721.symbol(erc721)
    assert symbol = ERC721_SYMBOL

    let (owner) = ERC721.owner(erc721)
    assert owner = minter

    return ()
end

@external
func test_minter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    tempvar owner : felt
    tempvar minter : felt
    tempvar erc721 : felt
    %{
        ids.owner = context.owner_address
        ids.minter = context.minter_address
        ids.erc721 = context.erc721_address
        stop_prank_callable = start_prank(ids.owner, target_contract_address=ids.minter)
    %}
    Minter.setNFTaddress(minter, erc721)
    Minter.setNFTapproval(minter, owner, TRUE)
    Minter.mintAll(minter, 10, Uint256(1, 0))

    let (is_approved) = ERC721.isApprovedForAll(erc721, minter, owner)
    assert is_approved = TRUE

    let exp_balance = Uint256(10, 0)
    let (actual_balance) = ERC721.balanceOf(erc721, minter)
    assert actual_balance = exp_balance

    let (owner_of) = ERC721.ownerOf(erc721, Uint256(1, 0))
    assert owner_of = minter

    return ()
end
