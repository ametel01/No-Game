%lang starknet

from resources.library import (
    _metal_building_cost,
    _crystal_building_cost,
    _deuterium_building_cost,
    _solar_plant_building_cost,
)
from tests.conftest import _get_expected_cost

@external
func test_metal{syscall_ptr : felt*, range_check_ptr}():
    let (metal, crystal) = _metal_building_cost(1)
    let (exp_metal, exp_crystal) = _get_expected_cost(60, 15, 15, 1)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _metal_building_cost(5)
    let (exp_metal, exp_crystal) = _get_expected_cost(60, 15, 15, 5)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _metal_building_cost(10)
    let (exp_metal, exp_crystal) = _get_expected_cost(60, 15, 15, 10)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _metal_building_cost(15)
    let (exp_metal, exp_crystal) = _get_expected_cost(60, 15, 15, 15)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _metal_building_cost(20)
    let (exp_metal, exp_crystal) = _get_expected_cost(60, 15, 15, 20)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _metal_building_cost(30)
    let (exp_metal, exp_crystal) = _get_expected_cost(60, 15, 15, 30)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _metal_building_cost(40)
    let (exp_metal, exp_crystal) = _get_expected_cost(60, 15, 15, 40)
    assert metal = exp_metal
    assert crystal = exp_crystal

    return ()
end

@external
func test_crystal{syscall_ptr : felt*, range_check_ptr}():
    let (metal, crystal) = _crystal_building_cost(1)
    let (exp_metal, exp_crystal) = _get_expected_cost(48, 24, 16, 1)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _crystal_building_cost(5)
    let (exp_metal, exp_crystal) = _get_expected_cost(48, 24, 16, 5)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _crystal_building_cost(10)
    let (exp_metal, exp_crystal) = _get_expected_cost(48, 24, 16, 10)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _crystal_building_cost(15)
    let (exp_metal, exp_crystal) = _get_expected_cost(48, 24, 16, 15)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _crystal_building_cost(20)
    let (exp_metal, exp_crystal) = _get_expected_cost(48, 24, 16, 20)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _crystal_building_cost(30)
    let (exp_metal, exp_crystal) = _get_expected_cost(48, 24, 16, 30)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _crystal_building_cost(40)
    let (exp_metal, exp_crystal) = _get_expected_cost(48, 24, 16, 40)
    assert metal = exp_metal
    assert crystal = exp_crystal

    return ()
end

@external
func test_deuterium{syscall_ptr : felt*, range_check_ptr}():
    let (metal, crystal) = _deuterium_building_cost(1)
    let (exp_metal, exp_crystal) = _get_expected_cost(225, 75, 15, 1)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _deuterium_building_cost(5)
    let (exp_metal, exp_crystal) = _get_expected_cost(225, 75, 15, 5)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _deuterium_building_cost(10)
    let (exp_metal, exp_crystal) = _get_expected_cost(225, 75, 15, 10)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _deuterium_building_cost(15)
    let (exp_metal, exp_crystal) = _get_expected_cost(225, 75, 15, 15)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _deuterium_building_cost(20)
    let (exp_metal, exp_crystal) = _get_expected_cost(225, 75, 15, 20)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _deuterium_building_cost(30)
    let (exp_metal, exp_crystal) = _get_expected_cost(225, 75, 15, 30)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _deuterium_building_cost(40)
    let (exp_metal, exp_crystal) = _get_expected_cost(225, 75, 15, 40)
    assert metal = exp_metal
    assert crystal = exp_crystal

    return ()
end

@external
func test_solar{syscall_ptr : felt*, range_check_ptr}():
    let (metal, crystal) = _solar_plant_building_cost(1)
    let (exp_metal, exp_crystal) = _get_expected_cost(75, 30, 15, 1)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _solar_plant_building_cost(5)
    let (exp_metal, exp_crystal) = _get_expected_cost(75, 30, 15, 5)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _solar_plant_building_cost(10)
    let (exp_metal, exp_crystal) = _get_expected_cost(75, 30, 15, 10)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _solar_plant_building_cost(15)
    let (exp_metal, exp_crystal) = _get_expected_cost(75, 30, 15, 15)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _solar_plant_building_cost(20)
    let (exp_metal, exp_crystal) = _get_expected_cost(75, 30, 15, 20)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _solar_plant_building_cost(30)
    let (exp_metal, exp_crystal) = _get_expected_cost(75, 30, 15, 30)
    assert metal = exp_metal
    assert crystal = exp_crystal

    let (metal, crystal) = _solar_plant_building_cost(40)
    let (exp_metal, exp_crystal) = _get_expected_cost(75, 30, 15, 40)
    assert metal = exp_metal
    assert crystal = exp_crystal

    return ()
end
