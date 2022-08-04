%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from research.library import (
    _armour_tech_upgrade_cost,
    _astrophysics_upgrade_cost,
    _combustion_drive_upgrade_cost,
    _computer_tech_upgrade_cost,
    _energy_tech_upgrade_cost,
    _espionage_tech_upgrade_cost,
    _hyperspace_drive_upgrade_cost,
    _hyperspace_tech_upgrade_cost,
    _impulse_drive_upgrade_cost,
    _ion_tech_upgrade_cost,
    _laser_tech_upgrade_cost,
    _plasma_tech_upgrade_cost,
    _shielding_tech_upgrade_cost,
    _weapons_tech_upgrade_cost,
)

@external
func test_armour{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _armour_tech_upgrade_cost(level)
    return ()
end

@external
func test_astrophysics{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    level : felt
):
    _astrophysics_upgrade_cost(level)
    return ()
end

@external
func test_combustion{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    level : felt
):
    _combustion_drive_upgrade_cost(level)
    return ()
end

@external
func test_computer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _computer_tech_upgrade_cost(level)
    return ()
end

@external
func test_energy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _energy_tech_upgrade_cost(level)
    return ()
end

@external
func test_espionage{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    level : felt
):
    _espionage_tech_upgrade_cost(level)
    return ()
end

@external
func test_hyperspace_drive{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    level : felt
):
    _hyperspace_drive_upgrade_cost(level)
    return ()
end

@external
func test_hyperspace_tech{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    level : felt
):
    _hyperspace_tech_upgrade_cost(level)
    return ()
end

@external
func test_impulse{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _impulse_drive_upgrade_cost(level)
    return ()
end

@external
func test_ion{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _ion_tech_upgrade_cost(level)
    return ()
end

@external
func test_laser{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _laser_tech_upgrade_cost(level)
    return ()
end

@external
func test_plasma{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _plasma_tech_upgrade_cost(level)
    return ()
end

@external
func test_shielding{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    level : felt
):
    _shielding_tech_upgrade_cost(level)
    return ()
end

@external
func test_weapons{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level : felt):
    _weapons_tech_upgrade_cost(level)
    return ()
end
