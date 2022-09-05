// https://github.com/marcellobardus/starknet-l2-storage-verifier/blob/master/contracts/starknet/lib/concat_arr.cairo

from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.alloc import alloc

func concat_arr{range_check_ptr}(arr1_len: felt, arr1: felt*, arr2_len: felt, arr2: felt*) -> (
    res: felt*, res_len: felt
) {
    alloc_locals;
    let (local res: felt*) = alloc();
    memcpy(res, arr1, arr1_len);
    memcpy(res + arr1_len, arr2, arr2_len);
    return (res, arr1_len + arr2_len);
}

from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem, uint256_eq
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.pow import pow

//
// Converts a felt it's equivalent short string. In the case where the felt length exceeds
// the maximum short string length (31 bytes), the remainder will be returned
// - eg. felt(10) -> '10', 0
// - eg. felt(123 "8*31") -> '8'*31, 123
//
func felt_to_ss_partial{range_check_ptr}(input: felt) -> (running_total: felt, remainder: felt) {
    let (running_total, remainder) = _felt_to_ss_partial(input, 0);
    return (running_total=running_total, remainder=remainder);
}

func _felt_to_ss_partial{range_check_ptr}(val: felt, depth: felt) -> (
    running_total: felt, remainder: felt
) {
    alloc_locals;

    // Used to shift the word by depth
    let (local word_exponent) = pow(2, 8 * depth);

    let (q, r) = unsigned_div_rem(val, 10);
    if (q == 0) {
        let res = word_exponent * (r + 48);
        return (running_total=res, remainder=q);
    }
    if (depth == 30) {
        let res = word_exponent * (r + 48);
        return (running_total=res, remainder=q);
    }

    let depth = depth + 1;
    let (running_total, remainder) = _felt_to_ss_partial(q, depth);
    let res = word_exponent * (r + 48) + running_total;
    return (running_total=res, remainder=remainder);
}

//
// Converts a felt to it's equivalent in a list of felts
// - eg. felt(123 "8"*31) -> 123, '8'*31
//
func felt_to_ss{range_check_ptr}(input: felt) -> (res_len: felt, res: felt*) {
    alloc_locals;

    let (local res) = alloc();

    if (input == 0) {
        assert res[0] = 48;
        return (res_len=1, res=res);
    }

    let (res_len) = _felt_to_ss(input, res);
    return (res_len=res_len, res=res);
}

func _felt_to_ss{range_check_ptr}(val: felt, res: felt*) -> (res_len: felt) {
    alloc_locals;
    if (val == 0) {
        return (res_len=0);
    }

    let (local running_total, remainder) = felt_to_ss_partial(val);
    let (res_len) = _felt_to_ss(remainder, res);
    assert res[res_len] = running_total;
    return (res_len=res_len + 1);
}

//
// Converts a uint it's equivalent short string. In the case where the felt length exceeds
// the maximum short string length (31 bytes), the remainder will be returned
// - eg. felt(10) -> '10', 0
// - eg. felt(123 "8*31") -> '8'*31, 123
//
func uint256_to_ss_partial{range_check_ptr}(input: Uint256) -> (
    running_total: felt, remainder: Uint256
) {
    let (running_total, remainder) = _uint256_to_ss_partial(input, 0);
    return (running_total=running_total, remainder=remainder);
}

func _uint256_to_ss_partial{range_check_ptr}(val: Uint256, depth: felt) -> (
    running_total: felt, remainder: Uint256
) {
    alloc_locals;

    // Used to shift the word by depth
    let (local word_exponent) = pow(2, 8 * depth);

    let (q, r) = uint256_unsigned_div_rem(val, Uint256(10, 0));
    let (quotient_eq) = uint256_eq(q, Uint256(0, 0));
    if (quotient_eq == 1) {
        let res = word_exponent * (r.low + 48);
        return (running_total=res, remainder=q);
    }
    if (depth == 30) {
        let res = word_exponent * (r.low + 48);
        return (running_total=res, remainder=q);
    }

    let depth = depth + 1;
    let (running_total, remainder) = _uint256_to_ss_partial(q, depth);
    let res = word_exponent * (r.low + 48) + running_total;
    return (running_total=res, remainder=remainder);
}

//
// Converts a uint256 to it's equivalent in a list of felts
//
func uint256_to_ss{range_check_ptr}(input: Uint256) -> (res_len: felt, res: felt*) {
    alloc_locals;

    let (local res) = alloc();

    let (input_eq) = uint256_eq(input, Uint256(0, 0));
    if (input_eq == 1) {
        assert res[0] = 48;
        return (res_len=1, res=res);
    }

    let (res_len) = _uint256_to_ss(input, res);
    return (res_len=res_len, res=res);
}

func _uint256_to_ss{range_check_ptr}(val: Uint256, res: felt*) -> (res_len: felt) {
    alloc_locals;

    let (val_eq) = uint256_eq(val, Uint256(0, 0));
    if (val_eq == 1) {
        return (res_len=0);
    }

    let (local running_total, remainder) = uint256_to_ss_partial(val);
    let (res_len) = _uint256_to_ss(remainder, res);
    assert res[res_len] = running_total;
    return (res_len=res_len + 1);
}
