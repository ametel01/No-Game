%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from tests.interfaces import NoGame, ERC721
from tests.setup import (
    Contracts,
    deploy_game,
    run_modules_manager,
    run_minter,
    time_warp,
    set_mines_levels,
    set_facilities_levels,
    set_resources_levels,
    set_tech_levels,
)
from research.library import TechLevels

@external
func test_structures_levels_after_transfer{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    let addresses: Contracts = deploy_game();
    run_modules_manager(addresses);
    run_minter(addresses, 1);
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game);
    set_mines_levels(addresses.game, 1, 2, 2, 2, 2);
    set_facilities_levels(addresses.game, 1, 2, 2, 2, 2);
    set_tech_levels(addresses.game, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2);

    let (metal, crystal, deuterium, solar_plant) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.owner
    );
    let (robot, shipyard, research, nanite) = NoGame.getFacilitiesLevels(
        addresses.game, addresses.owner
    );
    let (actual_tech_levels) = NoGame.getTechLevels(addresses.game, addresses.owner);
    assert metal = 2;
    assert crystal = 2;
    assert deuterium = 2;
    assert solar_plant = 2;
    assert robot = 2;
    assert shipyard = 2;
    assert research = 2;
    assert nanite = 2;
    let expected_tech_levels = TechLevels(2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2);
    assert actual_tech_levels = expected_tech_levels;

    let planet_id = Uint256(1, 0);
    let (current_owner) = ERC721.ownerOf(addresses.erc721, planet_id);
    let (owners_planet) = ERC721.ownerToPlanet(addresses.erc721, addresses.owner);
    assert current_owner = addresses.owner;
    assert owners_planet = planet_id;

    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.erc721)
    %}
    ERC721.transferFrom(addresses.erc721, addresses.owner, addresses.p1, planet_id);
    let (new_owner) = ERC721.ownerOf(addresses.erc721, planet_id);
    let (p1s_planet) = ERC721.ownerToPlanet(addresses.erc721, addresses.p1);
    assert new_owner = addresses.p1;
    assert p1s_planet = planet_id;

    let (owner_balance) = ERC721.ownerToPlanet(addresses.erc721, addresses.owner);
    assert owner_balance = Uint256(0, 0);

    let (p1_metal, p1_crystal, p1_deuterium, p1_solar_plant) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.p1
    );
    let (p1_robot, p1_shipyard, p1_research, p1_nanite) = NoGame.getFacilitiesLevels(
        addresses.game, addresses.p1
    );
    let (p1_tech_levels) = NoGame.getTechLevels(addresses.game, addresses.p1);
    assert p1_metal = 2;
    assert p1_crystal = 2;
    assert p1_deuterium = 2;
    assert p1_solar_plant = 2;
    assert p1_robot = 2;
    assert p1_shipyard = 2;
    assert p1_research = 2;
    assert p1_nanite = 2;
    assert p1_tech_levels = expected_tech_levels;

    let (
        owner_metal, owner_crystal, owner_deuterium, owner_solar_plant
    ) = NoGame.getResourcesBuildingsLevels(addresses.game, addresses.owner);
    let (owner_robot, owner_shipyard, owner_research, owner_nanite) = NoGame.getFacilitiesLevels(
        addresses.game, addresses.owner
    );
    let (owner_tech_levels) = NoGame.getTechLevels(addresses.game, addresses.owner);
    assert owner_metal = 0;
    assert owner_crystal = 0;
    assert owner_deuterium = 0;
    assert owner_solar_plant = 0;
    assert owner_robot = 0;
    assert owner_shipyard = 0;
    assert owner_research = 0;
    assert owner_nanite = 0;
    assert owner_tech_levels = TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    return ();
}

@external
func test_upgrades_after_transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    let addresses: Contracts = deploy_game();
    run_modules_manager(addresses);
    run_minter(addresses, 1);
    let planet_id = Uint256(1, 0);
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game);
    NoGame.solarUpgradeStart(addresses.game);
    time_warp(1000, addresses.resources);
    NoGame.solarUpgradeComplete(addresses.game);
    let (metal, crystal, deuterium, solar_plant) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.owner
    );
    assert solar_plant = 2;

    %{
        stop_prank_callable2 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.erc721)
    %}
    ERC721.transferFrom(addresses.erc721, addresses.owner, addresses.p1, planet_id);
    let (p1_metal, p1_crystal, p1_deuterium, p1_solar_plant) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.p1
    );
    let (
        owner_metal, owner_crystal, owner_deuterium, owner_solar_plant
    ) = NoGame.getResourcesBuildingsLevels(addresses.game, addresses.owner);
    assert p1_solar_plant = 2;
    assert owner_solar_plant = 0;

    %{
        stop_prank_callable1()
        stop_prank_callable1 = start_prank(
                   ids.addresses.p1, target_contract_address=ids.addresses.game)
    %}
    set_resources_levels(addresses, addresses.p1, 1000);
    NoGame.solarUpgradeStart(addresses.game);
    time_warp(2000, addresses.resources);
    NoGame.solarUpgradeComplete(addresses.game);
    let (
        new_p1_metal, new_p1_crystal, new_p1_deuterium, new_p1_solar_plant
    ) = NoGame.getResourcesBuildingsLevels(addresses.game, addresses.p1);
    assert new_p1_solar_plant = 3;
    return ();
}
