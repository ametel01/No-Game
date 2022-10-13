%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp
from starkware.cairo.common.math import unsigned_div_rem, assert_not_zero, assert_lt
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.pow import pow
from starkware.cairo.common.bool import TRUE, FALSE

//#############
// Production #
//#############

const E18 = 10 ** 18;

namespace Formulas {
    // Prod per second = 30 * Level * 11**Level / 10**Level * 10000 / 3600 * 10000
    func metal_mine_production{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time_elapsed: felt, mine_level: felt
    ) -> (metal_produced: felt) {
        alloc_locals;
        let (metal_hour) = _resources_production_formula(30, mine_level);
        let (prod_second, _) = unsigned_div_rem(metal_hour * 10000, 3600);  // 91
        let fact8 = prod_second * time_elapsed;
        // @dev current production rate is set to 5X. To set to 1X set the diviso to 10000
        let (prod_scaled, _) = unsigned_div_rem(fact8, 2000);  // 32
        return (metal_produced=prod_scaled);
    }

    func crystal_mine_production{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time_elapsed: felt, mine_level: felt
    ) -> (crystal_produced: felt) {
        alloc_locals;
        let (crystal_hour) = _resources_production_formula(20, mine_level);
        let (fact7, _) = unsigned_div_rem(crystal_hour * 10000, 3600);
        let fact8 = fact7 * time_elapsed;
        // @dev current production rate is set to 5X. To set to 1X set the diviso to 10000
        let (prod_scaled, _) = unsigned_div_rem(fact8, 2000);
        return (crystal_produced=prod_scaled);
    }

    func deuterium_mine_production{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time_elapsed: felt, mine_level: felt
    ) -> (deuterium_produced: felt) {
        alloc_locals;
        let (deuterium_hour) = _resources_production_formula(10, mine_level);
        let (fact7, _) = unsigned_div_rem(deuterium_hour * 10000, 3600);
        let fact8 = fact7 * time_elapsed;
        // @dev current production rate is set to 5X. To set to 1X set the diviso to 10000
        let (prod_scaled, _) = unsigned_div_rem(fact8, 2000);
        return (deuterium_produced=prod_scaled);
    }

    //#########
    // Energy #
    //#########
    func solar_plant_production{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        plant_level: felt
    ) -> (production: felt) {
        let (production) = solar_production(plant_level);
        return (production=production);
    }

    func energy_production_scaler{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        net_metal: felt,
        net_crystal: felt,
        net_deuterium: felt,
        energy_required: felt,
        energy_available: felt,
    ) -> (actual_metal: felt, actual_crystal: felt, actual_deuterium: felt) {
        alloc_locals;
        let (enough_energy, _) = unsigned_div_rem(energy_available, energy_required);
        if (enough_energy == FALSE) {
            let (local metal) = _production_limiter(
                production=net_metal,
                energy_required=energy_required,
                energy_available=energy_available,
            );
            let (local crystal) = _production_limiter(
                production=net_crystal,
                energy_required=energy_required,
                energy_available=energy_available,
            );
            let (local deuterium) = _production_limiter(
                production=net_deuterium,
                energy_required=energy_required,
                energy_available=energy_available,
            );
            return (actual_metal=metal, actual_crystal=crystal, actual_deuterium=deuterium);
        } else {
            return (net_metal, net_crystal, net_deuterium);
        }
    }

