%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (
    assert_le,
    unsigned_div_rem,
    assert_not_zero,
    assert_not_equal,
)
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_block_timestamp
from facilities.library import SHIPYARD_ID
from main.INoGame import INoGame
from main.structs import Cost
from token.erc20.interfaces.IERC20 import IERC20
from utils.formulas import Formulas

#########################################################################################
#                                           CONSTANTS                                   #
#########################################################################################

const ROCKET_LAUNCHER_ID = 51
const LIGHT_LASER_ID = 52
const HEAVY_LASER_ID = 53
const ION_CANNON_ID = 54
const GAUSS_CANNON_ID = 55
const PLASMA_TURRET_ID = 56
const SMALL_DOME_ID = 57
const LARGE_DOME_ID = 58

#########################################################################################
#                                           STRUCTS                                     #
#########################################################################################

struct DefenceQue:
    member defence_id : felt
    member units : felt
    member lock_end : felt
end

struct DefenceCosts:
    member rocket : Cost
    member light_laser : Cost
    member heavy_laser : Cost
    member ion_cannon : Cost
    member gauss : Cost
    member plasma_turette : Cost
    member small_dome : Cost
    member large_dome : Cost
end

#########################################################################################
#                                           STORAGES                                    #
#########################################################################################

@storage_var
func Defence_no_game_address() -> (res : felt):
end

@storage_var
func Defence_timelock(address : felt) -> (res : DefenceQue):
end

@storage_var
func Defence_qued(address : felt, id : felt) -> (res : felt):
end

namespace Defence:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        no_game_address : felt
    ):
        Defence_no_game_address.write(no_game_address)
        return ()
    end

    # ##############################################################################################
    #                                       VIEW FUNCS                                             #
    ################################################################################################

    func que_status{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (status : DefenceQue):
        let (res) = Defence_timelock.read(caller)
        return (res)
    end

    func defences_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        costs : DefenceCosts
    ):
        return (
            DefenceCosts(rocket=Cost(2000, 0, 0),
            light_laser=Cost(1500, 500, 0),
            heavy_laser=Cost(6000, 2000, 0),
            ion_cannon=Cost(5000, 3000, 0),
            gauss=Cost(20000, 15000, 0),
            plasma_tourette=Cost(50000, 50000, 0),
            small_dome=Cost(10000, 10000, 0),
            large_dome=Cost(50000, 50000, 0)),
        )
    end

    # ##############################################################################################
    #                                       BUILD FUNCS                                            #
    ################################################################################################

    func rocket_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _rocket_cost(number_of_units)
        _check_que_not_busy(caller)
        _rocket_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, ROCKET_LAUNCHER_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func rocket_build_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_defence(caller, ROCKET_LAUNCHER_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, ROCKET_LAUNCHER_ID)
        return (units_produced)
    end

    func light_laser_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _light_laser_cost(
            number_of_units
        )
        _check_que_not_busy(caller)
        _light_laser_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, LIGHT_LASER_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func light_laser_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_defence(caller, LIGHT_LASER_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, LIGHT_LASER_ID)
        return (units_produced)
    end

    func heavy_laser_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _heavy_laser_cost(
            number_of_units
        )
        _check_que_not_busy(caller)
        _heavy_laser_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, HEAVY_LASER_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func heavy_laser_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_defence(caller, HEAVY_LASER_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, HEAVY_LASER_ID)
        return (units_produced)
    end

    func gauss_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _gauss_cost(number_of_units)
        _check_que_not_busy(caller)
        _gauss_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, GAUSS_CANNON_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func gauss_build_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_defence(caller, GAUSS_CANNON_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, GAUSS_CANNON_ID)
        return (units_produced)
    end

    func plasma_turret_build_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, number_of_units : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _plasma_turret_cost(
            number_of_units
        )
        _check_que_not_busy(caller)
        _plasma_turret_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, PLASMA_TURRET_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func plasma_turret_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_defence(caller, PLASMA_TURRET_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, PLASMA_TURRET_ID)
        return (units_produced)
    end

    func small_dome_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _small_dome_cost(
            number_of_units
        )
        _check_que_not_busy(caller)
        _small_dome_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, SMALL_DOME_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func small_dome_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_defence(caller, SMALL_DOME_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, SMALL_DOME_ID)
        return (units_produced)
    end

    func large_dome_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _large_dome_cost(
            number_of_units
        )
        _check_que_not_busy(caller)
        _large_dome_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, LARGE_DOME_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func large_dome_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_defence(caller, LARGE_DOME_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, LARGE_DOME_ID)
        return (units_produced)
    end
