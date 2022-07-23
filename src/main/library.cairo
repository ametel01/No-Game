%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from openzeppelin.access.ownable import Ownable
from token.erc721.interfaces.IERC721 import IERC721
from utils.formulas import Formulas
from facilities.library import Facilities
from facilities.IFacilities import IFacilities
from resources.library import Resources
from resources.IResources import IResources
from manager.IModulesManager import IModulesManager
from main.storage import (
    NoGame_modules_manager,
    NoGame_number_of_planets,
    NoGame_metal_mine_level,
    NoGame_crystal_mine_level,
    NoGame_deuterium_mine_level,
    NoGame_solar_plant_level,
    NoGame_planets_spent_resources,
    NoGame_shipyard_level,
    NoGame_robot_factory_level,
    NoGame_research_lab_level,
    NoGame_nanite_factory_level,
    NoGame_energy_tech,
    NoGame_computer_tech,
    NoGame_laser_tech,
    NoGame_armour_tech,
    NoGame_astrophysics,
    NoGame_espionage_tech,
    NoGame_hyperspace_drive,
    NoGame_hyperspace_tech,
    NoGame_impulse_drive,
    NoGame_ion_tech,
    NoGame_plasma_tech,
    NoGame_weapons_tech,
    NoGame_shielding_tech,
    NoGame_combustion_drive,
    NoGame_ships_cargo,
    NoGame_ships_recycler,
    NoGame_ships_espionage_probe,
    NoGame_ships_solar_satellite,
    NoGame_ships_light_fighter,
    NoGame_ships_cruiser,
    NoGame_ships_battleship,
    NoGame_ships_deathstar,
)

from main.structs import BuildingQue, Planet, Cost, TechLevels, Fleet

