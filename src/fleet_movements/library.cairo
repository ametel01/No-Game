%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import FALSE
from starkware.cairo.common.math import abs_value, assert_not_zero, sqrt, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.uint256 import Uint256
from shipyard.ships_performance import Fleet

const SCALER = 10 ** 9;

func send_spy_mission{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    number_of_probes: felt, planet_id: Uint256
) {
}

func _calculate_distance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    p1_position: felt, p2_position: felt
) -> felt {
    let zero_check_1 = is_not_zero(p1_position);
    let zero_check_2 = is_not_zero(p2_position);
    if (zero_check_1 * zero_check_2 == FALSE) {
        return 0;
    }

    let fact1 = abs_value(p2_position - p1_position);
    let distance = 1000 + 5 * fact1;
    return distance;
}

func _calculate_travel_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    distance: felt, speed: felt
) -> felt {
    let (fact1, _) = unsigned_div_rem(SCALER * distance, speed);
    let fact2 = sqrt(fact1);
    let (res, _) = unsigned_div_rem(fact2, 2);
    return res;
}
