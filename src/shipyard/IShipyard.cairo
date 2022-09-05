%lang starknet

from shipyard.library import ShipyardQue, ShipsCosts

@contract_interface
namespace IShipyard {
    func getQueStatus(caller: felt) -> (status: ShipyardQue) {
    }

    func getShipsCost() -> (costs: ShipsCosts) {
    }

    func cargoShipBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func cargoShipBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func recyclerShipBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func recyclerShipBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func espionageProbeBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func espionageProbeBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func solarSatelliteBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func solarSatelliteBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func lightFighterBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func lightFighterBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func cruiserBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func cruiserBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func battleshipBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func battleshipBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func deathstarShipBuildStart(caller: felt, number_of_units: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_end: felt
    ) {
    }

    func deathstarShipBuildComplete(caller: felt) -> (units_produced: felt) {
    }
}
