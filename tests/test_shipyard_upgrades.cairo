%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from shipyard.library import (
    Fleet,
    _cargo_ship_cost,
    _recycler_ship_cost,
    _espionage_probe_cost,
    _solar_satellite_cost,
    _light_fighter_cost,
    _cruiser_cost,
    _battleship_cost,
)
from tests.conftest import (
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
    _set_facilities_levels,
    _set_resource_levels,
    _reset_shipyard_timelock,
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

@external
func test_upgrades_costs{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)
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

    tempvar inputs = new (1, 50, 250, 1000, 100000, 1000000)
    let inputs_len = 6

    %{ print("\n***test_cargo_upgrades_cost***" ) %}
    _test_cargo_cost_recursive(inputs_len, inputs, addresses)
    %{ print("\n***_test_recycler_cost_recursive***" ) %}
    _test_recycler_cost_recursive(inputs_len, inputs, addresses)
    %{ print("\n***_test_espionage_cost_recursive***" ) %}
    _test_espionage_cost_recursive(inputs_len, inputs, addresses)
    %{ print("\n***_test_satellite_cost_recursive***" ) %}
    _test_satellite_cost_recursive(inputs_len, inputs, addresses)
    %{ print("\n***_test_light_fighter_cost_recursive***" ) %}
    _test_light_fighter_cost_recursive(inputs_len, inputs, addresses)
    %{ print("\n***_test_cruiser_cost_recursive***" ) %}
    _test_cruiser_cost_recursive(inputs_len, inputs, addresses)
    %{ print("\n***_test_battleship_cost_recursive***" ) %}
    _test_battleship_cost_recursive(inputs_len, inputs, addresses)

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

    tempvar inputs = new (1, 50, 250, 1000, 100000, 1000000)
    let inputs_len = 6

    %{ print("\n***test_cargo_upgrades_time***" ) %}
    _test_cargo_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_recycler_upgrades_time***" ) %}
    _test_recycler_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***_test_espionage_time_recursive***" ) %}
    _test_espionage_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_satellite_upgrades_time***" ) %}
    _test_satellite_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_fighter_upgrades_time***" ) %}
    _test_fighter_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_cruiser_upgrades_time***" ) %}
    _test_cruiser_time_recursive(inputs_len, inputs, addresses)
    %{ print("\n***test_battleship_upgrades_time***" ) %}
    _test_battleship_time_recursive(inputs_len, inputs, addresses)
    return ()
end

@external
func test__reverts{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 1)
    %{ callable_1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

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

    _set_resource_levels(addresses.metal, addresses.owner, 2000000)
    _set_resource_levels(addresses.crystal, addresses.owner, 2000000)
    _set_resource_levels(addresses.deuterium, addresses.owner, 2000000)

    NoGame.cargoShipBuildStart(addresses.game, 1)
    %{ expect_revert(error_message="SHIPYARD::QUE IS BUSY") %}
    NoGame.battleShipBuildStart(addresses.game, 1)
    _reset_shipyard_timelock(addresses.facilities, addresses.owner)

    NoGame.espionageProbeBuildStart(addresses.game, 1)
    %{ expect_revert(error_message="SHIPYARD::TRIED TO COMPLETE THE WRONG SHIP") %}
    NoGame.cruiserBuildStart(addresses.game, 1)
    _reset_shipyard_timelock(addresses.facilities, addresses.owner)

    NoGame.solarSatelliteBuildStart(addresses.game, 1)
    %{ expect_revert(error_message="SHIPYARD::TIMELOCK NOT YET EXPIRED") %}
    NoGame.solarSatelliteBuildComplete(addresses.game)

    return ()
end

#######################################################################################################
#                                           PRIVATE FUNC                                              #
#######################################################################################################

func _test_cargo_cost_recursive{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    inputs_len : felt, inputs : felt*, addresses : Contracts
):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _cargo_ship_cost(input)
    %{ print(f"Cost for {ids.input} units: {ids.cost_metal}\t {ids.cost_crystal}\t {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.cargoShipBuildStart(addresses.game, input)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    let (deuterium_balance) = ERC20.balanceOf(addresses.deuterium, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    assert deuterium_balance = Uint256(0, 0)
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_cargo_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_recycler_cost_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _recycler_ship_cost(input)
    %{ print(f"Cost for {ids.input} units: {ids.cost_metal}\t {ids.cost_crystal}\t {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.recyclerShipBuildStart(addresses.game, input)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    let (deuterium_balance) = ERC20.balanceOf(addresses.deuterium, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    assert deuterium_balance = Uint256(0, 0)
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_recycler_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_espionage_cost_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _espionage_probe_cost(input)
    %{ print(f"Cost for {ids.input} units: {ids.cost_metal}\t {ids.cost_crystal}\t {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.espionageProbeBuildStart(addresses.game, input)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    let (deuterium_balance) = ERC20.balanceOf(addresses.deuterium, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    assert deuterium_balance = Uint256(0, 0)
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_espionage_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_satellite_cost_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _solar_satellite_cost(input)
    %{ print(f"Cost for {ids.input} units: {ids.cost_metal}\t {ids.cost_crystal}\t {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.solarSatelliteBuildStart(addresses.game, input)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    let (deuterium_balance) = ERC20.balanceOf(addresses.deuterium, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    assert deuterium_balance = Uint256(0, 0)
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_satellite_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_light_fighter_cost_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _light_fighter_cost(input)
    %{ print(f"Cost for {ids.input} units: {ids.cost_metal}\t {ids.cost_crystal}\t {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.lightFighterBuildStart(addresses.game, input)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    let (deuterium_balance) = ERC20.balanceOf(addresses.deuterium, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    assert deuterium_balance = Uint256(0, 0)
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_light_fighter_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_cruiser_cost_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _cruiser_cost(input)
    %{ print(f"Cost for {ids.input} units: {ids.cost_metal}\t {ids.cost_crystal}\t {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.cruiserBuildStart(addresses.game, input)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    let (deuterium_balance) = ERC20.balanceOf(addresses.deuterium, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    assert deuterium_balance = Uint256(0, 0)
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_cruiser_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_battleship_cost_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _battleship_cost(input)
    %{ print(f"Cost for {ids.input} units: {ids.cost_metal}\t {ids.cost_crystal}\t {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.battleShipBuildStart(addresses.game, input)
    let (metal_balance) = ERC20.balanceOf(addresses.metal, addresses.owner)
    let (crystal_balance) = ERC20.balanceOf(addresses.crystal, addresses.owner)
    let (deuterium_balance) = ERC20.balanceOf(addresses.deuterium, addresses.owner)
    assert metal_balance = Uint256(0, 0)
    assert crystal_balance = Uint256(0, 0)
    assert deuterium_balance = Uint256(0, 0)
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_battleship_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_cargo_time_recursive{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    inputs_len : felt, inputs : felt*, addresses : Contracts
):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _cargo_ship_cost(input)
    %{ print(f"Cost for {ids.input} units: m: {ids.cost_metal}\tc: {ids.cost_crystal}\td: {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.cargoShipBuildStart(addresses.game, input)

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 10, 0)
    let (que_details) = NoGame.getShipyardQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\tactual_time: {ids.que_details.lock_end}") %}
    assert expected_time = que_details.lock_end
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_cargo_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_recycler_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _recycler_ship_cost(input)
    %{ print(f"Cost for {ids.input} units: m: {ids.cost_metal}\tc: {ids.cost_crystal}\td: {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.recyclerShipBuildStart(addresses.game, input)

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 10, 0)
    let (que_details) = NoGame.getShipyardQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\tactual_time: {ids.que_details.lock_end}") %}
    assert expected_time = que_details.lock_end
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_recycler_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_espionage_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _espionage_probe_cost(input)
    %{ print(f"Cost for {ids.input} units: m: {ids.cost_metal}\tc: {ids.cost_crystal}\td: {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.espionageProbeBuildStart(addresses.game, input)

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 10, 0)
    let (que_details) = NoGame.getShipyardQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\tactual_time: {ids.que_details.lock_end}") %}
    assert expected_time = que_details.lock_end
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_espionage_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_satellite_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _solar_satellite_cost(input)
    %{ print(f"Cost for {ids.input} units: m: {ids.cost_metal}\tc: {ids.cost_crystal}\td: {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.solarSatelliteBuildStart(addresses.game, input)

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 10, 0)
    let (que_details) = NoGame.getShipyardQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\tactual_time: {ids.que_details.lock_end}") %}
    assert expected_time = que_details.lock_end
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_satellite_cost_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_fighter_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _light_fighter_cost(input)
    %{ print(f"Cost for {ids.input} units: m: {ids.cost_metal}\tc: {ids.cost_crystal}\td: {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.lightFighterBuildStart(addresses.game, input)

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 10, 0)
    let (que_details) = NoGame.getShipyardQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\tactual_time: {ids.que_details.lock_end}") %}
    assert expected_time = que_details.lock_end
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_fighter_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_cruiser_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _cruiser_cost(input)
    %{ print(f"Cost for {ids.input} units: m: {ids.cost_metal}\tc: {ids.cost_crystal}\td: {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.cruiserBuildStart(addresses.game, input)

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 10, 0)
    let (que_details) = NoGame.getShipyardQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\tactual_time: {ids.que_details.lock_end}") %}
    assert expected_time = que_details.lock_end
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_cruiser_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end

func _test_battleship_time_recursive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(inputs_len : felt, inputs : felt*, addresses : Contracts):
    if inputs_len == 0:
        return ()
    end
    let input = [inputs]
    let (cost_metal, cost_crystal, cost_deuterium) = _battleship_cost(input)
    %{ print(f"Cost for {ids.input} units: m: {ids.cost_metal}\tc: {ids.cost_crystal}\td: {ids.cost_deuterium}") %}
    _set_resource_levels(addresses.metal, addresses.owner, cost_metal)
    _set_resource_levels(addresses.crystal, addresses.owner, cost_crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, cost_deuterium)

    NoGame.battleShipBuildStart(addresses.game, input)

    let (expected_time) = Formulas.buildings_production_time(cost_metal, cost_crystal, 10, 0)
    let (que_details) = NoGame.getShipyardQueStatus(addresses.game, addresses.owner)
    %{ print(f"expected_time: {ids.expected_time}\tactual_time: {ids.que_details.lock_end}") %}
    assert expected_time = que_details.lock_end
    _reset_shipyard_timelock(addresses.shipyard, addresses.owner)

    _test_battleship_time_recursive(inputs_len - 1, inputs + 1, addresses)
    return ()
end
