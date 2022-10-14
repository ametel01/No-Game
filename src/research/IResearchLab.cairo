%lang starknet

from main.library import TechCosts
from research.library import ResearchQue

@contract_interface
namespace IResearchLab {
    func getUpgradesCost(caller: felt) -> (cost: TechCosts) {
    }

    func getQueStatus(caller: felt) -> (status: ResearchQue) {
    }

    func armourTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func armourTechUpgradeComplete(caller: felt) {
    }

    func astrophysicsUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func astrophysicsUpgradeComplete(caller: felt) {
    }

    func combustionDriveUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func combustionDriveUpgradeComplete(caller: felt) {
    }

    func computerTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func computerTechUpgradeComplete(caller: felt) {
    }

    func energyTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func energyTechUpgradeComplete(caller: felt) {
    }

    func espionageTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func espionageTechUpgradeComplete(caller: felt) {
    }

    func hyperspaceDriveUpgradeComplete(caller: felt) {
    }

    func hyperspaceTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func hyperspaceDriveUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func hyperspaceTechUpgradeComplete(caller: felt) {
    }

    func impulseDriveUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func impulseDriveUpgradeComplete(caller: felt) {
    }

    func ionTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func ionTechUpgradeComplete(caller: felt) {
    }

    func laserTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func laserTechUpgradeComplete(caller: felt) {
    }

    func plasmaTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func plasmaTechUpgradeComplete(caller: felt) {
    }

    func shieldingTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func shieldingTechUpgradeComplete(caller: felt) {
    }

    func weaponsTechUpgradeStart(caller: felt, current_tech_level: felt) -> (
        metal_required: felt, crystal_required: felt, deuterium_required: felt, time_end: felt
    ) {
    }

    func weaponsTechUpgradeComplete(caller: felt) {
    }
}
