%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.pow import pow
from starkware.starknet.common.syscalls import get_block_timestamp
from main.INoGame import INoGame
from main.structs import Cost
from token.erc20.interfaces.IERC20 import IERC20
from utils.formulas import Formulas

#########################################################################################
#                                           CONSTANTS                                   #
#########################################################################################

const E18 = 10 ** 18

const METAL_MINE_ID = 41
const CRYSTAL_MINE_ID = 42
const DEUTERIUM_MINE_ID = 43
const SOLAR_PLANT_ID = 44

#########################################################################################
#                                           STRUCTS                                     #
#########################################################################################

struct ResourcesQue:
    member building_id : felt
    member lock_end : felt
end

#########################################################################################
#                                           STORAGES                                    #
#########################################################################################

@storage_var
func Resources_no_game_address() -> (address : felt):
end

@storage_var
func Resources_timelock(address : felt) -> (cued_details : ResourcesQue):
end

# @dev Stores the que status for a specific ship.
@storage_var
func Resources_qued(address : felt, id : felt) -> (is_qued : felt):
end

namespace Resources:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        no_game_address : felt
    ):
        Resources_no_game_address.write(no_game_address)
        return ()
    end

    func upgrades_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (metal_mine : Cost, crystal_mine : Cost, deuterium_mine : Cost, solar_plant : Cost):
        alloc_locals
        let (no_game) = Resources_no_game_address.read()
        let (
            metal_mine, crystal_mine, deuterium_mine, solar_plant
        ) = INoGame.getResourcesBuildingsLevels(no_game, caller)
        let (m_m, m_c) = _metal_building_cost(metal_mine)
        let (c_m, c_c) = _crystal_building_cost(crystal_mine)
        let (d_m, d_c) = _deuterium_building_cost(deuterium_mine)
        let (s_m, s_c) = _solar_plant_building_cost(solar_plant)
        return (
            metal_mine=Cost(m_m, m_c, 0),
            crystal_mine=Cost(c_m, c_c, 0),
            deuterium_mine=Cost(d_m, d_c, 0),
            solar_plant=Cost(s_m, s_c, 0),
        )
    end

    func metal_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (metal : felt, crystal : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        let (no_game) = Resources_no_game_address.read()
        let (metal_level, _, _, _) = INoGame.getResourcesBuildingsLevels(no_game, caller)
        let (robot_level, _, _, nanite_level) = INoGame.getFacilitiesLevels(no_game, caller)
        let (metal_required, crystal_required) = _metal_building_cost(metal_level)
        _check_enough_resources(caller, metal_required, crystal_required, 0)
        let (time_unlocked) = _set_timelock_and_que(
            caller, METAL_MINE_ID, robot_level, nanite_level, metal_required, crystal_required
        )
        return (metal_required, crystal_required, time_unlocked)
    end

    func metal_upgrade_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ):
        alloc_locals
        _check_trying_to_complete_the_right_resource(caller, METAL_MINE_ID)
        _check_waited_enough(caller)
        _reset_que(caller, METAL_MINE_ID)
        _reset_timelock(caller)
        return ()
    end

    func crystal_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (metal : felt, crystal : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        let (no_game) = Resources_no_game_address.read()
        let (_, crystal_level, _, _) = INoGame.getResourcesBuildingsLevels(no_game, caller)
        let (robot_level, _, _, nanite_level) = INoGame.getFacilitiesLevels(no_game, caller)
        let (metal_required, crystal_required) = _crystal_building_cost(crystal_level)
        _check_enough_resources(caller, metal_required, crystal_required, 0)
        let (time_unlocked) = _set_timelock_and_que(
            caller, CRYSTAL_MINE_ID, robot_level, nanite_level, metal_required, crystal_required
        )
        return (metal_required, crystal_required, time_unlocked)
    end

    func crystal_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt):
        alloc_locals
        _check_trying_to_complete_the_right_resource(caller, CRYSTAL_MINE_ID)
        _check_waited_enough(caller)
        _reset_que(caller, CRYSTAL_MINE_ID)
        _reset_timelock(caller)
        return ()
    end

    func deuterium_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (metal : felt, crystal : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        let (no_game) = Resources_no_game_address.read()
        let (_, _, deuterium_level, _) = INoGame.getResourcesBuildingsLevels(no_game, caller)
        let (robot_level, _, _, nanite_level) = INoGame.getFacilitiesLevels(no_game, caller)
        let (metal_required, crystal_required) = _deuterium_building_cost(deuterium_level)
        _check_enough_resources(caller, metal_required, crystal_required, 0)
        let (time_unlocked) = _set_timelock_and_que(
            caller, DEUTERIUM_MINE_ID, robot_level, nanite_level, metal_required, crystal_required
        )
        return (metal_required, crystal_required, time_unlocked)
    end

    func deuterium_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt):
        alloc_locals
        _check_trying_to_complete_the_right_resource(caller, DEUTERIUM_MINE_ID)
        _check_waited_enough(caller)
        _reset_que(caller, DEUTERIUM_MINE_ID)
        _reset_timelock(caller)
        return ()
    end

    func solar_plant_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (metal : felt, crystal : felt, time_unlocked : felt):
        alloc_locals
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        let (no_game) = Resources_no_game_address.read()
        let (_, _, _, solar_level) = INoGame.getResourcesBuildingsLevels(no_game, caller)
        let (robot_level, _, _, nanite_level) = INoGame.getFacilitiesLevels(no_game, caller)
        let (metal_required, crystal_required) = _solar_plant_building_cost(solar_level)
        _check_enough_resources(caller, metal_required, crystal_required, 0)
        let (time_unlocked) = _set_timelock_and_que(
            caller, SOLAR_PLANT_ID, robot_level, nanite_level, metal_required, crystal_required
        )
        return (metal_required, crystal_required, time_unlocked)
    end

    func solar_plant_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt):
        alloc_locals
        _check_trying_to_complete_the_right_resource(caller, SOLAR_PLANT_ID)
        _check_waited_enough(caller)
        _reset_que(caller, SOLAR_PLANT_ID)
        _reset_timelock(caller)
        return ()
    end
