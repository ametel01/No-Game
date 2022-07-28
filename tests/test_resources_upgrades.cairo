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
    E18,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
    _set_mines_levels,
    _set_resource_levels,
    _reset_timelock,
)
from tests.interfaces import NoGame, ERC20

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
func test_metal_upgrades_cost{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    %{ print("test_metal_upgrades_cost:\n" ) %}
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    # Testing cost level 1 mine
    let (cost_metal, cost_crystal) = _metal_building_cost(1)
    %{ print(f"Cost_level 2: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=1, c=0, d=0, s=0)
    NoGame.metalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 10 mine
    let (cost_metal, cost_crystal) = _metal_building_cost(10)
    %{ print(f"Cost_level 11: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=10, c=0, d=0, s=0)
    NoGame.metalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 15 mine
    let (cost_metal, cost_crystal) = _metal_building_cost(15)
    %{ print(f"Cost_level 16: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=15, c=0, d=0, s=0)
    NoGame.metalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 20 mine
    let (cost_metal, cost_crystal) = _metal_building_cost(20)
    %{ print(f"Cost_level 21: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=20, c=0, d=0, s=0)
    NoGame.metalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 30 mine
    let (cost_metal, cost_crystal) = _metal_building_cost(30)
    %{ print(f"Cost_level 31: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=30, c=0, d=0, s=0)
    NoGame.metalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 40 mine
    let (cost_metal, cost_crystal) = _metal_building_cost(40)
    %{ print(f"Cost_level 41: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=40, c=0, d=0, s=0)
    NoGame.metalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    return ()
end

@external
func test_crystal_upgrades_cost{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    %{ print("test_crystal_upgrades_cost:\n" ) %}
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    # Testing cost level 1 mine
    let (cost_metal, cost_crystal) = _crystal_building_cost(1)
    %{ print(f"Cost_level 2: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=1, d=0, s=0)
    NoGame.crystalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 10 mine
    let (cost_metal, cost_crystal) = _crystal_building_cost(10)
    %{ print(f"Cost_level 11: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=10, d=0, s=0)
    NoGame.crystalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 15 mine
    let (cost_metal, cost_crystal) = _crystal_building_cost(15)
    %{ print(f"Cost_level 16: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=15, d=0, s=0)
    NoGame.crystalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 20 mine
    let (cost_metal, cost_crystal) = _crystal_building_cost(20)
    %{ print(f"Cost_level 21: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=20, d=0, s=0)
    NoGame.crystalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 30 mine
    let (cost_metal, cost_crystal) = _crystal_building_cost(30)
    %{ print(f"Cost_level 31: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=30, d=0, s=0)
    NoGame.crystalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 40 mine
    let (cost_metal, cost_crystal) = _crystal_building_cost(40)
    %{ print(f"Cost_level 41: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=40, d=0, s=0)
    NoGame.crystalUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    return ()
end

@external
func test_deuterium_upgrades_cost{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    %{ print("test_deuterium_upgrades_cost:\n" ) %}
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    # Testing cost level 1 mine
    let (cost_metal, cost_crystal) = _deuterium_building_cost(1)
    %{ print(f"Cost_level 2: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=1, s=0)
    NoGame.deuteriumUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 10 mine
    let (cost_metal, cost_crystal) = _deuterium_building_cost(10)
    %{ print(f"Cost_level 11: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=10, s=0)
    NoGame.deuteriumUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 15 mine
    let (cost_metal, cost_crystal) = _deuterium_building_cost(15)
    %{ print(f"Cost_level 16: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=15, s=0)
    NoGame.deuteriumUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 20 mine
    let (cost_metal, cost_crystal) = _deuterium_building_cost(20)
    %{ print(f"Cost_level 21: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=20, s=0)
    NoGame.deuteriumUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 30 mine
    let (cost_metal, cost_crystal) = _deuterium_building_cost(30)
    %{ print(f"Cost_level 31: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=30, s=0)
    NoGame.deuteriumUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 40 mine
    let (cost_metal, cost_crystal) = _deuterium_building_cost(40)
    %{ print(f"Cost_level 41: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=40, s=0)
    NoGame.deuteriumUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    return ()
end

@external
func test_solar_upgrades_cost{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    %{ print("test_solar_upgrades_cost:\n" ) %}
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    # Testing cost level 1 mine
    let (cost_metal, cost_crystal) = _solar_plant_building_cost(1)
    %{ print(f"Cost_level 2: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=0, s=1)
    NoGame.solarUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 10 mine
    let (cost_metal, cost_crystal) = _solar_plant_building_cost(10)
    %{ print(f"Cost_level 11: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=0, s=10)
    NoGame.solarUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 15 mine
    let (cost_metal, cost_crystal) = _solar_plant_building_cost(15)
    %{ print(f"Cost_level 16: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=0, s=15)
    NoGame.solarUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 20 mine
    let (cost_metal, cost_crystal) = _solar_plant_building_cost(20)
    %{ print(f"Cost_level 21: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=0, s=20)
    NoGame.solarUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 30 mine
    let (cost_metal, cost_crystal) = _solar_plant_building_cost(30)
    %{ print(f"Cost_level 31: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=0, s=30)
    NoGame.solarUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    # Testing cost level 40 mine
    let (cost_metal, cost_crystal) = _solar_plant_building_cost(40)
    %{ print(f"Cost_level 41: {ids.cost_metal}\t {ids.cost_crystal}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_mines_levels(addresses.game, id=1, m=0, c=0, d=0, s=40)
    NoGame.solarUpgradeStart(addresses.game)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    _reset_timelock(addresses.resources, addresses.owner)

    return ()
end