    func consumption_energy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        mine_level: felt
    ) -> (consumption: felt) {
        alloc_locals;
        let fact1 = 10 * mine_level;
        let (fact2) = pow(11, mine_level);
        local fact3 = fact1 * fact2;
        let (fact4) = pow(10, mine_level);
        let level_in_bound = is_le_felt(mine_level, 25);
        if (level_in_bound == TRUE) {
            let (res, _) = unsigned_div_rem(fact3, fact4);
            return (res,);
        } else {
            let (fact5, _) = unsigned_div_rem(fact3, E18);
            let (fact6, _) = unsigned_div_rem(fact4, E18);
            let (res, _) = unsigned_div_rem(fact5, fact6);
            return (res,);
        }
    }

    func consumption_energy_deuterium{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(mine_level: felt) -> (consumption: felt) {
        alloc_locals;
        let level_in_bound = is_le_felt(mine_level, 25);
        if (level_in_bound == TRUE) {
            let fact1 = 20 * mine_level;
            let (fact2) = pow(11, mine_level);
            local fact3 = fact1 * fact2;
            let (fact4) = pow(10, mine_level);
            let (res, _) = unsigned_div_rem(fact3, fact4);
            return (res,);
        } else {
            let fact1 = 20 * mine_level;
            let (fact2) = pow(11, mine_level);
            let (f2_b, _) = unsigned_div_rem(fact2, E18);
            local fact3 = fact1 * f2_b;
            let (fact4) = pow(10, mine_level);
            let (f4_b, _) = unsigned_div_rem(fact4, E18);
            let (res, _) = unsigned_div_rem(fact3, f4_b);
            return (res,);
        }
    }

    func _production_limiter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        production: felt, energy_required: felt, energy_available: felt
    ) -> (production: felt) {
        let fact0 = energy_available * 100;
        let (fact1, _) = unsigned_div_rem(fact0, energy_required);
        let fact2 = fact1 * production;
        let (res, _) = unsigned_div_rem(fact2, 100);
        return (production=res);
    }

    // 30 * M * 1.1 ** M
    func _resources_production_formula{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(mine_factor: felt, mine_level: felt) -> (production_hour: felt) {
        alloc_locals;
        local max_level = is_le_felt(25, mine_level);
        let fact1 = mine_factor * mine_level;
        let (fact2) = pow(11, mine_level);
        local fact3 = fact1 * fact2;
        if (max_level == TRUE) {
            let (local fact3a, _) = unsigned_div_rem(fact3, E18);
            let (fact4) = pow(10, mine_level);
            let (fact4a, _) = unsigned_div_rem(fact4, E18);
            let (fact5, _) = unsigned_div_rem(fact3a, fact4a);
            return (production_hour=fact5);
        } else {
            let (fact4) = pow(10, mine_level);
            let (fact5, _) = unsigned_div_rem(fact3, fact4);
            return (production_hour=fact5);
        }
    }

    func solar_production{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        plant_level: felt
    ) -> (production_hour: felt) {
        alloc_locals;
        with_attr error_message("Solar Plant max level is 54") {
            assert_lt(plant_level, 55);
        }
        let fact1 = 20 * plant_level;
        let level_in_bound = is_le_felt(plant_level, 25);
        if (level_in_bound == TRUE) {
            let (local fact2) = pow(11, plant_level);
            local fact3 = fact1 * fact2;
            let (fact4) = pow(10, plant_level);
            let level_in_bound = is_le_felt(plant_level, 25);
            let (res, _) = unsigned_div_rem(fact3, fact4);
            return (res,);
        } else {
            let (local fact2) = pow(11, plant_level);
            let (f2_b, _) = unsigned_div_rem(fact2, E18);
            local fact3 = fact1 * f2_b;
            let (fact4) = pow(10, plant_level);
            let (f4_b, _) = unsigned_div_rem(fact4, E18);
            let (res, _) = unsigned_div_rem(fact3, f4_b);
            return (res,);
        }
    }

    func buildings_production_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        metal_cost: felt, crystal_cost: felt, robot_level: felt, nanite_level
    ) -> (time_required: felt) {
        if (nanite_level == 0) {
            let fact1 = metal_cost + crystal_cost;
            let fact2 = fact1 * 1000;
            let fact3 = robot_level + 1;
            let fact4 = 2500 * fact3;
            let (fact5, _) = unsigned_div_rem(fact2, fact4);
            let fact6 = fact5 * 3600;
            let (res, _) = unsigned_div_rem(fact6, 1000);
        } else {
            let fact1 = metal_cost + crystal_cost;
            let fact2 = fact1 * 1000;
            let fact3 = robot_level + 1;
            let fact4a = 2500 * fact3;
            let (fact4b) = pow(2, nanite_level);
            let fact4 = fact4a * fact4b;
            let (fact5, _) = unsigned_div_rem(fact2, fact4);
            let fact6 = fact5 * 3600;
            let (res, _) = unsigned_div_rem(fact6, 1000);
        }
        return (time_required=res);
    }
}