end

func _timelock_status{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (building_id : felt, time_end : felt):
    let (status) = Resources_timelock.read(caller)
    let building_id = status.building_id
    let time_end = status.lock_end

    return (building_id, time_end)
end

# ###################################################################################################
#                                RESOURCES COST CALCULATION                                         #
#####################################################################################################

func _metal_building_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    metal_mine_level : felt
) -> (metal_cost : felt, crystal_cost : felt):
    alloc_locals
    let base_metal = 60
    let base_crystal = 15
    let exponent = metal_mine_level
    if exponent == 0:
        return (metal_cost=base_metal, crystal_cost=base_crystal)
    else:
        let (second_fact) = pow(15, exponent)
        local metal_cost = base_metal * second_fact
        local crystal_cost = base_crystal * second_fact
        let (local exp2) = pow(10, metal_mine_level)
        let (metal_scaled, _) = unsigned_div_rem(metal_cost, exp2)
        let (crystal_scaled, _) = unsigned_div_rem(crystal_cost, exp2)
        return (metal_cost=metal_scaled, crystal_cost=crystal_scaled)
    end
end

func _crystal_building_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    crystal_mine_level : felt
) -> (metal_cost : felt, crystal_cost : felt):
    alloc_locals
    let base_metal = 48
    let base_crystal = 24
    let exponent = crystal_mine_level
    if exponent == 0:
        return (metal_cost=base_metal, crystal_cost=base_crystal)
    else:
        let (second_fact) = pow(16, exponent)
        local metal_cost = base_metal * second_fact
        local crystal_cost = base_crystal * second_fact
        let (local exp2) = pow(10, crystal_mine_level)
        let (metal_scaled, _) = unsigned_div_rem(metal_cost, exp2)
        let (crystal_scaled, _) = unsigned_div_rem(crystal_cost, exp2)
        return (metal_cost=metal_scaled, crystal_cost=crystal_scaled)
    end
