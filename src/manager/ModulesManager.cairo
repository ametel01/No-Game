%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.access.ownable.library import Ownable
from manager.library import ModulesManager

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) {
    Ownable.initializer(owner);
    return ();
}

@view
func getERC721Address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    address: felt
) {
    let (res) = ModulesManager.erc721_address();
    return (res,);
}

@view
func getModulesAddresses{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    resources: felt, facilities: felt, shipyard: felt, research_lab: felt, defences: felt
) {
    let (resources, facilities, shipyard, research, defences) = ModulesManager.modules_addresses();
    return (resources, facilities, shipyard, research, defences);
}

@view
func getResourcesAddresses{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    metal: felt, crystal: felt, deuterium: felt
) {
    let (metal, crystal, deuterium) = ModulesManager.resources_addresses();
    return (metal, crystal, deuterium);
}

@external
func setERC721{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_erc721(address);
    return ();
}

@external
func setMetal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_metal(address);
    return ();
}

@external
func setCrystal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_crystal(address);
    return ();
}

@external
func setDeuterium{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_deuterium(address);
    return ();
}

@external
func setResources{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_resources(address);
    return ();
}

@external
func setFacilities{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_facilities(address);
    return ();
}

@external
func setShipyard{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_shipyard(address);
    return ();
}

@external
func setResearch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_research(address);
    return ();
}

@external
func setDefences{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    ModulesManager.set_defences(address);
    return ();
}
