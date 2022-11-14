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
func test_defence_shield{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let DEFENCES = Defence(10, 0, 0, 0, 0, 0, 0, 0);
    let expected1 = 200;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected1 = actual;

    let DEFENCES = Defence(10, 10, 0, 0, 0, 0, 0, 0);
    let expected2 = 450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected2 = actual;

    let DEFENCES = Defence(10, 10, 10, 0, 0, 0, 0, 0);
    let expected3 = 1450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected3 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 0, 0, 0, 0);
    let expected4 = 6450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected4 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 0, 0, 0);
    let expected5 = 8450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected5 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 0, 0);
    let expected6 = 11450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected6 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 0);
    let expected6 = 13450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected6 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 1);
    let expected7 = 23450;
    let actual = get_total_defences_shield_power(DEFENCES);
    assert expected7 = actual;

    return ();
}

@external
func test_defence_struct{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let DEFENCES = Defence(10, 0, 0, 0, 0, 0, 0, 0);
    let expected1 = 20000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected1 = actual;

    let DEFENCES = Defence(10, 10, 0, 0, 0, 0, 0, 0);
    let expected2 = 40000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected2 = actual;

    let DEFENCES = Defence(10, 10, 10, 0, 0, 0, 0, 0);
    let expected3 = 120000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected3 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 0, 0, 0, 0);
    let expected4 = 200000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected4 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 0, 0, 0);
    let expected5 = 550000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected5 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 0, 0);
    let expected6 = 1550000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected6 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 0);
    let expected6 = 1570000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected6 = actual;

    let DEFENCES = Defence(10, 10, 10, 10, 10, 10, 1, 1);
    let expected7 = 1670000;
    let actual = get_total_defences_structural_power(DEFENCES);
    assert expected7 = actual;

    return ();
}
