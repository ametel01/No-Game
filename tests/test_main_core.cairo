%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256
from main.structs import Cost, TechLevels, TechCosts
from tests.conftest import Contracts, _get_test_addresses, _run_modules_manager, _run_minter
from tests.interfaces import NoGame, Minter, ERC721

@external
func test_game_setup{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)

    let (_erc721, _metal, _crystal, _deuterium) = NoGame.getTokensAddresses(addresses.game)
    assert _erc721 = addresses.erc721
    assert _metal = addresses.metal
    assert _crystal = addresses.crystal
    assert _deuterium = addresses.deuterium

    let (_resources, _facilities, _shipyard, _research) = NoGame.getModulesAddresses(addresses.game)
    assert _resources = addresses.resources
    assert _facilities = addresses.facilities
    assert _shipyard = addresses.shipyard
    assert _research = addresses.research

    return ()
end

@external
func test_generate_planet{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    %{ stop_prank_callable1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    # Testing the 'generate_planet' call.
    let (planet_before) = NoGame.numberOfPlanets(addresses.game)
    assert planet_before = 0

    NoGame.generatePlanet(addresses.game)
    let (new_planet_balance) = NoGame.numberOfPlanets(addresses.game)
    assert new_planet_balance = 1

    # Testing the ERC721 balance after the 'generate planet' call
    let (erc721_balance) = ERC721.balanceOf(addresses.erc721, addresses.owner)
    assert erc721_balance = Uint256(1, 0)
    let (new_minter_balance) = ERC721.balanceOf(addresses.erc721, addresses.minter)
    assert new_minter_balance = Uint256(9, 0)

    return ()
end

@external
func test_views_base_levels{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)

    # Testing levels for initialized planet
    let (metal, crystal, deuterium, solar_plant) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.owner
    )
    assert metal = 0
    assert crystal = 0
    assert deuterium = 0
    assert solar_plant = 0

    let (robot, shipyard, research, nanite) = NoGame.getFacilitiesLevels(
        addresses.game, addresses.owner
    )
    assert robot = 0
    assert shipyard = 0
    assert research = 0
    assert nanite = 0

    let (tech_levels : TechLevels) = NoGame.getTechLevels(addresses.game, addresses.owner)
    assert tech_levels.armour_tech = 0
    assert tech_levels.astrophysics = 0
    assert tech_levels.combustion_drive = 0
    assert tech_levels.computer_tech = 0
    assert tech_levels.energy_tech = 0
    assert tech_levels.espionage_tech = 0
    assert tech_levels.hyperspace_drive = 0
    assert tech_levels.hyperspace_tech = 0
    assert tech_levels.impulse_drive = 0
    assert tech_levels.ion_tech = 0
    assert tech_levels.laser_tech = 0
    assert tech_levels.plasma_tech = 0
    assert tech_levels.shielding_tech = 0
    assert tech_levels.weapons_tech = 0

    return ()
end

func test_views_base_costs{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    # Testing the base buildings costs.
    let (metal_1, crystal_1, deuterium_1, solar_plant_1) = NoGame.getResourcesUpgradeCost(
        addresses.game, addresses.owner
    )
    assert metal_1 = Cost(60, 15, 0)
    assert crystal_1 = Cost(48, 24, 0)
    assert deuterium_1 = Cost(225, 75, 0)
    assert solar_plant_1 = Cost(75, 30, 0)

    # Testing the base facilities costs.
    let (robot_1, shipyard_1, research_1, nanite_1) = NoGame.getFacilitiesUpgradeCost(
        addresses.game, addresses.owner
    )
    assert robot_1 = Cost(400, 120, 200)
    assert shipyard_1 = Cost(400, 200, 100)
    assert research_1 = Cost(200, 400, 200)
    assert nanite_1 = Cost(1000000, 500000, 100000)

    let (tech_costs : TechCosts) = NoGame.getTechUpgradeCost(addresses.game, addresses.owner)
    assert tech_costs.armour_tech = Cost(1000, 0, 0)
    assert tech_costs.astrophysics = Cost(4000, 8000, 4000)
    assert tech_costs.combustion_drive = Cost(400, 0, 600)
    assert tech_costs.computer_tech = Cost(0, 400, 600)
    assert tech_costs.energy_tech = Cost(0, 800, 400)
    assert tech_costs.espionage_tech = Cost(200, 1000, 200)
    assert tech_costs.hyperspace_drive = Cost(10000, 20000, 6000)
    assert tech_costs.hyperspace_tech = Cost(0, 4000, 2000)
    assert tech_costs.impulse_drive = Cost(2000, 4000, 600)
    assert tech_costs.ion_tech = Cost(1000, 300, 100)
    assert tech_costs.laser_tech = Cost(200, 100, 0)
    assert tech_costs.plasma_tech = Cost(2000, 4000, 1000)
    assert tech_costs.shielding_tech = Cost(200, 600, 0)
    assert tech_costs.weapons_tech = Cost(800, 200, 0)

    return ()
end
