%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256
from tests.interfaces import ERC721, Minter, NoGame
from token.erc721.interfaces.IERC721 import IERC721
from tests.conftest import Contracts, _get_test_addresses, _run_modules_manager

const ERC721_NAME = 0x4e6f47616d6520
const ERC721_SYMBOL = 0x4f474d302e31
const URI_LEN = 1
const URI = 10101010
const PK = 11111

@external
func test_erc721_constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    let (name) = ERC721.name(addresses.erc721)
    assert name = ERC721_NAME

    let (symbol) = ERC721.symbol(addresses.erc721)
    assert symbol = ERC721_SYMBOL

    let (owner) = ERC721.owner(addresses.erc721)
    assert owner = addresses.minter

    return ()
end

@external
func test_minter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    %{ stop_prank_callable = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.minter) %}
    Minter.setNFTaddress(addresses.minter, addresses.erc721)
    Minter.setNFTapproval(addresses.minter, addresses.owner, TRUE)
    Minter.mintAll(addresses.minter, 10, Uint256(1, 0))

    let (is_approved) = ERC721.isApprovedForAll(addresses.erc721, addresses.minter, addresses.owner)
    assert is_approved = TRUE

    let exp_balance = Uint256(10, 0)
    let (actual_balance) = ERC721.balanceOf(addresses.erc721, addresses.minter)
    assert actual_balance = exp_balance

    let (owner_of) = ERC721.ownerOf(addresses.erc721, Uint256(1, 0))
    assert owner_of = addresses.minter

    return ()
end

# TODO: TEST 'ownerToPlanet' on ERC721
@external
func test_erc721_transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)

    %{
        stop_prank_callable1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game)
        stop_prank_callable2 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.minter)
    %}
    Minter.setNFTaddress(addresses.minter, addresses.erc721)
    Minter.setNFTapproval(addresses.minter, addresses.game, TRUE)
    Minter.mintAll(addresses.minter, 10, Uint256(1, 0))
    NoGame.generatePlanet(addresses.game)

    let token_id = Uint256(1, 0)
    let (actual_id) = IERC721.ownerToPlanet(addresses.erc721, addresses.owner)
    assert actual_id = token_id

    return ()
end
