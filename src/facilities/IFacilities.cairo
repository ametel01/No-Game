%lang starknet

from facilities.library import FacilitiesQue
from main.structs import Cost

@contract_interface
namespace IFacilities {
    func robotFactoryUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_unlocked: felt
    ) {
    }

    func robotFactoryUpgradeComplete(caller: felt) -> (success: felt) {
    }

    func shipyardUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_unlocked: felt
    ) {
    }

    func shipyardUpgradeComplete(caller: felt) -> (success: felt) {
    }

    func researchLabUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_unlocked: felt
    ) {
    }

    func researchLabUpgradeComplete(caller: felt) -> (success: felt) {
    }

    func naniteFactoryUpgradeStart(caller: felt) -> (
        metal_spent: felt, crystal_spent: felt, deuterium_spent: felt, time_unlocked: felt
    ) {
    }

    func naniteFactoryUpgradeComplete(caller: felt) -> (success: felt) {
    }

    func getUpgradeCost(caller: felt) -> (
        robot_factory: Cost, shipyard: Cost, research_lab: Cost, nanite_factory: Cost
    ) {
    }

    func getTimelockStatus(caller: felt) -> (cued_details: FacilitiesQue) {
    }
}
