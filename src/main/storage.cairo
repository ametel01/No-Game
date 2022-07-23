%lang starknet

from starkware.cairo.common.uint256 import Uint256
from main.structs import BuildingQue, Planet

@storage_var
func NoGame_modules_manager() -> (address : felt):
end

##################################################################################
#                              GENERAL STORAGE                                   #
##################################################################################

# @dev Returns the total number of planets present in the universe.
@storage_var
func NoGame_number_of_planets() -> (n : felt):
end

@storage_var
func NoGame_planets_spent_resources(planet_id : Uint256) -> (spent_resources : felt):
end

@storage_var
func NoGame_resources_timer(planet_id : Uint256) -> (last_collection_timestamp : felt):
end
##################################################################################
#                              RESOURCES STORAGE                                 #
##################################################################################

@storage_var
func NoGame_metal_available(planet_id : Uint256) -> (res : felt):
end

@storage_var
func NoGame_crystal_available(planet_id : Uint256) -> (res : felt):
end

@storage_var
func NoGame_deuterium_available(planet_id : Uint256) -> (res : felt):
end

##################################################################################
#                              MINING STRUCTURES STORAGE                         #
##################################################################################

@storage_var
func NoGame_metal_mine_level(planet_id : Uint256) -> (res : felt):
end

@storage_var
func NoGame_crystal_mine_level(planet_id : Uint256) -> (res : felt):
end

@storage_var
func NoGame_deuterium_mine_level(planet_id : Uint256) -> (res : felt):
end

@storage_var
func NoGame_solar_plant_level(planet_id : Uint256) -> (res : felt):
end

##################################################################################
#                             FACILITIES STORAGE                                 #
##################################################################################

@storage_var
func NoGame_shipyard_level(planet_id : Uint256) -> (level : felt):
end

# TODO: this need to be changed
@storage_var
func NoGame_robot_factory_level(planete_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_research_lab_level(planete_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_nanite_factory_level(planete_id : Uint256) -> (level : felt):
end

##################################################################################
#                              RESEARCH STORAGE                                  #
##################################################################################

@storage_var
func NoGame_energy_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_computer_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_laser_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_armour_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_ion_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_espionage_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_plasma_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_weapons_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_shielding_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_hyperspace_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_astrophysics(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_combustion_drive(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_hyperspace_drive(planet_id : Uint256) -> (level : felt):
end

@storage_var
func NoGame_impulse_drive(planet_id : Uint256) -> (level : felt):
end

##################################################################################
#                             SHIPYARD STORAGE                                   #
##################################################################################

@storage_var
func NoGame_ships_cargo(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func NoGame_ships_recycler(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func NoGame_ships_espionage_probe(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func NoGame_ships_solar_satellite(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func NoGame_ships_light_fighter(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func NoGame_ships_cruiser(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func NoGame_ships_battleship(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func NoGame_ships_deathstar(planet_id : Uint256) -> (amount : felt):
end
