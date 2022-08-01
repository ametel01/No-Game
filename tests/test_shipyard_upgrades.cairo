%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from shipyard.library import Fleet
from tests.conftest import (
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
    _set_facilities_levels,
    _set_resource_levels,
    _reset_facilities_timelock,
    _reset_que,
)
from tests.interfaces import NoGame, ERC20
from utils.formulas import Formulas

@external
func test_build_base{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game)

    let (current_levels : Fleet) = NoGame.getFleetLevels(addresses.game, addresses.owner)
    assert current_levels = Fleet(0, 0, 0, 0, 0, 0, 0, 0)

    %{
        store(ids.addresses.game, "NoGame_shipyard_level", [10], [1,0])
        store(ids.addresses.game, "NoGame_combustion_drive", [10], [1,0])
        store(ids.addresses.game, "NoGame_shielding_tech", [10], [1,0])
        store(ids.addresses.game, "NoGame_espionage_tech", [10], [1,0])
        store(ids.addresses.game, "NoGame_ion_tech", [10], [1,0])
        store(ids.addresses.game, "NoGame_impulse_drive", [10], [1,0])
        store(ids.addresses.game, "NoGame_hyperspace_drive", [10], [1,0])
        store(ids.addresses.game, "NoGame_hyperspace_tech", [10], [1,0])
    %}
    let (_, shipyard, _, _) = NoGame.getFacilitiesLevels(addresses.game, addresses.owner)
    %{ print(ids.shipyard) %}
    _set_resource_levels(addresses.metal, addresses.owner, 2000000)
    _set_resource_levels(addresses.crystal, addresses.owner, 2000000)
    _set_resource_levels(addresses.deuterium, addresses.owner, 2000000)

    NoGame.cargoShipBuildStart(addresses.game, 1)
    %{ stop_warp = warp(1000, target_contract_address=ids.addresses.shipyard) %}
    NoGame.cargoShipBuildComplete(addresses.game)

    NoGame.recyclerShipBuildStart(addresses.game, 1)
    %{ stop_warp = warp(10000, target_contract_address=ids.addresses.shipyard) %}
    NoGame.recyclerShipBuildComplete(addresses.game)

    NoGame.espionageProbeBuildStart(addresses.game, 1)
    %{ stop_warp = warp(11000, target_contract_address=ids.addresses.shipyard) %}
    NoGame.espionageProbeBuildComplete(addresses.game)

    NoGame.solarSatelliteBuildStart(addresses.game, 1)
    %{ stop_warp = warp(12000, target_contract_address=ids.addresses.shipyard) %}
    NoGame.solarSatelliteBuildComplete(addresses.game)

    NoGame.lightFighterBuildStart(addresses.game, 1)
    %{ stop_warp = warp(15000, target_contract_address=ids.addresses.shipyard) %}
    NoGame.lightFighterBuildComplete(addresses.game)

    NoGame.cruiserBuildStart(addresses.game, 1)
    %{ stop_warp = warp(50000, target_contract_address=ids.addresses.shipyard) %}
    NoGame.cruiserBuildComplete(addresses.game)

    NoGame.battleShipBuildStart(addresses.game, 1)
    %{ stop_warp = warp(200000, target_contract_address=ids.addresses.shipyard) %}
    NoGame.battleShipBuildComplete(addresses.game)

    let (new_levels) = NoGame.getFleetLevels(addresses.game, addresses.owner)
    assert new_levels.cargo = 1
    assert new_levels.recycler = 1
    assert new_levels.espionage_probe = 1
    assert new_levels.solar_satellite = 1
    assert new_levels.light_fighter = 1
    assert new_levels.cruiser = 1
    assert new_levels.battle_ship = 1

    return ()
end
