%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.bool import TRUE
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from shipyard.library import Shipyard
from main.INoGame import INoGame
from utils.formulas import Formulas

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    no_game_address : felt
):
    Shipyard.initializer(no_game_address)
    return ()
end

########################################################################################################
#                                   SHIPS UPGRADE FUNCTION                                             #
# ######################################################################################################

@external
func cargoShipBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (metal_required, crystal_required, deuterium_required) = Shipyard.cargo_ship_build_start(
        caller, number_of_units
    )
    return (metal_required, crystal_required, deuterium_required)
end

@external
func cargoShipBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt, success : felt):
    let (units_produced) = Shipyard.cargo_ship_build_complete(caller)
    return (units_produced, TRUE)
end

@external
func recyclerShipBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
    let (metal_required, crystal_required, deuterium_required) = Shipyard.recycler_ship_build_start(
        caller, number_of_units
    )
    return (metal_required, crystal_required, deuterium_required)
end

@external
func recyclerShipBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt, success : felt):
    let (units_produced) = Shipyard.recycler_ship_build_complete(caller)
    return (units_produced, TRUE)
end

@external
func espionageProbeBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = Shipyard.espionage_probe_build_start(caller, number_of_units)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func espionageProbeBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (units_produced : felt, success : felt):
    let (units_produced) = Shipyard.espionage_probe_build_complete(caller)
    return (units_produced, TRUE)
end

@external
func solarSatelliteBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = Shipyard.solar_satellite_build_start(caller, number_of_units)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func solarSatelliteBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (units_produced : felt, success : felt):
    let (units_produced) = Shipyard.solar_satellite_build_complete(caller)
    return (units_produced, TRUE)
end

@external
func lightFighterBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
    let (metal_required, crystal_required, deuterium_required) = Shipyard.light_fighter_build_start(
        caller, number_of_units
    )
    return (metal_required, crystal_required, deuterium_required)
end

@external
func lightFighterBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (units_produced : felt, success : felt):
    let (units_produced) = Shipyard.light_fighter_build_complete(caller)
    return (units_produced, TRUE)
end

@external
func cruiserBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
    let (metal_required, crystal_required, deuterium_required) = Shipyard.cruiser_build_start(
        caller, number_of_units
    )
    return (metal_required, crystal_required, deuterium_required)
end

@external
func cruiserBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (units_produced : felt, success : felt):
    let (units_produced) = Shipyard.cruiser_build_complete(caller)
    return (units_produced, TRUE)
end

@external
func battleshipBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
    let (metal_required, crystal_required, deuterium_required) = Shipyard.battleship_build_start(
        caller, number_of_units
    )
    return (metal_required, crystal_required, deuterium_required)
end

@external
func battleshipBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (units_produced : felt, success : felt):
    let (units_produced) = Shipyard.battleship_build_complete(caller)
    return (units_produced, TRUE)
end
