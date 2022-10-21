%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from manager.IModulesManager import IModulesManager as Manager
from tests.setup import Contracts, deploy_game

@external
func test_manager{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let addresses: Contracts = deploy_game();
    %{ stop_prank_callable = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.manager) %}
    Manager.setERC721(addresses.manager, addresses.erc721);
    Manager.setMetal(addresses.manager, addresses.metal);
    Manager.setCrystal(addresses.manager, addresses.crystal);
    Manager.setDeuterium(addresses.manager, addresses.deuterium);
    let (registered_erc721) = Manager.getERC721Address(addresses.manager);
    let (reg_metal, reg_crystal, reg_deuterium) = Manager.getResourcesAddresses(addresses.manager);
    assert registered_erc721 = addresses.erc721;
    assert reg_metal = addresses.metal;
    assert reg_crystal = addresses.crystal;
    assert reg_deuterium = addresses.deuterium;

    Manager.setResources(addresses.manager, addresses.resources);
    Manager.setFacilities(addresses.manager, addresses.facilities);
    Manager.setShipyard(addresses.manager, addresses.shipyard);
    Manager.setResearch(addresses.manager, addresses.research);
    Manager.setDefences(addresses.manager, addresses.defences);
    let (
        _resources, _facilities, _shipyard, _research, _defences, _fleet
    ) = Manager.getModulesAddresses(addresses.manager);
    assert _resources = addresses.resources;
    assert _facilities = addresses.facilities;
    assert _shipyard = addresses.shipyard;
    assert _research = addresses.research;
    assert _defences = addresses.defences;
    return ();
}

@external
func test_permissions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let addresses: Contracts = deploy_game();
    %{
        stop_prank_callable1 = start_prank(ids.addresses.p1, target_contract_address=ids.addresses.manager)
        expect_revert(error_message="Ownable: caller is not the owner")
    %}
    Manager.setERC721(addresses.manager, addresses.erc721);
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    Manager.setMetal(addresses.manager, addresses.metal);
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    Manager.setCrystal(addresses.manager, addresses.crystal);
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    Manager.setDeuterium(addresses.manager, addresses.deuterium);
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    Manager.setResources(addresses.manager, addresses.resources);
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    Manager.setFacilities(addresses.manager, addresses.facilities);
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    Manager.setShipyard(addresses.manager, addresses.shipyard);
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    Manager.setResearch(addresses.manager, addresses.research);
    return ();
}

@external
func test_reentrant{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let addresses: Contracts = deploy_game();

    %{ stop_prank_callable = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.manager) %}
    Manager.setERC721(addresses.manager, addresses.erc721);
    %{ expect_revert(error_message="ReentrancyGuard: reentrant call") %}
    Manager.setERC721(addresses.manager, addresses.erc721);
    %{ expect_revert(error_message="ReentrancyGuard: reentrant call") %}
    Manager.setMetal(addresses.manager, addresses.metal);
    %{ expect_revert(error_message="ReentrancyGuard: reentrant call") %}
    Manager.setCrystal(addresses.manager, addresses.crystal);
    %{ expect_revert(error_message="ReentrancyGuard: reentrant call") %}
    Manager.setDeuterium(addresses.manager, addresses.deuterium);
    return ();
}
