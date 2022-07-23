%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE
from main.library import NoGame
from resources.IResources import IResources
from resources.library import Resources
from research.IResearchLab import IResearchLab
from shipyard.IShipyard import IShipyard
from manager.IModulesManager import IModulesManager
from facilities.IFacilities import IFacilities
from utils.formulas import Formulas
from main.structs import TechLevels, BuildingQue, Cost, Planet, MineLevels, Energy, Fleet

#########################################################################################
#                                   Constructor                                         #
#########################################################################################

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, modules_manager : felt
):
    NoGame.initializer(owner, modules_manager)
    return ()
end

#########################################################################################
#                                       Getters                                         #
#########################################################################################

@view
func numberOfPlanets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    n_planets : felt
):
    let (n) = NoGame.number_of_planets()
    return (n_planets=n)
end

@view
func getTokensAddresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    erc721 : felt, erc20_metal : felt, erc20_crystal : felt, erc20_deuterium : felt
):
    let (erc721, metal, crystal, deuterium) = NoGame.tokens_addresses()
    return (erc721, metal, crystal, deuterium)
end

@view
func getModulesAddresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    _resources : felt, _facilities : felt, _shipyard : felt, _research : felt
):
    let (resources, facilities, shipyard, research) = NoGame.modules_addresses()
    return (resources, facilities, shipyard, research)
end

@view
func getResourcesBuildingsLevels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal_mine : felt, crystal_mine : felt, deuterium_mine : felt, solar_plant : felt):
    let (metal, crystal, deuterium, solar_plant) = NoGame.resources_buildings_levels(caller)
    return (metal, crystal, deuterium, solar_plant)
end

# @view
# func getResourcesAvailable{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (metal : felt, crystal : felt, deuterium : felt, energy : felt):
#     let (
#         metal_available, crystal_available, deuterium_available, energy_available
#     ) = NoGame.get_resources_available()
#     return (metal_available, crystal_available, deuterium_available, energy_available)
# end

# @view
# func getStructuresUpgradeCost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (
#     metal_mine : Cost,
#     crystal_mine : Cost,
#     deuterium_mine : Cost,
#     solar_plant : Cost,
#     robot_factory : Cost,
#     shipyard : Cost,
#     research_lab : Cost,
#     nanite : Cost,
# ):
#     let (
#         metal, crystal, deuterium, solar_plant, robot_factory, shipyard, research_lab, nanite
#     ) = NoGame.upgrades_cost(caller)
#     return (metal, crystal, deuterium, solar_plant, robot_factory, shipyard, research_lab, nanite)
# end

# @view
# func getResourcesQueStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (building_id : felt, time_end : felt):
#     let (building_id, time_end) = NoGame.get_resources_que_status(caller)
#     return (building_id, time_end)
# end

# @view
# func getFacilitiesQueStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (status : BuildingQue):
#     let (_, facilities, _, _) = getModulesAddresses()
#     let (que_details) = IFacilities.getTimelockStatus(facilities, caller)
#     return (que_details)
# end

@view
func getPlayerPoints{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (points : felt):
    let (points) = NoGame.player_points(caller)
    return (points)
end

# ##########################################################################################
# #                                      Externals                                         #
# ##########################################################################################

# @external
# func set_erc20_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     metal_token : felt, crystal_token : felt, deuterium_token : felt
# ):
#     Ownable.assert_only_owner()
#     erc20_metal_address.write(metal_token)
#     erc20_crystal_address.write(crystal_token)
#     erc20_deuterium_address.write(deuterium_token)
#     return ()
# end

# @external
# func set_modules_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     _resources_address, _facilities_address : felt, _lab_address : felt, _shipyard_address : felt
# ):
#     Ownable.assert_only_owner()

# resources_address.write(_resources_address)
#     facilities_address.write(_facilities_address)
#     research_lab_address.write(_lab_address)
#     shipyard_address.write(_shipyard_address)
#     return ()
# end

# @external
# func generate_planet{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     _generate_planet(caller)
#     return ()
# end

# @external
# func collect_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (address) = get_caller_address()
#     assert_not_zero(address)
#     let (id) = _planet_to_owner.read(address)
#     _collect_resources(address)
#     return ()
# end

# ##############################################################################################
# #                               RESOURCES EXTERNALS FUNCS                                    #
# ##############################################################################################

# @external
# func metal_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (_resources_address) = resources_address.read()
#     let (
#         metal_spent, crystal_spent, deuterium_spent, time_unlocked
#     ) = IResources.metal_upgrade_start(resources_address, caller)
#     Resources._pay_resources_erc20(caller, metal_spent, crystal_spent, deuterium_spent)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal_spent + crystal_spent
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func metal_upgrade_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_facilities_address) = facilities_address.read()
#     let (success) = IFacilities._robot_factory_upgrade_complete(_facilities_address, caller)
#     assert success = TRUE
#     let (current_robot_factory_level) = robot_factory_level.read(planet_id)
#     robot_factory_level.write(planet_id, current_robot_factory_level + 1)
#     return ()
# end

