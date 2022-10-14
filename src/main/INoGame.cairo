%lang starknet

from starkware.cairo.common.uint256 import Uint256
from research.library import TechLevels
from shipyard.library import Fleet
from main.library import BuildingQue

@contract_interface
namespace INoGame {
    func getNumberOfPlanets() -> (n_planets: felt) {
    }

    func ownerOf(address: felt) -> (planet_id: Uint256) {
    }

    func getTokensAddresses() -> (
        erc721: felt, erc20_metal: felt, erc20_crystal: felt, erc20_deuterium: felt
    ) {
    }

    func getResourcesBuildingsLevels(caller: felt) -> (
        metal_mine: felt, crystal_mine: felt, deuterium_mine: felt, solar_plant: felt
    ) {
    }

    func getResourcesAvailable(caller: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, energy: felt
    ) {
    }

    func getFacilitiesLevels(caller: felt) -> (
        robot_factory: felt, shipyard: felt, research_lab: felt, nanite_factory: felt
    ) {
    }

    func getBuildingQueStatus(caller: felt) -> (que_status: BuildingQue) {
    }

    func getTechLevels(caller: felt) -> (result: TechLevels) {
    }

    func getFleetLevels(caller: felt) -> (result: Fleet) {
    }
}
