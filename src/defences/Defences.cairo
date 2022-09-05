%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from defences.library import Defences, DefenceQue, DefenceCosts

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    no_game_address: felt
) {
    Defences.initializer(no_game_address);
    return ();
}

// ##############################################################################################
//                                       VIEW FUNCS                                             #
//###############################################################################################

@external
func getQueStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (status: DefenceQue) {
    let (res) = Defences.que_status(caller);
    return (res,);
}

@external
func getDefenceCost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    costs: DefenceCosts
) {
    let (costs) = Defences.defences_cost();
    return (costs,);
}

//#######################################################################################################
//                                   BUILD FUNCTION                                                     #
// ######################################################################################################

@external
func rocketBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.rocket_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func rocketBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Defences.rocket_build_complete(caller);
    return (units_produced,);
}

@external
func lightLaserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.light_laser_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func lightLaserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Defences.light_laser_build_complete(caller);
    return (units_produced,);
}

@external
func heavyLaserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.heavy_laser_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func heavyLaserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Defences.heavy_laser_build_complete(caller);
    return (units_produced,);
}

@external
func ionCannonBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.ion_cannon_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func ionCannonBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Defences.ion_cannon_build_complete(caller);
    return (units_produced,);
}

@external
func gaussBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.gauss_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func gaussBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Defences.gauss_build_complete(caller);
    return (units_produced,);
}

@external
func plasmaTurretBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.plasma_turret_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func plasmaTurretBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Defences.plasma_turret_build_complete(caller);
    return (units_produced,);
}

@external
func smallDomeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.small_dome_build_start(caller);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func smallDomeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) {
    Defences.small_dome_build_complete(caller);
    return ();
}

@external
func largeDomeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Defences.large_dome_build_start(caller);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func largeDomeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) {
    Defences.large_dome_build_complete(caller);
    return ();
}
