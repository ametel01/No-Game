%lang starknet

from starkware.cairo.common.uint256 import Uint256
from fleet_movements.library import EspionageReport
from main.structs import Fleet, FleetQue

@contract_interface
namespace IFleetMovements {
    func getQueStatus(caller: felt, mission_id: felt) -> (res: FleetQue) {
    }

    func sendSpyMission(caller: felt, fleet: Fleet, destination: Uint256) -> (mission_id: felt) {
    }

    func readEspionageReport(caller: felt, mission_id: felt) -> (res: EspionageReport) {
    }
}
