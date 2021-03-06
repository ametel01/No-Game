%lang starknet

from starkware.cairo.common.uint256 import Uint256

from main.structs import TechLevels

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

    func resources_available(caller : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, energy : felt
    ):
    end

    # func get_structures_upgrade_cost(caller : felt) -> (
    #     metal_mine : Cost,
    #     crystal_mine : Cost,
    #     deuterium_mine : Cost,
    #     solar_plant : Cost,
    #     robot_factory : Cost,
    # ):
    # end

    func getTechLevels(caller : felt) -> (result : TechLevels):
    end

    # func build_time_completion(caller : felt) -> (timestamp : felt):
    # end

    # func get_buildings_timelock_status(caller : felt) -> (status : BuildingQue):
    # end

    # func is_building_qued(caller : felt, building_id : felt) -> (result : felt):
    # end

    # func player_points(caller : felt) -> (points : felt):
    # end

    # func erc20_addresses(metal_token : felt, crystal_token : felt, deuterium_token : felt):
    # end

    # func generate_planet():
    # end

    # func collect_resources():
    # end

    # func metal_upgrade_start() -> (end_time : felt):
    # end

    # func metal_upgrade_complete():
    # end

    # func crystal_upgrade_start() -> (end_time : felt):
    # end

    # func crystal_upgrade_complete():
    # end

    # func deuterium_upgrade_start() -> (end_time : felt):
    # end

    # func deuterium_upgrade_complete():
    # end

    # func solar_plant_upgrade_start() -> (end_time : felt):
    # end

    # func solar_plant_upgrade_complete():
    # end

    # func robot_factory_upgrade_start() -> (end_time : felt):
    # end

    # func robot_factory_upgrade_complete():
    # end

    # func shipyard_upgrade_start() -> (end_time : felt):
    # end

    # func shipyard_factory_upgrade_complete():
    # end
end
