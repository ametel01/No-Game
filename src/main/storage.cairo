%lang starknet

from starkware.cairo.common.uint256 import Uint256
from main.structs import BuildingQue, Planet

##################################################################################
#                              TOKENS ADDRESSES                              #
##################################################################################
# @dev Returns the address of the game's ERC721 contract.
@storage_var
func erc721_token_address() -> (address : felt):
end

# @dev Returns the address of the owner of the ERC721 contract.
@storage_var
func erc721_owner_address() -> (address : felt):
end

# @dev Returns the address of the ERC20 metal address.
@storage_var
func erc20_metal_address() -> (address : felt):
end

# @dev Returns the address of the ERC20 crystal address.
@storage_var
func erc20_crystal_address() -> (address : felt):
end

# @dev Returns the address of the ERC20 deuterium address.
@storage_var
func erc20_deuterium_address() -> (address : felt):
end

##################################################################################
#                              GENERAL STORAGE                                   #
##################################################################################

# @dev Returns the total number of planets present in the universe.
@storage_var
func number_of_planets() -> (n : felt):
end

# @dev Returns the planet struct of a given planet.
# @params The planet ID which is = to the NFT ID.
@storage_var
func planets(planet_id : Uint256) -> (planet : Planet):
end

@storage_var
func players_spent_resources(address : felt) -> (spent_resources : felt):
end

##################################################################################
#                              MODULES ADDRESSES                                 #
##################################################################################

@storage_var
func resources_address() -> (address : felt):
end

@storage_var
func facilities_address() -> (address : felt):
end

@storage_var
func shipyard_address() -> (address : felt):
end

@storage_var
func research_lab_address() -> (address : felt):
end

##################################################################################
#                              RESOURCES STORAGE                                 #
##################################################################################

@storage_var
func metal_available(planet_id : Uint256) -> (res : felt):
end

@storage_var
func crystal_available(planet_id : Uint256) -> (res : felt):
end

@storage_var
func deuterium_available(planet_id : Uint256) -> (res : felt):
end

##################################################################################
#                              MINING STRUCTURES STORAGE                         #
##################################################################################

@storage_var
func metal_mine_level(planet_id : Uint256) -> (res : felt):
end

@storage_var
func crystal_mine_level(planet_id : Uint256) -> (res : felt):
end

@storage_var
func deuterium_mine_level(planet_id : Uint256) -> (res : felt):
end

@storage_var
func solar_plant_level(planet_id : Uint256) -> (res : felt):
end

##################################################################################
#                             FACILITIES STORAGE                                 #
##################################################################################

@storage_var
func shipyard_level(planet_id : Uint256) -> (level : felt):
end

# TODO: this need to be changed
@storage_var
func robot_factory_level(planete_id : Uint256) -> (level : felt):
end

@storage_var
func research_lab_level(planete_id : Uint256) -> (level : felt):
end

@storage_var
func nanite_factory_level(planete_id : Uint256) -> (level : felt):
end

@storage_var
func buildings_timelock(address : felt) -> (cued_details : BuildingQue):
end

##################################################################################
#                              RESEARCH STORAGE                                  #
##################################################################################

@storage_var
func energy_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func computer_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func laser_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func armour_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func ion_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func espionage_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func plasma_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func weapons_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func shielding_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func hyperspace_tech(planet_id : Uint256) -> (level : felt):
end

@storage_var
func astrophysics(planet_id : Uint256) -> (level : felt):
end

@storage_var
func combustion_drive(planet_id : Uint256) -> (level : felt):
end

@storage_var
func hyperspace_drive(planet_id : Uint256) -> (level : felt):
end

@storage_var
func impulse_drive(planet_id : Uint256) -> (level : felt):
end

##################################################################################
#                             SHIPYARD STORAGE                                   #
##################################################################################

@storage_var
func ships_cargo(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func ships_recycler(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func ships_espionage_probe(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func ships_solar_satellite(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func ships_light_fighter(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func ships_cruiser(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func ships_battleship(planet_id : Uint256) -> (amount : felt):
end

@storage_var
func ships_deathstar(planet_id : Uint256) -> (amount : felt):
end
