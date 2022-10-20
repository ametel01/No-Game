%lang starknet

from starkware.cairo.common.uint256 import Uint256
from main.structs import ResearchQue, ResourcesQue, ShipyardQue

@storage_var
func NoGame_modules_manager() -> (address: felt) {
}

//#################################################################################
//                              GENERAL STORAGE                                   #
//#################################################################################

// @dev Returns the total number of planets present in the universe.
@storage_var
func NoGame_number_of_planets() -> (n: felt) {
}

@storage_var
func NoGame_planets_spent_resources(planet_id: Uint256) -> (spent_resources: felt) {
}

@storage_var
func NoGame_resources_timer(planet_id: Uint256) -> (time_last: felt) {
}

//#################################################################################
//                              RESOURCES STORAGE                                 #
//#################################################################################

@storage_var
func NoGame_metal_available(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_crystal_available(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_deuterium_available(planet_id: Uint256) -> (res: felt) {
}

//#################################################################################
//                              MINING STRUCTURES STORAGE                         #
//#################################################################################

@storage_var
func NoGame_metal_mine_level(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_crystal_mine_level(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_deuterium_mine_level(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_solar_plant_level(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_resources_que_status(planet_id: Uint256) -> (que_details: ResourcesQue) {
}

//#################################################################################
//                             FACILITIES STORAGE                                 #
//#################################################################################

@storage_var
func NoGame_shipyard_level(planet_id: Uint256) -> (level: felt) {
}

// TODO: this need to be changed
@storage_var
func NoGame_robot_factory_level(planete_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_research_lab_level(planete_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_nanite_factory_level(planete_id: Uint256) -> (level: felt) {
}

//#################################################################################
//                              RESEARCH STORAGE                                  #
//#################################################################################

@storage_var
func NoGame_armour_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_astrophysics(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_combustion_drive(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_computer_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_energy_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_espionage_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_hyperspace_drive(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_hyperspace_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_impulse_drive(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_ion_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_laser_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_plasma_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_shielding_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_weapons_tech(planet_id: Uint256) -> (level: felt) {
}

@storage_var
func NoGame_research_que_status(planet_id: Uint256) -> (status: ResearchQue) {
}
//#################################################################################
//                             SHIPYARD STORAGE                                   #
//#################################################################################

@storage_var
func NoGame_ships_cargo(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_ships_recycler(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_ships_espionage_probe(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_ships_solar_satellite(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_ships_light_fighter(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_ships_cruiser(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_ships_battleship(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_ships_deathstar(planet_id: Uint256) -> (amount: felt) {
}

@storage_var
func NoGame_shipyard_que_status(planet_id: Uint256) -> (status: ShipyardQue) {
}

//#################################################################################
//                             DEFENCES STORAGE                                   #
//#################################################################################

@storage_var
func NoGame_rocket(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_ligth_laser(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_heavy_laser(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_ion_cannon(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_gauss(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_plasma_turret(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_small_dome(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_large_dome(planet_id: Uint256) -> (res: felt) {
}

//#################################################################################
//                             FLEET STORAGE                                      #
//#################################################################################
@storage_var
func NoGame_max_slots(planet_id: Uint256) -> (res: felt) {
}

@storage_var
func NoGame_active_missions(planet_id: Uint256) -> (res: felt) {
}
