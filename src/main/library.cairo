%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from token.erc721.interfaces.IERC721 import IERC721
from utils.formulas import Formulas
from facilities.library import Facilities
from resources.library import Resources
from main.storage import (
    metal_mine_level,
    crystal_mine_level,
    deuterium_mine_level,
    solar_plant_level,
    planets,
    players_spent_resources,
    erc721_token_address,
    erc20_metal_address,
    erc20_crystal_address,
    erc20_deuterium_address,
    resources_address,
    facilities_address,
    research_lab_address,
    shipyard_address,
    shipyard_level,
    robot_factory_level,
    research_lab_level,
    nanite_factory_level,
    energy_tech,
    computer_tech,
    laser_tech,
    armour_tech,
    astrophysics,
    espionage_tech,
    hyperspace_drive,
    hyperspace_tech,
    impulse_drive,
    ion_tech,
    plasma_tech,
    weapons_tech,
    shielding_tech,
    combustion_drive,
    ships_cargo,
    ships_recycler,
    ships_espionage_probe,
    ships_solar_satellite,
    ships_light_fighter,
    ships_cruiser,
    ships_battleship,
    ships_deathstar,
)

from main.structs import BuildingQue, Planet, Cost

namespace NoGame:
    func get_tokens_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (erc721 : felt, erc20_metal : felt, erc20_crystal : felt, erc20_deuterium : felt):
        let (erc721) = erc721_token_address.read()
        let (metal) = erc20_metal_address.read()
        let (crystal) = erc20_crystal_address.read()
        let (deuterium) = erc20_deuterium_address.read()

        return (erc721, metal, crystal, deuterium)
    end

    func get_modules_addresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (_resources, _facilities, _shipyard, _research):
        let (resources) = resources_address.read()
        let (facilities) = facilities_address.read()
        let (shipyard) = shipyard.address.read()
        let (research) = research.address.read()

        return (resources, facilities, shipyard, research)
    end

    func get_upgrades_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (
        up_metal : Cost,
        up_crystal : Cost,
        up_deuturium : Cost,
        up_solar : Cost,
        up_robot_factory : Cost,
        up_shipyard : Cost,
        up_lab : Cost,
        up_nanite : Cost,
    ):
        alloc_locals
        let (erc721_address) = erc721_token_address.read()
        let (planet_id) = IERC721.ownerToPlanet(erc721_address, caller)
        let (metal_level) = metal_mine_level.read(planet_id)
        let (crystal_level) = crystal_mine_level.read(planet_id)
        let (deuterium_level) = deuterium_mine_level.read(planet_id)
        let (solar_level) = solar_plant_level.read(planet_id)
        let (robot_level) = robot_factory_level.read(planet_id)
        let (_shipyard_level) = shipyard_level.read(planet_id)
        let (nanite_level) = nanite_factory_level.read(planet_id)
        let (lab_level) = research_lab_level.read(planet_id)
        let (m_metal, m_crystal) = Formulas.metal_building_cost(metal_level)
        let (c_metal, c_crystal) = Formulas.crystal_building_cost(crystal_level)
        let (d_metal, d_crystal) = Formulas.deuterium_building_cost(deuterium_level)
        let (s_metal, s_crystal) = Formulas.solar_plant_building_cost(solar_level)
        let (r_metal, r_crystal, r_deuterium) = Facilities.robot_factory_upgrade_cost(robot_level)
        let (sh_metal, sh_crystal, sh_deuterium) = Facilities.shipyard_upgrade_cost(_shipyard_level)
        let (l_metal, l_crystal, l_deuterium) = Facilities.research_lab_upgrade_cost(lab_level)
        let (n_metal, n_crystal, n_deuterium) = Facilities.nanite_factory_upgrade_cost(nanite_level)
        return (
            Cost(m_metal, m_crystal, 0),
            Cost(c_metal, c_crystal, 0),
            Cost(d_metal, d_crystal, 0),
            Cost(s_metal, s_crystal, 0),
            Cost(r_metal, r_crystal, r_deuterium),
            Cost(sh_metal, sh_crystal, sh_deuterium),
            Cost(l_metal, l_crystal, l_deuterium),
            Cost(n_metal, n_crystal, n_deuterium),
        )
    end

    func get_structures_levels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (
        metal_mine : felt,
        crystal_mine : felt,
        deuterium_mine : felt,
        solar_plant : felt,
        robot_factory : felt,
        research_lab : felt,
        shipyard : felt,
        nanite_factory : felt,
    ):
        let (planet_id) = _get_planet_id(caller)
        let metal = metal_mine_level.read(planet_id)
        let crystal = crystal_mine_level.read(planet_id)
        let deuterium = deuterium_mine_level.read(planet_id)
        let solar_plant = solar_plant_level.read(planet_id)
        let (robot_factory) = robot_factory_level.read(planet_id)
        let (research_lab) = research_lab_level.read(planet_id)
        let (shipyard) = shipyard_level.read(planet_id)
        let (nanite) = nanite_factory_level.read(planet_id)
        return (
            metal_mine=metal,
            crystal_mine=crystal,
            deuterium_mine=deuterium,
            solar_plant=solar_plant,
            robot_factory=robot_factory,
            research_lab=research_lab,
            shipyard=shipyard,
            nanite_factory=nanite,
        )
    end

    @view
    func get_resources_available{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, energy : felt):
        alloc_locals
        let (planet_id) = _get_planet_id(caller)
        let (
            metal_available, crystal_available, deuterium_available
        ) = Resources.get_available_resources(caller)
        let (metal) = metal_mine_level.read(planet_id)
        let (crystal) = crystal_mine_level.read(planet_id)
        let (deuterium) = deuterium_mine_level.read(planet_id)
        let (solar_plant) = solar_plant_level.read(planet_id)
        let (energy_available) = Resources.get_net_energy(metal, crystal, deuterium, solar_plant)
        return (metal_available, crystal_available, deuterium_available, energy_available)
    end
end

func _get_planet_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (planet_id : Uint256):
    let (erc721) = erc721_token_address.read()
    let (planet_id) = IERC721.ownerToPlanet(erc721, caller)

    return (planet_id)
end
