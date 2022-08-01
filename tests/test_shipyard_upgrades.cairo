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
        store(ids.addresses.game, "NoGame_shipyard_level", [2], [1,0])
        store(ids.addresses.game, "NoGame_combustion_drive", [2], [1,0])
    %}
    let (_, shipyard, _, _) = NoGame.getFacilitiesLevels(addresses.game, addresses.owner)
    %{ print(ids.shipyard) %}
    _set_resource_levels(addresses.metal, addresses.owner, 2000000)
    _set_resource_levels(addresses.crystal, addresses.owner, 2000000)
    _set_resource_levels(addresses.deuterium, addresses.owner, 2000000)

    NoGame.cargoShipBuildStart(addresses.game, 1)
    %{ stop_warp = warp(1000) %}
    NoGame.cargoShipBuildComplete(addresses.game)
    let (new_levels) = NoGame.getFleetLevels(addresses.game, addresses.owner)
    assert new_levels.cargo = 1

    return ()
end
