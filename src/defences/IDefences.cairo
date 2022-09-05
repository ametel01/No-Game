%lang starknet

from defences.library import DefenceQue, DefenceCosts

@contract_interface
namespace IDefences {
    func getQueStatus(caller: felt) -> (status: DefenceQue) {
    }

    func getDefenceCost(caller: felt) -> (costs: DefenceCosts) {
    }

    func rocketBuildStart(caller: felt, number_of_units: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func rocketBuildComplete(caller: felt) -> (unit_produced: felt) {
    }

    func lightLaserBuildStart(caller: felt, number_of_units: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func lightLaserBuildComplete(caller: felt) -> (unit_produced: felt) {
    }

    func heavyLaserBuildStart(caller: felt, number_of_units: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func heavyLaserBuildComplete(caller: felt) -> (unit_produced: felt) {
    }

    func ionCannonBuildStart(caller: felt, number_of_units: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func ionCannonBuildComplete(caller: felt) -> (unit_produced: felt) {
    }

    func gaussBuildStart(caller: felt, number_of_units: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func gaussBuildComplete(caller: felt) -> (unit_produced: felt) {
    }

    func plasmaTurretBuildStart(caller: felt, number_of_units: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func plasmaTurretBuildComplete(caller: felt) -> (units_produced: felt) {
    }

    func smallDomeBuildStart(caller: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func smallDomeBuildComplete(caller: felt) {
    }

    func largeDomeBuildStart(caller: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, time_end: felt
    ) {
    }

    func largeDomeBuildComplete(caller: felt) {
    }
}
