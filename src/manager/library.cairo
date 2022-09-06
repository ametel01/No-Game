%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.access.ownable.library import Ownable

@storage_var
func ModulesManager_erc721_token_address() -> (address : felt):
end

# @dev Returns the address of the owner of the ERC721 contract.
@storage_var
func ModulesManager_owner_address() -> (address : felt):
end

# @dev Returns the address of the ERC20 metal address.
@storage_var
func ModulesManager_metal_address() -> (address : felt):
end

# @dev Returns the address of the ERC20 crystal address.
@storage_var
func ModulesManager_crystal_address() -> (address : felt):
end

# @dev Returns the address of the ERC20 deuterium address.
@storage_var
func ModulesManager_deuterium_address() -> (address : felt):
end

@storage_var
func ModulesManager_resources_address() -> (address : felt):
end

@storage_var
func ModulesManager_facilities_address() -> (address : felt):
end

@storage_var
func ModulesManager_shipyard_address() -> (address : felt):
end

@storage_var
func ModulesManager_research_lab_address() -> (address : felt):
end

@storage_var
func ModulesManager_defences() -> (res: felt):
end


namespace ModulesManager:
    func erc721_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        address : felt
    ):
        let (address) = ModulesManager_erc721_token_address.read()
        return (address)
    end

    func modules_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        robot_factory : felt, shipyard : felt, research_lab : felt, nanite_factory : felt
    ):
        let (resources) = ModulesManager_resources_address.read()
        let (facilities) = ModulesManager_facilities_address.read()
        let (shipyard) = ModulesManager_shipyard_address.read()
        let (research) = ModulesManager_research_lab_address.read()
        let (defences) = ModulesManager_defences.read()
        return (resources, facilities, shipyard, research)
    end

    func resources_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (metal : felt, crystal : felt, deuterium : felt):
        let (metal) = ModulesManager_metal_address.read()
        let (crystal) = ModulesManager_crystal_address.read()
        let (deuterium) = ModulesManager_deuterium_address.read()
        return (metal, crystal, deuterium)
    end

    ##########################################################################################
    #                                      PUBLIC FUNCTIONS                                  #
    ##########################################################################################

    func set_erc721{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_erc721_token_address.write(address)
        return ()
    end

    func set_metal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_metal_address.write(address)
        return ()
    end

    func set_crystal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_crystal_address.write(address)
        return ()
    end

    func set_deuterium{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_deuterium_address.write(address)
        return ()
    end

    func set_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_resources_address.write(address)
        return ()
    end

    func set_facilities{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_facilities_address.write(address)
        return ()
    end

    func set_shipyard{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_shipyard_address.write(address)
        return ()
    end

    func set_research{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_research_lab_address.write(address)
        return ()
    end

    func set_defences{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt
    ):
        Ownable.assert_only_owner()
        ModulesManager_defences.write(address)
        return()
    end
end
