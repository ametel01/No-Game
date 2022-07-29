%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
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
    _reset_que,
)
from tests.interfaces import NoGame, ERC20
from utils.formulas import Formulas
from resources.library import (
    ResourcesQue,
    METAL_MINE_ID,
    CRYSTAL_MINE_ID,
    DEUTERIUM_MINE_ID,
    SOLAR_PLANT_ID,
)

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

@external
func test_upgrades_time{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    tempvar inputs = new (1, 5, 10, 20, 30, 45)
    let inputs_len = 6

    %{ print("\n***test_metal_upgrades_time***" ) %}
    _test_metal_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_crystal_upgrades_time***" ) %}
    _test_crystal_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_deuterium_upgrades_time***" ) %}
    _test_deuterium_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_solar_upgrades_time***" ) %}
    _test_solar_time_recursive(inputs_len, inputs, addresses)

    return ()
end

@external
func test_busy_que_reverts{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::QUE IS BUSY!!!") %}
    NoGame.crystalUpgradeStart(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    NoGame.crystalUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::QUE IS BUSY!!!") %}
    NoGame.metalUpgradeStart(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    NoGame.deuteriumUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::QUE IS BUSY!!!") %}
    NoGame.solarUpgradeStart(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    NoGame.solarUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::QUE IS BUSY!!!") %}
    NoGame.deuteriumUpgradeStart(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    return ()
end

@external
func test_wrong_resource_reverts{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    %{ stop_warp = warp(1000) %}
    %{ expect_revert(error_message="RESOURCES::TRIED TO COMPLETE THE WRONG RESOURCE!!!") %}
    NoGame.crystalUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    NoGame.crystalUpgradeStart(addresses.game)
    %{ stop_warp = warp(2000) %}
    %{ expect_revert(error_message="RESOURCES::TRIED TO COMPLETE THE WRONG RESOURCE!!!") %}
    NoGame.metalUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    NoGame.deuteriumUpgradeStart(addresses.game)
    %{ stop_warp = warp(3000) %}
    %{ expect_revert(error_message="RESOURCES::TRIED TO COMPLETE THE WRONG RESOURCE!!!") %}
    NoGame.solarUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    NoGame.solarUpgradeStart(addresses.game)
    %{ stop_warp = warp(4000) %}
    %{ expect_revert(error_message="RESOURCES::TRIED TO COMPLETE THE WRONG RESOURCE!!!") %}
    NoGame.deuteriumUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)

    return ()
end

@external
func test_enough_resources_reverts{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    %{ store(ids.addresses.metal, "ERC20_balances", [0,0], key=[ids.addresses.owner]) %}

    %{ expect_revert(error_message="RESOURCES::NOT ENOUGH RESOURCES!!!") %}
    NoGame.metalUpgradeStart(addresses.game)

    %{ expect_revert(error_message="RESOURCES::NOT ENOUGH RESOURCES!!!") %}
    NoGame.crystalUpgradeStart(addresses.game)

    %{ expect_revert(error_message="RESOURCES::NOT ENOUGH RESOURCES!!!") %}
    NoGame.deuteriumUpgradeStart(addresses.game)

    %{ expect_revert(error_message="RESOURCES::NOT ENOUGH RESOURCES!!!") %}
    NoGame.solarUpgradeStart(addresses.game)

    return ()
end

@external
func test_timelock_expired_reverts{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::TIMELOCK NOT YET EXPIRED!!!") %}
    NoGame.metalUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)
    _reset_que(addresses.resources, addresses.owner, METAL_MINE_ID)

    NoGame.crystalUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::TIMELOCK NOT YET EXPIRED!!!") %}
    NoGame.crystalUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)
    _reset_que(addresses.resources, addresses.owner, CRYSTAL_MINE_ID)

    NoGame.deuteriumUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::TIMELOCK NOT YET EXPIRED!!!") %}
    NoGame.deuteriumUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)
    _reset_que(addresses.resources, addresses.owner, DEUTERIUM_MINE_ID)

    NoGame.solarUpgradeStart(addresses.game)
    %{ expect_revert(error_message="RESOURCES::TIMELOCK NOT YET EXPIRED!!!") %}
    NoGame.solarUpgradeComplete(addresses.game)
    _reset_timelock(addresses.resources, addresses.owner)
    _reset_que(addresses.resources, addresses.owner, SOLAR_PLANT_ID)

    return ()
end

#######################################################################################################
#                                           PRIVATE FUNC                                              #
#######################################################################################################

func _test_metal_time_recursive{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
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

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 0, 0)
    let (que_details) = NoGame.getResourcesQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\t actual_time: {ids.que_details.lock_end}\n") %}
    assert expected_time = que_details.lock_end
    _reset_timelock(addresses.resources, addresses.owner)

    _test_metal_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_crystal_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
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

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 0, 0)
    let (que_details) = NoGame.getResourcesQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\t actual_time: {ids.que_details.lock_end}\n") %}
    assert expected_time = que_details.lock_end
    _reset_timelock(addresses.resources, addresses.owner)

    _test_metal_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_deuterium_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
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

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 0, 0)
    let (que_details) = NoGame.getResourcesQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\t actual_time: {ids.que_details.lock_end}\n") %}
    assert expected_time = que_details.lock_end
    _reset_timelock(addresses.resources, addresses.owner)

    _test_metal_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_solar_time_recursive{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
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

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 0, 0)
    let (que_details) = NoGame.getResourcesQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\t actual_time: {ids.que_details.lock_end}\n") %}
    assert expected_time = que_details.lock_end
    _reset_timelock(addresses.resources, addresses.owner)

    _test_metal_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

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
