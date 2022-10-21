%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from openzeppelin.access.ownable.library import Ownable

@storage_var
func ModulesManager_erc721_token_address() -> (address: felt) {
}

// @dev Returns the address of the owner of the ERC721 contract.
@storage_var
func ModulesManager_owner_address() -> (address: felt) {
}

// @dev Returns the address of the ERC20 metal address.
@storage_var
func ModulesManager_metal_address() -> (address: felt) {
}

// @dev Returns the address of the ERC20 crystal address.
@storage_var
func ModulesManager_crystal_address() -> (address: felt) {
}

// @dev Returns the address of the ERC20 deuterium address.
@storage_var
func ModulesManager_deuterium_address() -> (address: felt) {
}

@storage_var
func ModulesManager_resources_address() -> (address: felt) {
}

@storage_var
func ModulesManager_facilities_address() -> (address: felt) {
}

@storage_var
func ModulesManager_shipyard_address() -> (address: felt) {
}

@storage_var
func ModulesManager_research_lab_address() -> (address: felt) {
}

@storage_var
func ModulesManager_defences_address() -> (address: felt) {
}

@storage_var
func ModulesManager_fleet_movements_address() -> (address: felt) {
}

@storage_var
func ReentrancyGuard_erc721_entered() -> (entered: felt) {
}

@storage_var
func ReentrancyGuard_metal_entered() -> (entered: felt) {
}

@storage_var
func ReentrancyGuard_crystal_entered() -> (entered: felt) {
}

@storage_var
func ReentrancyGuard_deuterium_entered() -> (entered: felt) {
}

namespace ModulesManager {
    func erc721_reentrancy_start{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) {
        let (has_entered) = ReentrancyGuard_erc721_entered.read();
        with_attr error_message("ReentrancyGuard: reentrant call") {
            assert has_entered = FALSE;
        }
        ReentrancyGuard_erc721_entered.write(TRUE);
        return ();
    }

    func metal_reentrancy_start{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (has_entered) = ReentrancyGuard_metal_entered.read();
        with_attr error_message("ReentrancyGuard: reentrant call") {
            assert has_entered = FALSE;
        }
        ReentrancyGuard_metal_entered.write(TRUE);
        return ();
    }

    func crystal_reentrancy_start{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) {
        let (has_entered) = ReentrancyGuard_crystal_entered.read();
        with_attr error_message("ReentrancyGuard: reentrant call") {
            assert has_entered = FALSE;
        }
        ReentrancyGuard_crystal_entered.write(TRUE);
        return ();
    }

    func deuterium_reentrancy_start{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        let (has_entered) = ReentrancyGuard_deuterium_entered.read();
        with_attr error_message("ReentrancyGuard: reentrant call") {
            assert has_entered = FALSE;
        }
        ReentrancyGuard_deuterium_entered.write(TRUE);
        return ();
    }

    func erc721_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        address: felt
    ) {
        let (address) = ModulesManager_erc721_token_address.read();
        return (address,);
    }

    func modules_addresses{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        resources: felt,
        facilities: felt,
        shipyard: felt,
        research: felt,
        defences: felt,
        fleet_movements: felt,
    ) {
        let (resources) = ModulesManager_resources_address.read();
        let (facilities) = ModulesManager_facilities_address.read();
        let (shipyard) = ModulesManager_shipyard_address.read();
        let (research) = ModulesManager_research_lab_address.read();
        let (defences) = ModulesManager_defences_address.read();
        let (fleet) = ModulesManager_fleet_movements_address.read();
        return (resources, facilities, shipyard, research, defences, fleet);
    }

    func resources_addresses{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        metal: felt, crystal: felt, deuterium: felt
    ) {
        let (metal) = ModulesManager_metal_address.read();
        let (crystal) = ModulesManager_crystal_address.read();
        let (deuterium) = ModulesManager_deuterium_address.read();
        return (metal, crystal, deuterium);
    }

    //#########################################################################################
    //                                      PUBLIC FUNCTIONS                                  #
    //#########################################################################################

    func set_erc721{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_erc721_token_address.write(address);
        return ();
    }

    func set_metal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
        Ownable.assert_only_owner();
        ModulesManager_metal_address.write(address);
        return ();
    }

    func set_crystal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_crystal_address.write(address);
        return ();
    }

    func set_deuterium{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_deuterium_address.write(address);
        return ();
    }

    func set_resources{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_resources_address.write(address);
        return ();
    }

    func set_facilities{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_facilities_address.write(address);
        return ();
    }

    func set_shipyard{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_shipyard_address.write(address);
        return ();
    }

    func set_research{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_research_lab_address.write(address);
        return ();
    }

    func set_defences{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        Ownable.assert_only_owner();
        ModulesManager_defences_address.write(address);
        return ();
    }

    func set_fleet{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
        Ownable.assert_only_owner();
        ModulesManager_fleet_movements_address.write(address);
        return ();
    }
}
