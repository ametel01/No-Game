%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from main.library import _get_net_energy, _calculate_production
from resources.library import (
    _metal_building_cost,
    _crystal_building_cost,
    _deuterium_building_cost,
    _solar_plant_building_cost,
)
from utils.formulas import Formulas

@external
func test_plant_production{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Formulas.solar_production(54);
    return ();
}

@external
func test_energy_consumption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Formulas.consumption_energy(45);
    return ();
}

@external
func test_consumption_deuterium{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (energy) = Formulas.consumption_energy_deuterium(45);
    %{ print(f"energy: {ids.energy}") %}
    return ();
}

@external
func test_metal_cost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (metal, crystal) = _metal_building_cost(45);
    %{ print(f"metal: {ids.metal}\t crystal: {ids.crystal}") %}
    return ();
}

@external
func test_crystal_cost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (metal, crystal) = _crystal_building_cost(45);
    %{ print(f"metal: {ids.metal}\t crystal: {ids.crystal}") %}
    return ();
}

@external
func test_deuterium_cost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (metal, crystal) = _deuterium_building_cost(45);
    %{ print(f"metal: {ids.metal}\t crystal: {ids.crystal}") %}
    return ();
}
