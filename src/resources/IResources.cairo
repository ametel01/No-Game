%lang starknet

from main.structs import Cost
from resources.library import ResourcesQue

@contract_interface
namespace IResources {
    func metalUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, time_unlocked: felt
    ) {
    }

    func metalUpgradeComplete(caller: felt) {
    }

    func crystalUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, time_unlocked: felt
    ) {
    }

    func crystalUpgradeComplete(caller: felt) {
    }

    func deuteriumUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, time_unlocked: felt
    ) {
    }

    func deuteriumUpgradeComplete(caller: felt) {
    }

    func solarPlantUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, time_unlocked: felt
    ) {
    }

    func solarPlantUpgradeComplete(caller: felt) {
    }

    func fusionReactorUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_unlocked: felt
    ) {
    }

    func fusionReactorUpgradeComplete(caller: felt) {
    }

    func getUpgradeCost(caller: felt) -> (
        metal_mine: Cost, crystal_mine: Cost, deuterium_mine: Cost, solar_plant: Cost
    ) {
    }

    func getTimelockStatus(caller: felt) -> (cued_details: ResourcesQue) {
    }
}