namespace NoGame:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, modules_manager : felt
    ):
        Ownable.initializer(owner)
        NoGame_modules_manager.write(modules_manager)
        return ()
    end

    func number_of_planets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt
    ):
        let (n_planets) = NoGame_number_of_planets.read()
        return (n_planets)
    end

    func tokens_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        erc721 : felt, erc20_metal : felt, erc20_crystal : felt, erc20_deuterium : felt
    ):
        let (modules_manager) = NoGame_modules_manager.read()
        let (erc721) = IModulesManager.getERC721Address(modules_manager)
        let (metal, crystal, deuterium) = IModulesManager.getResourcesAddresses(modules_manager)
        return (erc721, metal, crystal, deuterium)
    end

    func modules_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        _resources, _facilities, _shipyard, _research
    ):
        let (modules_manager) = NoGame_modules_manager.read()
        let (resources, facilities, shipyard, research_lab) = IModulesManager.getModulesAddresses(
            modules_manager
        )
        return (resources, facilities, shipyard, research_lab)
    end

    # func upgrades_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    #     caller : felt
    # ) -> (
    #     up_metal : Cost,
    #     up_crystal : Cost,
    #     up_deuturium : Cost,
    #     up_solar : Cost,
    #     up_robot_factory : Cost,
    #     up_shipyard : Cost,
    #     up_lab : Cost,
    #     up_nanite : Cost,
    # ):
    #     alloc_locals
    #     let (modules_manager) = NoGame_modules_manager.read()
    #     let (erc721) = IModulesManager.getERC721Address(modules_manager)
    #     let (resources, facilities, shipyard, research_lab) = IModulesManager.getModulesAddresses()
    #     let (
    #         metal_mine, crystal_mine, deuterium_mine, solar_plant
    #     ) = IResources.getResourcesUpgradeCost(resources, caller)
    #     let (
    #         robot_factory, shipyard, research_lab, nanite_factory
    #     ) = IFacilities.getFacilitiesUpgradeCost(facilities, caller)
    #     return (
    #         metal_mine,
    #         crystal_mine,
    #         deuterium_mine,
    #         solar_plant,
    #         robot_factory,
    #         shipyard,
    #         research_lab,
    #         nanite_factory,
    #     )
    # end

    func player_points{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (points : felt):
        let (points) = _calculate_player_points(caller)
        return (points)
    end

    func resources_buildings_levels{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (
        metal_mine : felt, crystal_mine : felt, deuterium_mine : felt, solar_plant : felt
    ):
        let (planet_id) = _get_planet_id(caller)
        let (metal) = NoGame_metal_mine_level.read(planet_id)
        let (crystal) = NoGame_crystal_mine_level.read(planet_id)
        let (deuterium) = NoGame_deuterium_mine_level.read(planet_id)
        let (solar_plant) = NoGame_solar_plant_level.read(planet_id)
        return (metal, crystal, deuterium, solar_plant)
    end

    func facilities_levels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (metal_mine : felt, crystal_mine : felt, deuterium_mine : felt, solar_plant : felt):
        let (planet_id) = _get_planet_id(caller)
        let (robot_factory) = NoGame_robot_factory_level.read(planet_id)
        let (research_lab) = NoGame_research_lab_level.read(planet_id)
        let (shipyard) = NoGame_shipyard_level.read(planet_id)
        let (nanite) = NoGame_nanite_factory_level.read(planet_id)
        return (robot_factory, research_lab, shipyard, nanite)
    end

    func tech_levels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (result : TechLevels):
        let (planet_id) = _get_planet_id(caller)
        let (armour_tech) = NoGame_armour_tech.read(planet_id)
        let (astrophysics) = NoGame_astrophysics.read(planet_id)
        let (combustion_drive) = NoGame_combustion_drive.read(planet_id)
        let (computer_tech) = NoGame_computer_tech.read(planet_id)
        let (energy_tech) = NoGame_energy_tech.read(planet_id)
        let (espionage_tech) = NoGame_espionage_tech.read(planet_id)
        let (hyperspace_drive) = NoGame_hyperspace_drive.read(planet_id)
        let (hyperspace_tech) = NoGame_hyperspace_tech.read(planet_id)
        let (impulse_drive) = NoGame_impulse_drive.read(planet_id)
        let (ion_tech) = NoGame_ion_tech.read(planet_id)
        let (laser_tech) = NoGame_laser_tech.read(planet_id)
        let (plasma_tech) = NoGame_plasma_tech.read(planet_id)
        let (shielding_tech) = NoGame_shielding_tech.read(planet_id)
        let (weapons_tech) = NoGame_weapons_tech.read(planet_id)

        return (
            TechLevels(armour_tech, astrophysics, combustion_drive, computer_tech, energy_tech, espionage_tech, hyperspace_drive, hyperspace_tech, impulse_drive, ion_tech, laser_tech, plasma_tech, shielding_tech, weapons_tech),
        )
    end

    func fleet_levels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (result : TechLevels):
        let (planet_id) = _get_planet_id(caller)
        let (cargo) = NoGame_ships_cargo.read(planet_id)
        let (recycler) = NoGame_ships_recycler.read(planet_id)
        let (espionage_probe) = NoGame_ships_espionage_probe.read(planet_id)
        let (satellite) = NoGame_ships_solar_satellite.read(planet_id)
        let (light_fighter) = NoGame_ships_light_fighter.read(planet_id)
        let (cruiser) = NoGame_ships_cruiser.read(planet_id)
        let (battleship) = NoGame_ships_battleship.read(planet_id)
        let (deathstar) = NoGame_ships_deathstar.read(planet_id)
        return (
            Fleet(cargo, recycler, espionage_probe, satellite, light_fighter, cruiser, battleship, deathstar),
        )
    end

    # func get_resources_available{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    #         caller : felt
    #     ) -> (metal : felt, crystal : felt, deuterium : felt, energy : felt):
    #         alloc_locals
    #         let (planet_id) = _get_planet_id(caller)
    #         let (
    #             metal_available, crystal_available, deuterium_available
    #         ) = Resources.get_available_resources(caller)
    #         let (metal) = NoGame_metal_mine_level.read(planet_id)
    #         let (crystal) = NoGame_crystal_mine_level.read(planet_id)
    #         let (deuterium) = NoGame_deuterium_mine_level.read(planet_id)
    #         let (solar_plant) = NoGame_solar_plant_level.read(planet_id)
    #         let (energy_available) = Resources.get_net_energy(metal, crystal, deuterium, solar_plant)
    #         return (metal_available, crystal_available, deuterium_available, energy_available)
    #     end
end

##########################################################################################
#                                      PUBLIC FUNCTIONS                                  #
#########################################################################################

# func get_resources_que_status{
#         syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
#     }(caller : felt) -> (building_id : felt, timelock_end : felt):
#         let (resources_addr) = NoGame_resources_address.read()
#         let (building_id, time_end) = IResources.getBuildingTimelockStatus(resources_addr, caller)
#         return (building_id, time_end)
#     end
# end

func _get_planet_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (planet_id : Uint256):
    let (modules_manager) = NoGame_modules_manager.read()
    let (erc721) = IModulesManager.getERC721Address(modules_manager)
    let (planet_id) = IERC721.ownerToPlanet(erc721, caller)

    return (planet_id)
end

func _calculate_player_points{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (points : felt):
    let (planet_id) = _get_planet_id(caller)
    let (total_spent) = NoGame_planets_spent_resources.read(planet_id)
    let (points, _) = unsigned_div_rem(total_spent, 1000)
    return (points)
end

# func _calculate_production{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (metal : felt, crystal : felt, deuterium : felt):
#     alloc_locals
#     let (modules_manage) = NoGame_modules_manager.read()
#     let (erc721_address, _, _, _) = NoGame.token_addresses()
#     let (planet_id) = IERC721.ownerToPlanet(erc721_address, caller)
#     let (
#         metal_level, crystal_level, deuterium_level, solar_plant_level, _, _, _, _
#     ) = INoGame.getStructuresLevels(no_game_addr, caller)
#     let (time_start) = Resources_timer.read(planet_id)
#     let (energy_required_metal) = Formulas.consumption_energy(metal_level)
#     let (energy_required_crystal) = Formulas.consumption_energy(crystal_level)
#     let (energy_required_deuterium) = Formulas.consumption_energy_deuterium(deuterium_level)
#     let total_energy_required = energy_required_metal + energy_required_crystal + energy_required_deuterium
#     let (energy_available) = Formulas.solar_plant_production(solar_plant_level)
#     let (enough_energy) = is_le(total_energy_required, energy_available)
#     # Calculate amount of resources produced.
#     let (metal_produced) = Formulas.metal_mine_production(time_start, metal_level)
#     let (crystal_produced) = Formulas.crystal_mine_production(time_start, crystal_level)
#     let (deuterium_produced) = Formulas.deuterium_mine_production(time_start, deuterium_level)
#     # If energy available < than energy required scale down amount produced.
#     if enough_energy == FALSE:
#         let (actual_metal, actual_crystal, actual_deuterium) = Formulas.energy_production_scaler(
#             metal_produced,
#             crystal_produced,
#             deuterium_produced,
#             total_energy_required,
#             energy_available,
#         )
#         let metal = actual_metal
#         let crystal = actual_crystal
#         let deuterium = actual_deuterium
#         return (metal, crystal, deuterium)
#     else:
#         let metal = metal_produced
#         let crystal = crystal_produced
#         let deuterium = deuterium_produced
#         return (metal, crystal, deuterium)
#     end
# end

# func _collect_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ):
#     let (metal_produced, crystal_produced, deuterium_produced) = _calculate_production(caller)
#     _receive_resources_erc20(
#         to=caller,
#         metal_amount=metal_produced,
#         crystal_amount=crystal_produced,
#         deuterium_amount=deuterium_produced,
#     )
#     let (no_game) = Resources_no_game_address.read()
#     let (erc721_address, _, _, _) = INoGame.getTokensAddresses(no_game)
#     let (planet_id) = IERC721.ownerToPlanet(erc721_address, caller)
#     let (time_now) = get_block_timestamp()
#     Resources_timer.write(planet_id, time_now)
#     return ()
# end

# func _receive_resources_erc20{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     to : felt, metal_amount : felt, crystal_amount : felt, deuterium_amount : felt
# ):
#     let (no_game) = Resources_no_game_address.read()
#     let (_, metal_address, crystal_address, deuterium_address) = INoGame.getTokensAddresses(no_game)
#     let metal = Uint256(metal_amount * E18, 0)
#     let crystal = Uint256(crystal_amount * E18, 0)
#     let deuterium = Uint256(deuterium_amount * E18, 0)
#     IERC20.mint(metal_address, to, metal)
#     IERC20.mint(crystal_address, to, crystal)
#     IERC20.mint(deuterium_address, to, deuterium)
#     return ()
# end

# func _pay_resources_erc20{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     address : felt, metal_amount : felt, crystal_amount : felt, deuterium_amount : felt
# ):
#     assert_not_zero(address)
#     let (no_game) = Resources_no_game_address.read()
#     let (_, metal_address, crystal_address, deuterium_address) = INoGame.getTokensAddresses(no_game)
#     let metal = Uint256(metal_amount * E18, 0)
#     let crystal = Uint256(crystal_amount * E18, 0)
#     let deuterium = Uint256(deuterium_amount * E18, 0)
#     IERC20.burn(metal_address, address, metal)
#     IERC20.burn(crystal_address, address, crystal)
#     IERC20.burn(deuterium_address, address, deuterium)
#     return ()
# end

# func _get_net_energy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     metal_level : felt, crystal_level : felt, deuterium_level : felt, solar_plant_level : felt
# ) -> (net_energy : felt):
#     alloc_locals
#     let (metal_consumption) = Formulas.consumption_energy(metal_level)
#     let (crystal_consumption) = Formulas.consumption_energy(crystal_level)
#     let (deuterium_consumption) = Formulas.consumption_energy_deuterium(deuterium_level)
#     let total_energy_required = metal_consumption + crystal_consumption + deuterium_consumption
#     let (energy_available) = Formulas.solar_production(solar_plant_level)
#     let (not_negative_energy) = is_le(total_energy_required, energy_available)
#     if not_negative_energy == FALSE:
#         return (0)
#     else:
#         let res = energy_available - total_energy_required
#     end
#     return (res)
# end

# func get_available_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (metal : felt, crystal : felt, deuterium : felt):
#     let (no_game) = Resources_no_game_address.read()
#     let (_, metal_address, crystal_address, deuterium_address) = INoGame.getTokensAddresses(no_game)
#     let (metal_available) = IERC20.balanceOf(metal_address, caller)
#     let (crystal_available) = IERC20.balanceOf(crystal_address, caller)
#     let (deuterium_available) = IERC20.balanceOf(deuterium_address, caller)
#     return (metal_available.low, crystal_available.low, deuterium_available.low)
# end

# # TODO: add satellites to energy calculation
# func get_net_energy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     metal_level : felt, crystal_level : felt, deuterium_level : felt, solar_plant_level : felt
# ) -> (net_energy : felt):
#     alloc_locals
#     let (metal_consumption) = Formulas.consumption_energy(metal_level)
#     let (crystal_consumption) = Formulas.consumption_energy(crystal_level)
#     let (deuterium_consumption) = Formulas.consumption_energy_deuterium(deuterium_level)
#     let total_energy_required = metal_consumption + crystal_consumption + deuterium_consumption
#     let (energy_available) = Formulas.solar_plant_production(solar_plant_level)
#     let (not_negative_energy) = is_le(total_energy_required, energy_available)
#     if not_negative_energy == FALSE:
#         return (0)
#     else:
#         let res = energy_available - total_energy_required
#     end
#     return (res)
# end
