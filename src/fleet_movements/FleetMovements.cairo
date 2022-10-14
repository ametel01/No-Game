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
    planet_id: Uint256, fleet: Fleet, destination: Uint256
) -> (res: EspionageReport) {
    let report = FleetMovements.send_spy_mission(planet_id, fleet, destination);
    return (report,);
}
