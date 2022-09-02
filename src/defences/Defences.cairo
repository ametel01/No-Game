%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from defences.library import Defence, DefenceQue, DefenceCosts

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    no_game_address : felt
):
    Defence.initializer(no_game_address)
    return ()
end

# ##############################################################################################
#                                       VIEW FUNCS                                             #
################################################################################################

@external
func getQueStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (status : DefenceQue):
    let (res) = Defence.que_status(caller)
    return (res)
end

@external
func getDefenceCost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    costs : ShipsCosts
):
    let (costs) = Defence.defences_cost()
    return (costs)
end

########################################################################################################
#                                   BUILD FUNCTION                                                     #
# ######################################################################################################

@external
func rocketBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defence.rocket_build_start(caller, number_of_units)
    return (metal_required, crystal_required, deuterium_required, time_end)
end

@external
func rocketBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt):
    let (units_produced) = Defence.rocket_build_complete(caller)
    return (units_produced)
end

@external
func lightLaserBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defence.light_laser_build_start(caller, number_of_units)
    return (metal_required, crystal_required, deuterium_required, time_end)
end

@external
func lightLaserBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt):
    let (units_produced) = Defence.light_laser_build_complete(caller)
    return (units_produced)
end

@external
func heavyLaserBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defence.heavy_laser_build_start(caller, number_of_units)
    return (metal_required, crystal_required, deuterium_required, time_end)
end

@external
func heavyLaserBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt):
    let (units_produced) = Defence.heavy_laser_build_complete(caller)
    return (units_produced)
end

@external
func gaussBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defence.gauss_build_start(caller, number_of_units)
    return (metal_required, crystal_required, deuterium_required, time_end)
end

@external
func gaussBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt):
    let (units_produced) = Defence.gauss_build_complete(caller)
    return (units_produced)
end

@external
func plasmaTurretBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defence.plasma_turret_build_start(caller, number_of_units)
    return (metal_required, crystal_required, deuterium_required, time_end)
end

@external
func plasmaTurretBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt):
    let (units_produced) = Defence.plasma_turret_build_complete(caller)
    return (units_produced)
end

@external
func smallDomeBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defence.small_dome_build_start(caller)
    return (metal_required, crystal_required, deuterium_required, time_end)
end

@external
func smallDomeBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt):
    let (units_produced) = Defence.small_dome_build_complete(caller)
    return (units_produced)
end

@external
func largeDomeBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defence.large_dome_build_start(caller)
    return (metal_required, crystal_required, deuterium_required, time_end)
end

@external
func largeDomeBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (unit_produced : felt):
    let (units_produced) = Defence.large_dome_build_complete(caller)
    return (units_produced)
end