# @external
# func crystal_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     _start_crystal_upgrade()
#     return ()
# end

# @external
# func crystal_upgrade_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     _end_crystal_upgrade()
#     return ()
# end

# @external
# func deuterium_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     _start_deuterium_upgrade()
#     return ()
# end

# @external
# func deuterium_upgrade_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     _end_deuterium_upgrade()
#     return ()
# end

# @external
# func solar_plant_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     _start_solar_plant_upgrade()
#     return ()
# end

# @external
# func solar_plant_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     _end_solar_plant_upgrade()
#     return ()
# end

# ##############################################################################################
# #                              FACILITIES EXTERNALS FUNCS                                    #
# ##############################################################################################

# @external
# func robot_factory_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     let (caller) = get_caller_address()
#     let (_facilities_address) = facilities_address.read()
#     let (
#         metal_spent, crystal_spent, deuterium_spent, time_unlocked
#     ) = IFacilities._robot_factory_upgrade_start(_facilities_address, caller)
#     Resources._pay_resources_erc20(caller, metal_spent, crystal_spent, deuterium_spent)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal_spent + crystal_spent
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func robot_factory_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_facilities_address) = facilities_address.read()
#     let (success) = IFacilities._robot_factory_upgrade_complete(_facilities_address, caller)
#     assert success = TRUE
#     let (current_robot_factory_level) = robot_factory_level.read(planet_id)
#     robot_factory_level.write(planet_id, current_robot_factory_level + 1)
#     return ()
# end

# @external
# func shipyard_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (_facilities_address) = facilities_address.read()
#     let (
#         metal_spent, crystal_spent, deuterium_spent, time_unlocked
#     ) = IFacilities._shipyard_upgrade_start(_facilities_address, caller)
#     Resources._pay_resources_erc20(caller, metal_spent, crystal_spent, deuterium_spent)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal_spent + crystal_spent
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func shipyard_upgrade_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_facilities_address) = facilities_address.read()
#     let (success) = IFacilities._shipyard_upgrade_complete(_facilities_address, caller)
#     assert success = TRUE
#     let (current_shipyard_level) = shipyard_level.read(planet_id)
#     shipyard_level.write(planet_id, current_shipyard_level + 1)
#     return ()
# end

# @external
# func research_lab_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     let (caller) = get_caller_address()
#     let (_facilities_address) = facilities_address.read()
#     let (
#         metal_spent, crystal_spent, deuterium_spent, time_unlocked
#     ) = IFacilities._research_lab_upgrade_start(_facilities_address, caller)
#     Resources._pay_resources_erc20(caller, metal_spent, crystal_spent, deuterium_spent)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal_spent + crystal_spent
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func research_lab_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_facilities_address) = facilities_address.read()
#     let (success) = IFacilities._research_lab_upgrade_complete(_facilities_address, caller)
#     assert success = TRUE
#     let (current_research_lab_level) = research_lab_level.read(planet_id)
#     research_lab_level.write(planet_id, current_research_lab_level + 1)
#     return ()
# end

