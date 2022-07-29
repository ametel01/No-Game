%lang starknet

from starkware.cairo.common.uint256 import Uint256
from resources.library import (
    _metal_building_cost,
    _crystal_building_cost,
    _deuterium_building_cost,
    _solar_plant_building_cost,
)
from tests.conftest import (
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
    _set_mines_levels,
    _set_resource_levels,
    _reset_timelock,
)
from tests.interfaces import NoGame, ERC20
from utils.formulas import Formulas

@external
func test_upgrade_mines_base{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game)
    let (prev_metal, prev_crystal, prev_deuterium, prev_solar) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.owner
    )
    NoGame.metalUpgradeStart(addresses.game)
    _time_warp(1000, addresses.resources)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _time_warp(2000, addresses.resources)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _time_warp(3000, addresses.resources)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _time_warp(4000, addresses.resources)
    NoGame.solarUpgradeComplete(addresses.game)

    let (new_metal, new_crystal, new_deuterium, new_solar) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.owner
    )
    assert new_metal = prev_metal + 1
    assert new_crystal = prev_crystal + 1
    assert new_deuterium = prev_deuterium + 1
    assert new_solar = prev_solar + 1
    return ()
end

@external
func test_upgrades_costs{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    tempvar inputs = new (1, 5, 10, 20, 30, 45)
    let inputs_len = 6

    %{ print("\n***test_metal_upgrades_cost***" ) %}
    _test_metal_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_crystal_upgrades_cost***" ) %}
    _test_crystal_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_deuterium_upgrades_cost***" ) %}
    _test_deuterium_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_solar_upgrades_cost***" ) %}
    _test_solar_recursive(inputs_len, inputs, addresses)

    return ()
end

# @external
# func test_upgrades_time{syscall_ptr : felt*, range_check_ptr}():

func _test_metal_recursive{syscall_ptr : felt*, range_check_ptr}(
    inputs_len : felt, inputs : felt*, addresses : Contracts
):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal) = _metal_building_cost(input)
    %{ print(f"Cost_level {ids.input}: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=input, c=0, d=0, s=0)
    NoGame.metalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    _test_metal_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_crystal_recursive{syscall_ptr : felt*, range_check_ptr}(
    inputs_len : felt, inputs : felt*, addresses : Contracts
):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal) = _crystal_building_cost(input)
    %{ print(f"Cost_level {ids.input}: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=input, d=0, s=0)
    NoGame.crystalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    _test_crystal_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_deuterium_recursive{syscall_ptr : felt*, range_check_ptr}(
    inputs_len : felt, inputs : felt*, addresses : Contracts
):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal) = _deuterium_building_cost(input)
    %{ print(f"Cost_level {ids.input}: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=input, s=0)
    NoGame.deuteriumUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    _test_deuterium_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_solar_recursive{syscall_ptr : felt*, range_check_ptr}(
    inputs_len : felt, inputs : felt*, addresses : Contracts
):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal) = _solar_plant_building_cost(input)
    %{ print(f"Cost_level {ids.input}: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=0, s=input)
    NoGame.solarUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    _test_solar_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end
