%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from shipyard.library import Shipyard, ShipyardQue, ShipsCosts

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    no_game_address: felt
) {
    Shipyard.initializer(no_game_address);
    return ();
}

@external
func getQueStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (status: ShipyardQue) {
    let (res) = Shipyard.que_status(caller);
    return (res,);
}

@external
func getShipsCost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    costs: ShipsCosts
) {
    let (costs) = Shipyard.ships_cost();
    return (costs,);
}

//#######################################################################################################
//                                   BUILD FUNCTION                                                     #
// ######################################################################################################

@external
func cargoShipBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Shipyard.cargo_ship_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func cargoShipBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Shipyard.cargo_ship_build_complete(caller);
    return (units_produced,);
}

@external
func recyclerShipBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Shipyard.recycler_ship_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func recyclerShipBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (unit_produced: felt) {
    let (units_produced) = Shipyard.recycler_ship_build_complete(caller);
    return (units_produced,);
}

@external
func espionageProbeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Shipyard.espionage_probe_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func espionageProbeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (units_produced: felt) {
    let (units_produced) = Shipyard.espionage_probe_build_complete(caller);
    return (units_produced,);
}

@external
func solarSatelliteBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Shipyard.solar_satellite_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func solarSatelliteBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (units_produced: felt) {
    let (units_produced) = Shipyard.solar_satellite_build_complete(caller);
    return (units_produced,);
}

@external
func lightFighterBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Shipyard.light_fighter_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func lightFighterBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (units_produced: felt) {
    let (units_produced) = Shipyard.light_fighter_build_complete(caller);
    return (units_produced,);
}

@external
func cruiserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Shipyard.cruiser_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func cruiserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (units_produced: felt) {
    let (units_produced) = Shipyard.cruiser_build_complete(caller);
    return (units_produced,);
}

@external
func battleshipBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, number_of_units: felt
) -> (metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_end
    ) = Shipyard.battleship_build_start(caller, number_of_units);
    return (metal_required, crystal_required, deuterium_required, time_end);
}

@external
func battleshipBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (units_produced: felt) {
    let (units_produced) = Shipyard.battleship_build_complete(caller);
    return (units_produced,);
}
