%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from fleet_movements.library import FleetMovements, EspionageReport
from main.structs import Fleet

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, no_game_address: felt
) {
    FleetMovements.initializer(no_game_address);
    return ();
}

@external
func sendSpyMission{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, fleet: Fleet, destination: Uint256
) {
    FleetMovements.send_spy_mission(caller, fleet, destination);
    return ();
}

@external
func readEspionageReport{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, mission_id: felt
) -> (res: EspionageReport) {
    let res = FleetMovements.read_espionage_report(caller, mission_id);
    return (res,);
}
