%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from resources.library import Resources

# @view
# func getTimelockStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ):
#     let (building_id, timelock_end) = Resources.timelock_status(caller)

# return (building_id, timelock_end)
# end

@external
func metalUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, time_unlocked : felt):
    let (metal_required, crystal_required, time_unlocked) = Resources.metal_upgrade_start(caller)
    return (metal_required, crystal_required, time_unlocked)
end

@external
func metalUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (success : felt):
    Resources.metal_upgrade_complete(caller)
    return (TRUE)
end

@external
func crystalUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, time_unlocked : felt):
    let (metal_required, crystal_required, time_unlocked) = Resources.crystal_upgrade_start(caller)
    return (metal_required, crystal_required, time_unlocked)
end

@external
func crystalUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (success : felt):
    Resources.crystal_upgrade_complete(caller)
    return (TRUE)
end

@external
func deuteriumUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, time_unlocked : felt):
    let (metal_required, crystal_required, time_unlocked) = Resources.deuterium_upgrade_start(
        caller
    )
    return (metal_required, crystal_required, time_unlocked)
end

@external
func deuteriumUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (success : felt):
    Resources.deuterium_upgrade_complete(caller)
    return (TRUE)
end

@external
func solarPlantUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, time_unlocked : felt):
    let (metal_required, crystal_required, time_unlocked) = Resources.solar_plant_upgrade_start(
        caller
    )
    return (metal_required, crystal_required, time_unlocked)
end

@external
func solarPlantUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (success : felt):
    Resources.solar_plant_upgrade_complete(caller)
    return (TRUE)
end
