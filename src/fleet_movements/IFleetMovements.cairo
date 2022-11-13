%lang starknet

from starkware.cairo.common.uint256 import Uint256
from fleet_movements.library import EspionageReport
from main.structs import Fleet, EspionageQue, AttackQue

@contract_interface
namespace IFleetMovements {
    func getEspionageQueStatus(caller: felt, mission_id: felt) -> (res: EspionageQue) {
    }

    func getAttackQueStatus(caller: felt, mission_id: felt) -> (res: AttackQue) {
    }

    func sendSpyMission(caller: felt, fleet: Fleet, destination: Uint256) -> (
        mission_id: felt, fuel_consumption: felt
    ) {
    }

    func readEspionageReport(caller: felt, mission_id: felt) -> (res: EspionageReport) {
    }
}
