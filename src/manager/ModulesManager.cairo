%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.access.ownable import Ownable_initializer
from manager.library import ModulesManager

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt):
    Ownable_initializer(owner)
    return ()
end

@view
func getERC721Address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    address : felt
):
    let (res) = ModulesManager.erc721_address()
    return (res)
end

@view
func getModulesAddresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    robot_factory : felt, shipyard : felt, research_lab : felt, nanite_factory : felt
):
    let (resources, facilities, shipyard, research) = ModulesManager.modules_addresses()
    return (resources, facilities, shipyard, research)
end

@view
func getResourcesAddresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    metal : felt, crystal : felt, deuterium : felt
):
    let (metal, crystal, deuterium) = ModulesManager.resources_addresses()
    return (metal, crystal, deuterium)
end

@external
func setMetal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(address : felt):
    ModulesManager.set_metal(address)
    return ()
end

@external
func setCrystal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(address : felt):
    ModulesManager.set_crystal(address)
    return ()
end

@external
func setDeuterium{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
):
    ModulesManager.set_deuterium(address)
    return ()
end

@external
func setResources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
):
    ModulesManager.set_resources(address)
    return ()
end

@external
func setFacilities{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
):
    ModulesManager.set_facilities(address)
    return ()
end

@external
func setShipyard{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(address : felt):
    ModulesManager.set_shipyard(address)
    return ()
end

@external
func setResearch{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(address : felt):
    ModulesManager.set_research(address)
    return ()
end
