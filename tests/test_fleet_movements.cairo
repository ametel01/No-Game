%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from main.structs import (
    Fleet,
    EspionageReport,
    ResourcesBuildings,
    FacilitiesBuildings,
    PlanetResources,
    TechLevels,
)
from token.erc20.interfaces.IERC20 import IERC20

from tests.setup import (
    Contracts,
    deploy_game,
    run_modules_manager,
    run_minter,
    time_warp,
    set_mines_levels,
    set_resources_levels,
    set_tech_levels,
    set_facilities_levels,
    warp_all,
)
from tests.interfaces import NoGame
from fleet_movements.IFleetMovements import IFleetMovements

const E18 = 10 ** 18;

@external
func test_espionage_mission{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let addresses: Contracts = deploy_game();
    run_modules_manager(addresses);
    run_minter(addresses, 2);
    %{
        stop_prank_callable = start_prank(
                ids.addresses.owner, target_contract_address=ids.addresses.game)
        store(ids.addresses.game, "NoGame_ships_espionage_probe", [1], key=[1,0])
        store(ids.addresses.game, "NoGame_ships_espionage_probe", [9], key=[2,0])
    %}
    NoGame.generatePlanet(addresses.game);
    %{
        stop_prank_callable()
        stop_prank_callable1 = start_prank(
                ids.addresses.p1, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game);
    %{
        stop_prank_callable1() 
        stop_prank_callable = start_prank(
                ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    set_resources_levels(addresses, addresses.p1, 12345);
    set_mines_levels(addresses.game, 2, 5, 4, 3, 8);
    set_facilities_levels(addresses.game, 2, 5, 4, 3, 2);
    set_tech_levels(addresses.game, 2, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 6, 7, 8);
    let (fuel_before) = IERC20.balanceOf(addresses.deuterium, addresses.owner);
    %{ store(ids.addresses.game, "NoGame_max_slots", [1,0], [5]) %}

    let ships = Fleet(0, 0, 1, 0, 0, 0, 0, 0);
    let destination = Uint256(2, 0);

    set_tech_levels(addresses.game, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 1;
    warp_all(100, addresses);
    let (report_0) = NoGame.readEspionageReport(addresses.game, addresses.owner, 1);
    let expected_report = EspionageReport(
        PlanetResources(0, 0, 0),
        ResourcesBuildings(0, 0, 0, 0),
        Fleet(0, 0, 0, 0, 0, 0, 0, 0),
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    assert report_0 = expected_report;

    set_tech_levels(addresses.game, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0);
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 1;
    warp_all(150, addresses);
    let (report_1) = NoGame.readEspionageReport(addresses.game, addresses.owner, 1);
    let expected_report = EspionageReport(
        PlanetResources(12395 * E18, 12369 * E18, 12353 * E18),
        ResourcesBuildings(0, 0, 0, 0),
        Fleet(0, 0, 0, 0, 0, 0, 0, 0),
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    assert report_1 = expected_report;

    set_tech_levels(addresses.game, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0);
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 1;
    warp_all(200, addresses);
    let (report_2) = NoGame.readEspionageReport(addresses.game, addresses.owner, 1);
    let expected_report = EspionageReport(
        PlanetResources(12411 * E18, 12377 * E18, 12355 * E18),
        ResourcesBuildings(5, 4, 3, 8),
        Fleet(0, 0, 0, 0, 0, 0, 0, 0),
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    assert report_2 = expected_report;

    set_tech_levels(addresses.game, 1, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0);
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 1;
    warp_all(300, addresses);
    let (report_3) = NoGame.readEspionageReport(addresses.game, addresses.owner, 1);
    let expected_report = EspionageReport(
        PlanetResources(12445 * E18, 12393 * E18, 12361 * E18),
        ResourcesBuildings(5, 4, 3, 8),
        Fleet(0, 0, 9, 0, 0, 0, 0, 0),
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    assert report_3 = expected_report;

    set_tech_levels(addresses.game, 1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0);
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 1;
    warp_all(350, addresses);
    let (report_4) = NoGame.readEspionageReport(addresses.game, addresses.owner, 1);
    let expected_report = EspionageReport(
        PlanetResources(12462 * E18, 12401 * E18, 12363 * E18),
        ResourcesBuildings(5, 4, 3, 8),
        Fleet(0, 0, 9, 0, 0, 0, 0, 0),
        FacilitiesBuildings(5, 4, 3, 2),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    assert report_4 = expected_report;

    set_tech_levels(addresses.game, 1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0);
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 1;
    warp_all(400, addresses);
    let (report_5) = NoGame.readEspionageReport(addresses.game, addresses.owner, 1);
    let expected_report = EspionageReport(
        PlanetResources(12478 * E18, 12410 * E18, 12366 * E18),
        ResourcesBuildings(5, 4, 3, 8),
        Fleet(0, 0, 9, 0, 0, 0, 0, 0),
        FacilitiesBuildings(5, 4, 3, 2),
        TechLevels(1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 6, 7, 8),
    );
    assert report_5 = expected_report;

    let (fuel_after) = IERC20.balanceOf(addresses.deuterium, addresses.owner);
    let (fleet_que) = IFleetMovements.getQueStatus(addresses.fleet, addresses.owner, 1);
    assert fleet_que.planet_id = 1;
    assert fleet_que.mission_id = 1;
    assert fleet_que.time_end = 400;
    assert fleet_que.destination = 2;

    return ();
}
