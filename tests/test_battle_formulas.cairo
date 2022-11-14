%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from main.structs import Fleet, Defence

from fleet_movements.library import (
    get_total_defences_shield_power,
    get_total_defences_structural_power,
    get_total_defences_weapons_power,
    get_total_fleet_shield_power,
    get_total_fleet_structural_integrity,
    get_total_fleet_weapon_power,
    calculate_battle_outcome,
)

let ATTACKER_FLEET = Fleet(10, 0, 0, 0, 0, 0, 0, 0);
let DEFENDER_FLEET = Fleet(0, 0, 0, 10, 0, 0, 0, 0);

@external
func test_battle_round{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let ATTACKER_FLEET = Fleet(10, 0, 0, 0, 0, 0, 0, 0);
    let DEFENDER_FLEET = Fleet(0, 0, 0, 10, 0, 0, 0, 0);
    let DEFENCES = Defence(10, 0, 0, 0, 0, 0, 0, 0);
    let expected = (attacker_points=39290, defender_points=40160);
    let actual = calculate_battle_outcome(ATTACKER_FLEET, DEFENDER_FLEET, DEFENCES);
    assert expected = actual;
    return ();
}

@external
func test_fleet_shield{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let FLEET = Fleet(10, 0, 0, 0, 0, 0, 0, 0);
    let expected = 100;
    let actual = get_total_fleet_shield_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 0, 0, 0, 0, 0, 0);
    let expected = 200;
    let actual = get_total_fleet_shield_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 0, 0, 0, 0, 0);
    let expected = 200;
    let actual = get_total_fleet_shield_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 0, 0, 0, 0);
    let expected = 210;
    let actual = get_total_fleet_shield_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 0, 0, 0);
    let expected = 310;
    let actual = get_total_fleet_shield_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 10, 0, 0);
    let expected = 810;
    let actual = get_total_fleet_shield_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 10, 10, 0);
    let expected = 2810;
    let actual = get_total_fleet_shield_power(FLEET);
    assert expected = actual;

    return ();
}

@external
func test_fleet_struct{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let FLEET = Fleet(10, 0, 0, 0, 0, 0, 0, 0);
    let expected = 40000;
    let actual = get_total_fleet_structural_integrity(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 0, 0, 0, 0, 0, 0);
    let expected = 200000;
    let actual = get_total_fleet_structural_integrity(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 0, 0, 0, 0, 0);
    let expected = 210000;
    let actual = get_total_fleet_structural_integrity(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 0, 0, 0, 0);
    let expected = 230000;
    let actual = get_total_fleet_structural_integrity(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 0, 0, 0);
    let expected = 270000;
    let actual = get_total_fleet_structural_integrity(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 10, 0, 0);
    let expected = 540000;
    let actual = get_total_fleet_structural_integrity(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 10, 10, 0);
    let expected = 1140000;
    let actual = get_total_fleet_structural_integrity(FLEET);
    assert expected = actual;

    return ();
}

@external
func test_fleet_weapons{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let FLEET = Fleet(10, 0, 0, 0, 0, 0, 0, 0);
    let expected = 50;
    let actual = get_total_fleet_weapon_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 0, 0, 0, 0, 0, 0);
    let expected = 60;
    let actual = get_total_fleet_weapon_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 0, 0, 0, 0, 0);
    let expected = 60;
    let actual = get_total_fleet_weapon_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 0, 0, 0, 0);
    let expected = 70;
    let actual = get_total_fleet_weapon_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 0, 0, 0);
    let expected = 570;
    let actual = get_total_fleet_weapon_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 10, 0, 0);
    let expected = 4570;
    let actual = get_total_fleet_weapon_power(FLEET);
    assert expected = actual;

    let FLEET = Fleet(10, 10, 10, 10, 10, 10, 10, 0);
    let expected = 14570;
    let actual = get_total_fleet_weapon_power(FLEET);
    assert expected = actual;

    return ();
}

@external
func test_defence_shield{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let DEFENCES = Defence(10, 0, 0, 0, 0, 0, 0, 0);
    let expected = 200;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 0, 0, 0, 0, 0, 0);
    let expected = 450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 0, 0, 0, 0, 0);
    let expected = 1450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 0, 0, 0, 0);
    let expected = 6450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 0, 0, 0);
    let expected = 8450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 0, 0);
    let expected = 11450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 0);
    let expected = 13450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 1);
    let expected = 23450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected = actual;

    return ();
}

@external
func test_defence_struct{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let DEFENCES = Defence(10, 0, 0, 0, 0, 0, 0, 0);
    let expected = 20000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 0, 0, 0, 0, 0, 0);
    let expected = 40000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 0, 0, 0, 0, 0);
    let expected = 120000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 0, 0, 0, 0);
    let expected = 200000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 0, 0, 0);
    let expected = 550000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 0, 0);
    let expected = 1550000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 0);
    let expected = 1570000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 1);
    let expected = 1670000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected = actual;

    return ();
}

@external
func test_defence_weapons{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let DEFENCES = Defence(10, 0, 0, 0, 0, 0, 0, 0);
    let expected = 800;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 0, 0, 0, 0, 0, 0);
    let expected = 1800;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 0, 0, 0, 0, 0);
    let expected = 4300;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 0, 0, 0, 0);
    let expected = 5800;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 0, 0, 0);
    let expected = 16800;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 0, 0);
    let expected = 46800;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 0);
    let expected = 46801;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 1);
    let expected = 46802;
    let actual = get_total_defences_weapons_power(DEFENCES);
    assert expected = actual;

    return ();
}
