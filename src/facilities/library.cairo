%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.bool import TRUE, FALSE
from main.INoGame import INoGame
from main.structs import Cost
from token.erc20.interfaces.IERC20 import IERC20
from utils.formulas import Formulas

##############################################################################################
#                                   STRUCTS                                                  #
# ############################################################################################

struct FacilitiesQue:
    member facility_id : felt
    member lock_end : felt
end

##############################################################################################
#                                   STORAGE                                                  #
# ############################################################################################

@storage_var
func Facilities_no_game_address() -> (address : felt):
end

@storage_var
func Facilities_timelock(address : felt) -> (cued_details : FacilitiesQue):
end

# @dev Stores the que status for a specific ship.
@storage_var
func Facilities_que(address : felt, id : felt) -> (is_qued : felt):
end

##############################################################################################
#                                   CONSTANTS                                                #
# ############################################################################################

const ROBOT_FACTORY_ID = 21
const SHIPYARD_ID = 22
const RESEARCH_LAB_ID = 23
const NANITE_FACTORY_ID = 24

namespace Facilities:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        no_game_address : felt
    ):
        Facilities_no_game_address.write(no_game_address)
        return ()
    end

    func upgrades_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (robot_factory : Cost, shipyard : Cost, research_lab : Cost, nanite : Cost):
        alloc_locals
        let (no_game) = Facilities_no_game_address.read()
        let (
            robot_factory_level, local shipyard_level, research_lab_level, nanite_level
        ) = INoGame.getFacilitiesLevels(no_game, caller)
        let (r_m, r_c, r_d) = _robot_factory_upgrade_cost(robot_factory_level)
        let (s_m, s_c, s_d) = _shipyard_upgrade_cost(shipyard_level)
        let (l_m, l_c, l_d) = _research_lab_upgrade_cost(research_lab_level)
        let (n_m, n_c, n_d) = _nanite_factory_upgrade_cost(nanite_level)
        return (
            robot_factory=Cost(r_m, r_c, r_d, 0),
            shipyard=Cost(s_m, s_c, s_d, 0),
            research_lab=Cost(l_m, l_c, l_d, 0),
            nanite=Cost(n_m, n_c, n_d, 0),
        )
    end

    func timelock_status{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (cued_details : FacilitiesQue):
        let (res) = Facilities_timelock.read(caller)
        return (res)
    end

    func robot_factory_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        let (ogame_address) = Facilities_no_game_address.read()
        let (robot_factory_level, _, _, nanite_level) = INoGame.getFacilitiesLevels(
            ogame_address, caller
        )
        let (metal_required, crystal_required, deuterium_required) = _robot_factory_upgrade_cost(
            robot_factory_level
        )
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_unlocked) = _set_timelock_and_que(
            caller,
            ROBOT_FACTORY_ID,
            robot_factory_level,
            nanite_level,
            metal_required,
            crystal_required,
        )
        return (metal_required, crystal_required, deuterium_required, time_unlocked)
    end

    func robot_factory_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_to_complete_the_right_facility(caller, ROBOT_FACTORY_ID)
        _check_waited_enough(caller)
        _reset_que(caller, ROBOT_FACTORY_ID)
        _reset_timelock(caller)
        return (TRUE)
    end

    func shipyard_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _shipyard_requirements_check(caller)
        let (no_game) = Facilities_no_game_address.read()
        let (robot_factory_level, shipyard_level, _, nanite_level) = INoGame.getFacilitiesLevels(
            no_game, caller
        )
        let (metal_required, crystal_required, deuterium_required) = _shipyard_upgrade_cost(
            shipyard_level
        )
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_unlocked) = _set_timelock_and_que(
            caller, SHIPYARD_ID, robot_factory_level, nanite_level, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_unlocked)
    end

    func shipyard_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_to_complete_the_right_facility(caller, SHIPYARD_ID)
        _check_waited_enough(caller)
        _reset_que(caller, SHIPYARD_ID)
        _reset_timelock(caller)
        return (TRUE)
    end

    func research_lab_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        let (no_game) = Facilities_no_game_address.read()
        let (
            robot_factory_level, _, research_lab_level, nanite_level
        ) = INoGame.getFacilitiesLevels(no_game, caller)
        let (metal_required, crystal_required, deuterium_required) = _research_lab_upgrade_cost(
            research_lab_level
        )
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_unlocked) = _set_timelock_and_que(
            caller,
            RESEARCH_LAB_ID,
            robot_factory_level,
            nanite_level,
            metal_required,
            crystal_required,
        )
        return (metal_required, crystal_required, deuterium_required, time_unlocked)
    end

    func research_lab_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_to_complete_the_right_facility(caller, RESEARCH_LAB_ID)
        _check_waited_enough(caller)
        _reset_que(caller, RESEARCH_LAB_ID)
        _reset_timelock(caller)
        return (TRUE)
    end

    func nanite_factory_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _nanite_factory_requirements_check(caller)
        let (ogame_address) = Facilities_no_game_address.read()
        let (robot_factory_level, _, _, nanite_level) = INoGame.getFacilitiesLevels(
            ogame_address, caller
        )
        let (metal_required, crystal_required, deuterium_required) = _nanite_factory_upgrade_cost(
            nanite_level
        )
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_unlocked) = _set_timelock_and_que(
            caller,
            NANITE_FACTORY_ID,
            robot_factory_level,
            nanite_level,
            metal_required,
            crystal_required,
        )
        return (metal_required, crystal_required, deuterium_required, time_unlocked)
    end

    func nanite_factory_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_to_complete_the_right_facility(caller, NANITE_FACTORY_ID)
        _check_waited_enough(caller)
        _reset_que(caller, NANITE_FACTORY_ID)
        _reset_timelock(caller)
        return (TRUE)
    end
