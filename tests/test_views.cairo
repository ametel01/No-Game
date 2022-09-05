%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

from tests.conftest import (
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
    _set_mines_levels,
    _set_facilities_levels,
    _set_resource_levels,
    _set_tech_levels,
    _reset_lab_timelock,
    _reset_que,
    _warp_all,
)
from tests.interfaces import NoGame, ERC20
from utils.formulas import Formulas
from main.structs import TechLevels

@external
func test_main_views{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (addresses: Contracts) = _get_test_addresses();
    _run_modules_manager(addresses);
    _run_minter(addresses, 10);
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game);

    let (m, c, d, s) = NoGame.getResourcesUpgradeCost(addresses.game, addresses.owner);
    %{ print(f"getResourcesUpgradeCost\nmetal: {ids.m.metal}\tcrystal: {ids.m.crystal}\tdeuterium: {ids.m.deuterium}\tenergy: {ids.m.energy_cost}") %}

    let (ro, sh, re, na) = NoGame.getFacilitiesUpgradeCost(addresses.game, addresses.owner);
    %{ print(f"getFacilitiesUpgradeCost\nmetal: {ids.ro.metal}\tcrystal: {ids.ro.crystal}\tdeuterium: {ids.ro.deuterium}\tenergy: {ids.ro.energy_cost}") %}

    let (arm, _, _, _, _, _, _, _, _, _, _, _, _, _) = NoGame.getTechUpgradeCost(
        addresses.game, addresses.owner
    );
    %{ print(f"getTechUpgradeCost\nmetal: {ids.arm.metal}\tcrystal: {ids.arm.crystal}\tdeuterium: {ids.arm.deuterium}\tenergy: {ids.arm.energy_cost}") %}

    let (cargo, _, _, _, _, _, _) = NoGame.getShipsCost(addresses.game);
    %{ print(f"getShipsCost\nmetal: {ids.cargo.metal}\tcrystal: {ids.cargo.crystal}\tdeuterium: {ids.cargo.deuterium}\tenergy: {ids.cargo.energy_cost}") %}

    _set_mines_levels(addresses.game, 1, 1, 1, 1, 4);
    _warp_all(3600, addresses);
    let (metal, crystal, deuterium, energy) = NoGame.getResourcesAvailable(
        addresses.game, addresses.owner
    );
    %{ print(f"getResourcesAvailable\nmetal: {ids.metal}\tcrystal: {ids.crystal}\tdeuterium: {ids.deuterium}\tenergy: {ids.energy}") %}

    return ();
}
