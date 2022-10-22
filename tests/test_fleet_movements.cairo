%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from main.structs import Fleet

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
)
from tests.interfaces import NoGame

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
    // set_tech_levels(addresses.game, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

    %{ store(ids.addresses.game, "NoGame_max_slots", [1,0], [2]) %}
    let ships = Fleet(0, 0, 1, 0, 0, 0, 0, 0);
    let destination = Uint256(2, 0);
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 1;
    let (res) = NoGame.sendEspionageMission(addresses.game, ships, destination);
    assert res = 2;
    return ();
}