end

# ###################################################################################################
#                                FACILITIES REQUIREMENTS CHECHS                                     #
#####################################################################################################

func _shipyard_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (ogame_address) = Facilities_no_game_address.read()
    let (robot_factory_level, _, _, _) = INoGame.getFacilitiesLevels(ogame_address, caller)
    with_attr error_message("FACILITIES::ROBOT FACTORY MUST BE AT LEVEL 2"):
        assert_le(2, robot_factory_level)
    end
    return (TRUE)
end

func _nanite_factory_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Facilities_no_game_address.read()
    let (robot_factory_level, _, _, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("FACILITIES::ROBOT FACTORY MUST BE AT LEVEL 10"):
        assert_le(10, robot_factory_level)
    end
    with_attr error_message("FACILITIES::COMPUTER TECH MUST BE AT LEVEL 10"):
        assert_le(10, tech_levels.computer_tech)
    end
    return (TRUE)
end

# ###################################################################################################
#                                FACILITIES COST CALCULATION                                        #
#####################################################################################################

func _robot_factory_upgrade_cost{syscall_ptr : felt*, range_check_ptr}(current_level : felt) -> (
    metal : felt, crystal : felt, deuterium : felt
):
    let base_metal = 400
    let base_crystal = 120
    let base_deuterium = 200
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _shipyard_upgrade_cost{syscall_ptr : felt*, range_check_ptr}(current_level : felt) -> (
    metal : felt, crystal : felt, deuterium : felt
):
    let base_metal = 400
    let base_crystal = 200
    let base_deuterium = 100
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _research_lab_upgrade_cost{syscall_ptr : felt*, range_check_ptr}(current_level : felt) -> (
    metal : felt, crystal : felt, deuterium : felt
):
    let base_metal = 200
    let base_crystal = 400
    let base_deuterium = 200
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _nanite_factory_upgrade_cost{syscall_ptr : felt*, range_check_ptr}(current_level : felt) -> (
    metal : felt, crystal : felt, deuterium : felt
):
    let base_metal = 1000000
    let base_crystal = 500000
    let base_deuterium = 100000
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

##############################################################################################
#                                   PRIVATE FUNCTIONS                                        #
# ############################################################################################

func _get_available_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (ogame_address) = Facilities_no_game_address.read()
    let (_, metal_address, crystal_address, deuterium_address) = INoGame.getTokensAddresses(
        ogame_address
    )
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
    with_attr error_message("FACILITIES::NOT ENOUGH RESOURCES!!!"):
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
    Facilities_timelock.write(address, FacilitiesQue(0, 0))
    return ()
end

func _reset_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt, building_id : felt
):
    Facilities_que.write(address, building_id, FALSE)
    return ()
end

func _check_que_not_busy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    let (game) = Facilities_no_game_address.read()
    let (que_status) = INoGame.getBuildingQueStatus(game, caller)
    let current_timelock = que_status.lock_end
    with_attr error_message("FACILITIES::QUE IS BUSY!!!"):
        assert current_timelock = 0
    end
    return ()
end

func _check_trying_to_complete_the_right_facility{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt, BUILDING_ID : felt):
    let (is_qued) = Facilities_que.read(caller, BUILDING_ID)
    with_attr error_message("FACILITIES::TRIED TO COMPLETE THE WRONG FACILITY!!!"):
        assert is_qued = TRUE
    end
    return ()
end

func _check_waited_enough{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    alloc_locals
    tempvar syscall_ptr = syscall_ptr
    let (time_now) = get_block_timestamp()
    let (que_details) = Facilities_timelock.read(caller)
    let timelock_end = que_details.lock_end
    let (waited_enough) = is_le(timelock_end, time_now)
    with_attr error_message("FACILITIES::TIMELOCK NOT YET EXPIRED!!!"):
        assert waited_enough = TRUE
    end
    return ()
end

func _set_timelock_and_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt,
    BUILDING_ID : felt,
    robot_factory_level : felt,
    nanite_level : felt,
    metal_required : felt,
    crystal_required : felt,
) -> (time_unlocked : felt):
    let (build_time) = Formulas.buildings_production_time(
        metal_required, crystal_required, robot_factory_level, nanite_level
    )
    let (time_now) = get_block_timestamp()
    let time_end = time_now + build_time
    let que_details = FacilitiesQue(BUILDING_ID, time_end)
    Facilities_que.write(caller, BUILDING_ID, TRUE)
    Facilities_timelock.write(caller, que_details)
    return (time_end)
end