end

func _deuterium_building_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    deuterium_mine_level : felt
) -> (metal_cost : felt, crystal_cost : felt):
    alloc_locals
    let base_metal = 225
    let base_crystal = 75
    let exponent = deuterium_mine_level
    if exponent == 0:
        return (metal_cost=base_metal, crystal_cost=base_crystal)
    else:
        let (second_fact) = pow(15, exponent)
        local metal_cost = base_metal * second_fact
        local crystal_cost = base_crystal * second_fact
        let (local exp2) = pow(10, deuterium_mine_level)
        let (metal_scaled, _) = unsigned_div_rem(metal_cost, exp2)
        let (crystal_scaled, _) = unsigned_div_rem(crystal_cost, exp2)
        return (metal_cost=metal_scaled, crystal_cost=crystal_scaled)
    end
end

func _solar_plant_building_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    solar_plant_level : felt
) -> (metal_cost : felt, crystal_cost : felt):
    alloc_locals
    let base_metal = 75
    let base_crystal = 30
    let exponent = solar_plant_level
    if exponent == 1:
        return (metal_cost=base_metal, crystal_cost=base_crystal)
    else:
        let (fact0) = pow(15, exponent)
        local factM = base_metal * fact0
        local factC = base_crystal * fact0
        let (fact1) = pow(10, exponent)
        let (metal_scaled, _) = unsigned_div_rem(factM, fact1)
        let (crystal_scaled, _) = unsigned_div_rem(factC, fact1)
        return (metal_cost=metal_scaled, crystal_cost=crystal_scaled)
    end
end

##############################################################################################
#                                   PRIVATE FUNCTIONS                                        #
# ############################################################################################

func _get_available_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (ogame_address) = Resources_no_game_address.read()
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
    with_attr error_message("RESOURCES::NOT ENOUGH RESOURCES!!!"):
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
    Resources_timelock.write(address, ResourcesQue(0, 0))
    return ()
end

func _reset_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt, building_id : felt
):
    Resources_qued.write(address, building_id, FALSE)
    return ()
end

func _check_que_not_busy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    let (que_status) = Resources_timelock.read(caller)
    let current_timelock = que_status.lock_end
    with_attr error_message("RESOURCES::QUE IS BUSY!!!"):
        assert current_timelock = 0
    end
    return ()
end

func _check_trying_to_complete_the_right_resource{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt, BUILDING_ID : felt):
    let (is_qued) = Resources_qued.read(caller, BUILDING_ID)
    with_attr error_message("RESOURCES::TRIED TO COMPLETE THE WRONG RESOURCE!!!"):
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
    let (que_details) = Resources_timelock.read(caller)
    let timelock_end = que_details.lock_end
    let (waited_enough) = is_le(timelock_end, time_now)
    with_attr error_message("RESOURCES::TIMELOCK NOT YET EXPIRED!!!"):
        assert waited_enough = TRUE
    end
    return ()
end

func _set_timelock_and_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt,
    BUILDING_ID : felt,
    robot_level : felt,
    nanite_level : felt,
    metal_required : felt,
    crystal_required : felt,
) -> (time_unlocked : felt):
    let (build_time) = Formulas.buildings_production_time(
        metal_required, crystal_required, robot_level, nanite_level
    )
    let (time_now) = get_block_timestamp()
    let time_end = time_now + build_time
    let que_details = ResourcesQue(BUILDING_ID, time_end)
    Resources_qued.write(caller, BUILDING_ID, TRUE)
    Resources_timelock.write(caller, que_details)
    return (time_end)
end