end

# ###################################################################################################
#                                DEFENCE REQUIREMENTS CHECKS                                          #
#####################################################################################################

func _rocket_requirements_check{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 1"):
        assert_le(1, shipyard_level)
    end
    return (TRUE)
end

func _light_laser_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 2"):
        assert_le(2, shipyard_level)
    end
    with_attr error_message("DEFENCES::ENERGY TECH BE AT LEVEL 2"):
        assert_le(2, tech_levels.energy_tech)
    end
    with_attr error_message("DEFENCES::LASER TECH BE AT LEVEL 3"):
        assert_le(3, tech_levels.laser_tech)
    end
    return (TRUE)
end

func _heavy_laser_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 4"):
        assert_le(4, shipyard_level)
    end
    with_attr error_message("DEFENCES::ENERGY TECH BE AT LEVEL 3"):
        assert_le(3, tech_levels.energy_tech)
    end
    with_attr error_message("DEFENCES::LASER TECH BE AT LEVEL 6"):
        assert_le(6, tech_levels.laser_tech)
    end
    return (TRUE)
end

func _ion_cannon_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 4"):
        assert_le(4, shipyard_level)
    end
    with_attr error_message("DEFENCES::ION TECH BE AT LEVEL 4"):
        assert_le(4, tech_levels.ion_tech)
    end
    return (TRUE)
end

func _gauss_requirements_check{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 6"):
        assert_le(6, shipyard_level)
    end
    with_attr error_message("DEFENCES::ENERGY TECH BE AT LEVEL 6"):
        assert_le(6, tech_levels.energy_tech)
    end
    with_attr error_message("DEFENCES::WEAPONS TECH BE AT LEVEL 3"):
        assert_le(3, tech_levels.weapons_tech)
    end
    with_attr error_message("DEFENCES::SHIELDING TECH BE AT LEVEL 1"):
        assert_le(1, tech_levels.shielding_tech)
    end
    return (TRUE)
end

func _plasma_turret_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 8"):
        assert_le(8, shipyard_level)
    end
    with_attr error_message("DEFENCES::PLASMA TECH BE AT LEVEL 7"):
        assert_le(7, tech_levels.plasma_tech)
    end
    return (TRUE)
end

func _small_dome_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 1"):
        assert_le(1, shipyard_level)
    end
    with_attr error_message("DEFENCES::SHIELDING TECH BE AT LEVEL 2"):
        assert_le(2, tech_levels.shielding_tech)
    end
    return (TRUE)
end

func _large_dome_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("DEFENCES::SHIPYARD MUST BE AT LEVEL 6"):
        assert_le(6, shipyard_level)
    end
    with_attr error_message("DEFENCES::SHIELDING TECH BE AT LEVEL 6"):
        assert_le(6, tech_levels.shielding_tech)
    end
    return (TRUE)
end

# ###################################################################################################
#                                DEFENCE COST CALCULATION FUNCTIONS                                 #
#####################################################################################################

func _rocket_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 2000
    let crystal_required = 0
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _light_laser_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 1500
    let crystal_required = 500
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _heavy_laser_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 6000
    let crystal_required = 2000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _ion_cannon_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 5000
    let crystal_required = 3000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _gauss_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 20000
    let crystal_required = 15000
    let deuterium_required = 2000
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _plasma_turret_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 50000
    let crystal_required = 50000
    let deuterium_required = 30000
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _small_dome_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 10000
    let crystal_required = 10000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _large_dome_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 50000
    let crystal_required = 50000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

#######################################################################################################
#                                           PRIVATE FUNC                                              #
#######################################################################################################

func _get_available_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, metal_address, crystal_address, deuterium_address) = INoGame.getTokensAddresses(no_game)
    let (metal_available) = IERC20.balanceOf(metal_address, caller)
    let (crystal_available) = IERC20.balanceOf(crystal_address, caller)
    let (deuterium_available) = IERC20.balanceOf(deuterium_address, caller)
    return (metal_available.low, crystal_available.low, deuterium_available.low)
end

func _check_enough_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, metal_required : felt, crystal_required : felt, deuterium_required : felt
):
    alloc_locals
    let (metal_available, crystal_available, deuterium_available) = _get_available_resources(caller)
    with_attr error_message("DEFENCES::NOT ENOUGH RESOURCES"):
        let (enough_metal) = is_le(metal_required, metal_available)
        assert enough_metal = TRUE
        let (enough_crystal) = is_le(crystal_required, crystal_available)
        assert enough_crystal = TRUE
        let (enough_deuterium) = is_le(deuterium_required, deuterium_available)
        assert enough_deuterium = TRUE
    end
    return ()