# @external
# func nanite_factory_upgrade_start{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (_facilities_address) = facilities_address.read()
#     let (
#         metal_spent, crystal_spent, deuterium_spent, time_unlocked
#     ) = IFacilities._nanite_factory_upgrade_start(_facilities_address, caller)
#     Resources._pay_resources_erc20(caller, metal_spent, crystal_spent, deuterium_spent)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal_spent + crystal_spent
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func nanite_factory_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_facilities_address) = facilities_address.read()
#     let (success) = IFacilities._nanite_factory_upgrade_complete(_facilities_address, caller)
#     assert success = TRUE
#     let (current_nanite_factory_level) = nanite_factory_level.read(planet_id)
#     nanite_factory_level.write(planet_id, current_nanite_factory_level + 1)
#     return ()
# end

# ##############################################################################################
# #                              RESEARCH EXTERNALS FUNCS                                      #
# ##############################################################################################
# @external
# func energy_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _energy_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._energy_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func energy_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._energy_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _energy_tech.read(planet_id)
#     _energy_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func computer_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _computer_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._computer_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func computer_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._computer_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _computer_tech.read(planet_id)
#     _computer_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func laser_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _laser_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._laser_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func laser_tech_upgrade_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._laser_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _laser_tech.read(planet_id)
#     _laser_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func armour_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _armour_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._armour_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func armour_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._armour_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _armour_tech.read(planet_id)
#     _armour_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func ion_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _ion_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._ion_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func ion_tech_upgrade_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._ion_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _ion_tech.read(planet_id)
#     _ion_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func espionage_tech_upgrade_start{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _espionage_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._espionage_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func espionage_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._espionage_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _espionage_tech.read(planet_id)
#     _espionage_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func plasma_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _plasma_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._plasma_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func plasma_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._plasma_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _plasma_tech.read(planet_id)
#     _plasma_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func weapons_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _weapons_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._weapons_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func weapons_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._weapons_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _weapons_tech.read(planet_id)
#     _weapons_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func shielding_tech_upgrade_start{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _shielding_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._shielding_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func shielding_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._shielding_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _shielding_tech.read(planet_id)
#     _shielding_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func hyperspace_tech_upgrade_start{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _hyperspace_tech.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._hyperspace_tech_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func hyperspace_tech_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._hyperspace_tech_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _hyperspace_tech.read(planet_id)
#     _hyperspace_tech.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func astrophysics_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _astrophysics.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._astrophysics_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func astrophysics_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._astrophysics_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _astrophysics.read(planet_id)
#     _astrophysics.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func combustion_drive_upgrade_start{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _combustion_drive.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._combustion_drive_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func combustion_drive_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._combustion_drive_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _combustion_drive.read(planet_id)
#     _combustion_drive.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func hyperspace_drive_upgrade_start{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _hyperspace_drive.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._hyperspace_drive_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func hyperspace_drive_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._hyperspace_drive_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _hyperspace_drive.read(planet_id)
#     _hyperspace_drive.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func impulse_drive_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (current_tech_level) = _impulse_drive.read(planet_id)
#     let (lab_address) = research_lab_address.read()
#     let (metal, crystal, deuterium) = IResearchLab._impulse_drive_upgrade_start(
#         lab_address, caller, current_tech_level
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func impulse_drive_upgrade_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (lab_address) = research_lab_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (success) = IResearchLab._impulse_drive_upgrade_complete(lab_address, caller)
#     assert success = TRUE
#     let (current_tech_level) = _impulse_drive.read(planet_id)
#     _impulse_drive.write(planet_id, current_tech_level + 1)
#     return ()
# end

# @external
# func getTechLevels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (result : TechLevels):
#     let (res) = NoGame.tech_levels(caller)
#     return (res)
# end

# #########################################################################################################
# #                                           SHIPYARD FUNCTIONS                                          #
# #########################################################################################################

# @external
# func cargo_ship_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     number_of_units : felt
# ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_shipyard_address) = shipyard_address.read()
#     let (metal, crystal, deuterium) = IShipyard._cargo_ship_build_start(
#         _shipyard_address, caller, number_of_units
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func cargo_ship_build_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (_shipyard_address) = shipyard_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (units_produced, success) = IShipyard._cargo_ship_build_complete(_shipyard_address, caller)
#     assert success = TRUE
#     let (current_amount_of_units) = _ships_cargo.read(planet_id)
#     _ships_cargo.write(planet_id, current_amount_of_units + units_produced)
#     return ()
# end

