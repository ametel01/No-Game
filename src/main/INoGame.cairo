%lang starknet

from starkware.cairo.common.uint256 import Uint256
from main.structs import TechLevels, BuildingQue

@contract_interface
namespace INoGame:
    func getNumberOfPlanets() -> (n_planets : felt):
    end

    func ownerOf(address : felt) -> (planet_id : Uint256):
    end

    func getTokensAddresses() -> (
        erc721 : felt, erc20_metal : felt, erc20_crystal : felt, erc20_deuterium : felt
    ):
    end

    func getResourcesBuildingsLevels(caller : felt) -> (
        metal_mine : felt, crystal_mine : felt, deuterium_mine : felt, solar_plant : felt
    ):
    end

    func getFacilitiesLevels(caller : felt) -> (
        robot_factory : felt, shipyard : felt, research_lab : felt, nanite_factory : felt
    ):
    end

    func getBuildingQueStatus(caller : felt) -> (que_status : BuildingQue):
    end

    func getTechLevels(caller : felt) -> (result : TechLevels):
    end
end