end

func _reset_timelock{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
):
    Defence_timelock.write(address, DefenceQue(0, 0, 0))
    return ()
end

func _reset_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt, id : felt
):
    Defence_qued.write(address, id, FALSE)
    return ()
end

func _check_que_not_busy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    let (que_status) = Defence_timelock.read(caller)
    let current_timelock = que_status.lock_end
    with_attr error_message("DEFENCES::QUE IS BUSY"):
        assert current_timelock = 0
    end

    let (game) = Defence_no_game_address.read()
    let (shipyard_available) = INoGame.getBuildingQueStatus(game, caller)
    with_attr error_message("DEFENCES::SHIPYARD IS UPGRADING"):
        assert_not_equal(shipyard_available.id, SHIPYARD_ID)
    end
    return ()
end

func _check_trying_to_complete_the_right_defence{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt, DEFENCE_ID : felt):
    let (is_qued) = Defence_qued.read(caller, DEFENCE_ID)
    with_attr error_message("DEFENCES::TRIED TO COMPLETE THE WRONG DEFENCE UNIT"):
        assert is_qued = TRUE
    end
    return ()
end

func _check_waited_enough{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (units_produced : felt):
    alloc_locals
    tempvar syscall_ptr = syscall_ptr
    let (time_now) = get_block_timestamp()
    let (que_details) = Defence_timelock.read(caller)
    let timelock_end = que_details.lock_end
    let (waited_enough) = is_le(timelock_end, time_now)
    with_attr error_message("DEFENCES::TIMELOCK NOT YET EXPIRED"):
        assert waited_enough = TRUE
    end
    let units_produced = que_details.units
    return (units_produced)
end

func _set_timelock_and_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt,
    DEFENCE_ID : felt,
    number_of_units : felt,
    metal_required : felt,
    crystal_required : felt,
) -> (time_end : felt):
    let (no_game) = Defence_no_game_address.read()
    let (_, shipyard_level, _, nanite_level) = INoGame.getFacilitiesLevels(no_game, caller)
    let (build_time) = Formulas.buildings_production_time(
        metal_required, crystal_required, shipyard_level, nanite_level
    )
    let (time_now) = get_block_timestamp()
    let time_end = time_now + build_time
    let que_details = DefenceQue(DEFENCE_ID, number_of_units, time_end)
    Defence_qued.write(caller, DEFENCE_ID, TRUE)
    Defence_timelock.write(caller, que_details)
    return (time_end)
end