# @external
# func recycler_ship_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     number_of_units : felt
# ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_shipyard_address) = shipyard_address.read()
#     let (metal, crystal, deuterium) = IShipyard._build_recycler_ship_start(
#         _shipyard_address, caller, number_of_units
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func recycler_ship_build_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (_shipyard_address) = shipyard_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (units_produced, success) = IShipyard._build_recycler_ship_complete(
#         _shipyard_address, caller
#     )
#     assert success = TRUE
#     let (current_amount_of_units) = _ships_recycler.read(planet_id)
#     _ships_recycler.write(planet_id, current_amount_of_units + units_produced)
#     return ()
# end

# @external
# func espionage_probe_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     number_of_units : felt
# ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_shipyard_address) = shipyard_address.read()
#     let (metal, crystal, deuterium) = IShipyard._build_espionage_probe_start(
#         _shipyard_address, caller, number_of_units
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func espionage_probe_build_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (_shipyard_address) = shipyard_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (units_produced, success) = IShipyard._build_espionage_probe_complete(
#         _shipyard_address, caller
#     )
#     assert success = TRUE
#     let (current_amount_of_units) = _ships_espionage_probe.read(planet_id)
#     _ships_espionage_probe.write(planet_id, current_amount_of_units + units_produced)
#     return ()
# end

# @external
# func solar_satellite_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     number_of_units : felt
# ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_shipyard_address) = shipyard_address.read()
#     let (metal, crystal, deuterium) = IShipyard._build_solar_satellite_start(
#         _shipyard_address, caller, number_of_units
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func solar_satellite_build_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (_shipyard_address) = shipyard_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (units_produced, success) = IShipyard._build_solar_satellite_complete(
#         _shipyard_address, caller
#     )
#     assert success = TRUE
#     let (current_amount_of_units) = _ships_solar_satellite.read(planet_id)
#     _ships_solar_satellite.write(planet_id, current_amount_of_units + units_produced)
#     return ()
# end

# @external
# func light_fighter_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     number_of_units : felt
# ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_shipyard_address) = shipyard_address.read()
#     let (metal, crystal, deuterium) = IShipyard._build_light_fighter_start(
#         _shipyard_address, caller, number_of_units
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func light_fighter_build_complete{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }():
#     let (caller) = get_caller_address()
#     let (_shipyard_address) = shipyard_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (units_produced, success) = IShipyard._build_light_fighter_complete(
#         _shipyard_address, caller
#     )
#     assert success = TRUE
#     let (current_amount_of_units) = _ships_light_fighter.read(planet_id)
#     _ships_light_fighter.write(planet_id, current_amount_of_units + units_produced)
#     return ()
# end

# @external
# func cruiser_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     number_of_units : felt
# ):
#     let (caller) = get_caller_address()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (_shipyard_address) = shipyard_address.read()
#     let (metal, crystal, deuterium) = IShipyard._build_cruiser_start(
#         _shipyard_address, caller, number_of_units
#     )
#     Resources._pay_resources_erc20(caller, metal, crystal, deuterium)
#     let (spent_so_far) = _players_spent_resources.read(caller)
#     let new_total_spent = spent_so_far + metal + crystal
#     _players_spent_resources.write(caller, new_total_spent)
#     return ()
# end

# @external
# func cruiser_build_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     let (caller) = get_caller_address()
#     let (_shipyard_address) = shipyard_address.read()
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (units_produced, success) = IShipyard._build_cruiser_complete(_shipyard_address, caller)
#     assert success = TRUE
#     let (current_amount_of_units) = _ships_cruiser.read(planet_id)
#     _ships_cruiser.write(planet_id, current_amount_of_units + units_produced)
#     return ()
# end

# # @external
# # func battelship_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
# #     number_of_units : felt
# # ):
# #     let (caller) = get_caller_address()
# #     let (planet_id) = _planet_to_owner.read(caller)
# #     let (shipyard_address) = shipyard_address.read()
# #     let (metal, crystal, deuterium) = IShipyard._build_battleship_start(
# #         shipyard_address, caller, number_of_units
# #     )
# #     _pay_resources_erc20(caller, metal, crystal, deuterium)
# #     let (spent_so_far) = _players_spent_resources.read(caller)
# #     let new_total_spent = spent_so_far + metal + crystal
# #     _players_spent_resources.write(caller, new_total_spent)
# #     return ()
# # end

# # @external
# # func battleship_build_complete{
# #     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# # }():
# #     let (caller) = get_caller_address()
# #     let (shipyard_address) = shipyard_address.read()
# #     let (planet_id) = _planet_to_owner.read(caller)
# #     let (units_produced, success) = IShipyard._build_battleship_complete(
# #         shipyard_address, caller
# #     )
# #     assert success = TRUE
# #     let (current_amount_of_units) = _ships_battleship.read(planet_id)
# #     _ships_battleship.write(planetr_id, current_amount_of_units + units_produced)
# #     return ()
# # end

# @external
# func get_fleet{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     caller : felt
# ) -> (result : Fleet):
#     let (planet_id) = _planet_to_owner.read(caller)
#     let (cargo_ship) = _ships_cargo.read(planet_id)
#     let (recycler_ship) = _ships_recycler.read(planet_id)
#     let (espionage_probe) = _ships_espionage_probe.read(planet_id)
#     let (solar_satellite) = _ships_solar_satellite.read(planet_id)
#     let (light_fighter) = _ships_light_fighter.read(planet_id)
#     let (cruiser) = _ships_cruiser.read(planet_id)
#     let (battleship) = _ships_battleship.read(planet_id)
#     let (deathstar) = _ships_deathstar.read(planet_id)
#     return (
#         Fleet(cargo_ship, recycler_ship, espionage_probe, solar_satellite, light_fighter, cruiser, battleship, deathstar),
#     )
# end

# #########################################################################################################
# #                                           GOD MODE                                                    #
# #                       @external TO BE REMOVED BEFORE DEPLOYMENT                                       #
# #########################################################################################################

# @external
# func GOD_MODE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#     preset_techs : TechLevels, preset_fleet : Fleet
# ):
#     let (caller) = get_caller_address()
#     let (time_now) = get_block_timestamp()
#     let planet = Planet(MineLevels(metal=25, crystal=23, deuterium=21), Energy(solar_plant=30))
#     let planet_id = Uint256(1, 0)
#     _planet_to_owner.write(caller, planet_id)
#     _planets.write(planet_id, planet)
#     # Techs setups
#     robot_factory_level.write(planet_id, 10)
#     research_lab_level.write(planet_id, preset_techs.research_lab)
#     _energy_tech.write(planet_id, preset_techs.energy_tech)
#     _laser_tech.write(planet_id, preset_techs.laser_tech)
#     _computer_tech.write(planet_id, preset_techs.computer_tech)
#     _armour_tech.write(planet_id, preset_techs.armour_tech)
#     _ion_tech.write(planet_id, preset_techs.ion_tech)
#     _espionage_tech.write(planet_id, preset_techs.espionage_tech)
#     _plasma_tech.write(planet_id, preset_techs.plasma_tech)
#     _weapons_tech.write(planet_id, preset_techs.weapons_tech)
#     _shielding_tech.write(planet_id, preset_techs.shielding_tech)
#     _hyperspace_tech.write(planet_id, preset_techs.hyperspace_tech)
#     _astrophysics.write(planet_id, preset_techs.astrophysics)
#     _combustion_drive.write(planet_id, preset_techs.combustion_drive)
#     _hyperspace_drive.write(planet_id, preset_techs.hyperspace_drive)
#     _impulse_drive.write(planet_id, preset_techs.impulse_drive)

# # Fleet setup
#     shipyard_level.write(planet_id, 10)
#     _ships_cargo.write(planet_id, preset_fleet.cargo)
#     _ships_recycler.write(planet_id, preset_fleet.recycler)
#     _ships_espionage_probe.write(planet_id, preset_fleet.espionage_probe)
#     _ships_solar_satellite.write(planet_id, preset_fleet.solar_satellite)
#     _ships_light_fighter.write(planet_id, preset_fleet.light_fighter)
#     _ships_cruiser.write(planet_id, preset_fleet.cruiser)
#     _ships_battleship.write(planet_id, preset_fleet.battle_ship)
#     _ships_deathstar.write(planet_id, preset_fleet.death_star)
#     return ()
# end
