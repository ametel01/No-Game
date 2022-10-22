%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from fleet_movements.library import FleetQue, FleetMovements, EspionageReport
from main.structs import Fleet

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    no_game_address: felt
) {
    FleetMovements.initializer(no_game_address);
    return ();
}

@view
func getQueStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, mission_id: felt
) -> (res: FleetQue) {
    let res = FleetMovements.get_que_status(caller, mission_id);
    return (res,);
}

@external
func sendSpyMission{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, ships: Fleet, destination: Uint256
) -> (mission_id: felt, fuel_consumption: felt) {
    let (mission_id, fuel_consumption) = FleetMovements.send_spy_mission(
        caller, ships, destination
    );
    return (mission_id, fuel_consumption);
}

@external
func readEspionageReport{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, mission_id: felt
) -> (res: EspionageReport) {
    let res = FleetMovements.read_espionage_report(caller, mission_id);
    return (res,);
}
