%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from defences.library import (
    Defence,
    _rocket_cost,
    _light_laser_cost,
    _heavy_laser_cost,
    _ion_cannon_cost,
    _gauss_cost,
    _plasma_turret_cost,
    _small_dome_cost,
    _large_dome_cost,
)
from tests.setup import (
    Contracts,
    deploy_game,
    run_modules_manager,
    run_minter,
    time_warp,
    set_facilities_levels,
    set_resources_levels,
    reset_shipyard_timelock,
    reset_que,
)

from tests.interfaces import NoGame, ERC20, ERC721
from utils.formulas import Formulas

@external
func test_build_base{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let addresses: Contracts = deploy_game();
    run_modules_manager(addresses);
    run_minter(addresses, 1);
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game);
    let (current_levels: Defence) = NoGame.getDefenceLevels(addresses.game, addresses.owner);
    assert current_levels = Defence(0, 0, 0, 0, 0, 0, 0, 0);

    %{
        store(ids.addresses.game, "NoGame_shipyard_level", [8], [1,0])
        store(ids.addresses.game, "NoGame_shielding_tech", [6], [1,0])
        store(ids.addresses.game, "NoGame_weapons_tech", [3], [1,0])
        store(ids.addresses.game, "NoGame_ion_tech", [4], [1,0])
        store(ids.addresses.game, "NoGame_energy_tech", [6], [1,0])
        store(ids.addresses.game, "NoGame_plasma_tech", [7], [1,0])
        store(ids.addresses.game, "NoGame_laser_tech", [6], [1,0])
    %}
    set_resources_levels(addresses, addresses.owner, 2000000);

    NoGame.rocketBuildStart(addresses.game, 1);
    %{ stop_warp = warp(1000, target_contract_address=ids.addresses.defences) %}
    NoGame.rocketBuildComplete(addresses.game);

    NoGame.lightLaserBuildStart(addresses.game, 1);
    %{ stop_warp = warp(20000, target_contract_address=ids.addresses.defences) %}
    NoGame.lightLaserBuildComplete(addresses.game);

    NoGame.heavyLaserBuildStart(addresses.game, 1);
    %{ stop_warp = warp(30000, target_contract_address=ids.addresses.defences) %}
    NoGame.heavyLaserBuildComplete(addresses.game);

    NoGame.ionCannonBuildStart(addresses.game, 1);
    %{ stop_warp = warp(40000, target_contract_address=ids.addresses.defences) %}
    NoGame.ionCannonBuildComplete(addresses.game);

    NoGame.gaussBuildStart(addresses.game, 1);
    %{ stop_warp = warp(50000, target_contract_address=ids.addresses.defences) %}
    NoGame.gaussBuildComplete(addresses.game);

    NoGame.plasmaTurretBuildStart(addresses.game, 1);
    %{ stop_warp = warp(600000, target_contract_address=ids.addresses.defences) %}
    NoGame.plasmaTurretBuildComplete(addresses.game);

    NoGame.smallDomeBuildStart(addresses.game);
    %{ stop_warp = warp(700000, target_contract_address=ids.addresses.defences) %}
    NoGame.smallDomeBuildComplete(addresses.game);

    NoGame.largeDomeBuildStart(addresses.game);
    %{ stop_warp = warp(800000, target_contract_address=ids.addresses.defences) %}
    NoGame.largeDomeBuildComplete(addresses.game);

    let (new_level) = NoGame.getDefenceLevels(addresses.game, addresses.owner);
    assert new_level.rocket = 1;
    assert new_level.light_laser = 1;
    assert new_level.heavy_laser = 1;
    assert new_level.ion_cannon = 1;
    assert new_level.gauss = 1;
    assert new_level.plasma_turret = 1;
    assert new_level.small_dome = 1;
    assert new_level.large_dome = 1;

    return ();
}
