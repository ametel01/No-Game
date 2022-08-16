%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero, assert_not_equal
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.pow import pow
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_block_timestamp
from facilities.library import RESEARCH_LAB_ID
from main.INoGame import INoGame
from token.erc20.interfaces.IERC20 import IERC20
from main.structs import TechLevels, Cost, TechCosts
from utils.formulas import Formulas

########################################################################################
#                                           STRUCTS                                     #
#########################################################################################

struct ResearchQue:
    member tech_id : felt
    member lock_end : felt
end

#########################################################################################
#                                           STORAGES                                    #
#########################################################################################

@storage_var
func Research_no_game_address() -> (address : felt):
end

# @dev Stores the timestamp of the end of the timelock for buildings upgrades.
# @params The address of the player.
@storage_var
func Research_timelock(address : felt) -> (cued_details : ResearchQue):
end

# @dev Stores the que status for a specific tech.
@storage_var
func Research_qued(address : felt, id : felt) -> (is_qued : felt):
end

#########################################################################################
#                                           CONSTANTS                                   #
#########################################################################################
const ARMOUR_TECH_ID = 11
const ASTROPHYSICS_TECH_ID = 12
const COMBUSTION_DRIVE_ID = 13
const COMPUTER_TECH_ID = 14
const ENERGY_TECH_ID = 15
const ESPIONAGE_TECH_ID = 16
const HYPERSPACE_DRIVE_ID = 17
const HYPERSPACE_TECH_ID = 18
const IMPULSE_DRIVE_ID = 19
const ION_TECH_ID = 20
const LASER_TECH_ID = 21
const PLASMA_TECH_ID = 22
const SHIELDING_TECH_ID = 23
const WEAPONS_TECH_ID = 24

namespace ResearchLab:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        no_game_address : felt
    ):
        Research_no_game_address.write(no_game_address)
        return ()
    end

    func que_status{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (status : ResearchQue):
        let (res) = Research_timelock.read(caller)
        return (res)
    end

    func upgrades_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (costs : TechCosts):
        alloc_locals
        let (no_game) = Research_no_game_address.read()
        let (tech_levels) = INoGame.getTechLevels(no_game, caller)
        let (m1, c1, d1) = _energy_tech_upgrade_cost(tech_levels.energy_tech)
        let (m2, c2, d2) = _computer_tech_upgrade_cost(tech_levels.computer_tech)
        let (m3, c3, d3) = _laser_tech_upgrade_cost(tech_levels.laser_tech)
        let (m4, c4, d4) = _armour_tech_upgrade_cost(tech_levels.armour_tech)
        let (m5, c5, d5) = _espionage_tech_upgrade_cost(tech_levels.espionage_tech)
        let (m6, c6, d6) = _ion_tech_upgrade_cost(tech_levels.ion_tech)
        let (m7, c7, d7) = _plasma_tech_upgrade_cost(tech_levels.plasma_tech)
        let (m8, c8, d8) = _weapons_tech_upgrade_cost(tech_levels.weapons_tech)
        let (m9, c9, d9) = _shielding_tech_upgrade_cost(tech_levels.shielding_tech)
        let (m10, c10, d10) = _hyperspace_tech_upgrade_cost(tech_levels.hyperspace_tech)
        let (m11, c11, d11) = _astrophysics_upgrade_cost(tech_levels.astrophysics)
        let (m12, c12, d12) = _combustion_drive_upgrade_cost(tech_levels.combustion_drive)
        let (m13, c13, d13) = _hyperspace_drive_upgrade_cost(tech_levels.hyperspace_drive)
        let (m14, c14, d14) = _impulse_drive_upgrade_cost(tech_levels.impulse_drive)
        return (
            TechCosts(armour_tech=Cost(m4, c4, d4, 0),
            astrophysics=Cost(m11, c11, d11, 0),
            combustion_drive=Cost(m12, c12, d12, 0),
            computer_tech=Cost(m2, c2, d2, 0),
            energy_tech=Cost(m1, c1, d1, 0),
            espionage_tech=Cost(m5, c5, d5, 0),
            hyperspace_drive=Cost(m13, c13, d13, 0),
            hyperspace_tech=Cost(m10, c10, d10, 0),
            impulse_drive=Cost(m14, c14, d14, 0),
            ion_tech=Cost(m6, c6, d6, 0),
            laser_tech=Cost(m3, c3, d3, 0),
            plasma_tech=Cost(m7, c7, d7, 0),
            shielding_tech=Cost(m9, c9, d9, 0),
            weapons_tech=Cost(m8, c8, d8, 0)),
        )
    end

    func energy_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _energy_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _energy_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, ENERGY_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func energy_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, ENERGY_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, ENERGY_TECH_ID)
        return (TRUE)
    end

    func computer_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _computer_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _computer_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, COMPUTER_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func computer_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, COMPUTER_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, COMPUTER_TECH_ID)
        return (TRUE)
    end

    func laser_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _laser_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _laser_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, LASER_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func laser_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, LASER_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, LASER_TECH_ID)
        return (TRUE)
    end

    func armour_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _armour_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _armour_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, ARMOUR_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func armour_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, ARMOUR_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, ARMOUR_TECH_ID)
        return (TRUE)
    end

    func ion_tech_upgrade_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, current_tech_level : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt, time_end : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _ion_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _ion_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, ION_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func ion_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, ION_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, ION_TECH_ID)
        return (TRUE)
    end

    func espionage_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _espionage_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _espionage_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, ESPIONAGE_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func espionage_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, ESPIONAGE_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, ESPIONAGE_TECH_ID)
        return (TRUE)
    end

    func plasma_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _plasma_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _plasma_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, PLASMA_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func plasma_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, PLASMA_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, PLASMA_TECH_ID)
        return (TRUE)
    end

    func weapons_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _weapons_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _weapons_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, WEAPONS_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func weapons_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, WEAPONS_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, WEAPONS_TECH_ID)
        return (TRUE)
    end

    func shielding_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _shielding_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _shielding_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, SHIELDING_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func shielding_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, SHIELDING_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, SHIELDING_TECH_ID)
        return (TRUE)
    end

    func hyperspace_tech_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _hyperspace_tech_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _hyperspace_tech_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, HYPERSPACE_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func hyperspace_tech_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, HYPERSPACE_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, HYPERSPACE_TECH_ID)
        return (TRUE)
    end

    func astrophysics_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _astrophysics_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _astrophysics_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, ASTROPHYSICS_TECH_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func astrophysics_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, ASTROPHYSICS_TECH_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, ASTROPHYSICS_TECH_ID)
        return (TRUE)
    end

    func combustion_drive_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _combustion_drive_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _combustion_drive_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, COMBUSTION_DRIVE_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func combustion_drive_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, COMBUSTION_DRIVE_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, COMBUSTION_DRIVE_ID)
        return (TRUE)
    end

    func hyperspace_drive_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _hyperspace_drive_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _hyperspace_drive_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, HYPERSPACE_DRIVE_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func hyperspace_drive_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, HYPERSPACE_DRIVE_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, HYPERSPACE_DRIVE_ID)
        return (TRUE)
    end

    func impulse_drive_upgrade_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, current_tech_level : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _impulse_drive_upgrade_cost(
            current_tech_level
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _impulse_drive_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        let (time_end) = _set_timelock_and_que(
            caller, IMPULSE_DRIVE_ID, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required, time_end)
    end

    func impulse_drive_upgrade_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (success : felt):
        alloc_locals
        _check_trying_complete_right_tech(caller, IMPULSE_DRIVE_ID)
        _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, IMPULSE_DRIVE_ID)
        return (TRUE)
    end
end

# ###################################################################################################
#                                GENERAL TECH COST FUNCS                                            #
#####################################################################################################

func _energy_tech_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 0
    let base_crystal = 800
    let base_deuterium = 400
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _computer_tech_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 0
    let base_crystal = 400
    let base_deuterium = 600
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _laser_tech_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 200
    let base_crystal = 100
    let base_deuterium = 0
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _armour_tech_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 1000
    let base_crystal = 0
    let base_deuterium = 0
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _espionage_tech_upgrade_cost{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(current_level : felt) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 200
    let base_crystal = 1000
    let base_deuterium = 200
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _ion_tech_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 1000
    let base_crystal = 300
    let base_deuterium = 1000
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _plasma_tech_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 2000
    let base_crystal = 4000
    let base_deuterium = 1000
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _astrophysics_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 4000
    let base_crystal = 8000
    let base_deuterium = 4000
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _weapons_tech_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 800
    let base_crystal = 200
    let base_deuterium = 0
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _shielding_tech_upgrade_cost{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(current_level : felt) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 200
    let base_crystal = 600
    let base_deuterium = 0
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _hyperspace_tech_upgrade_cost{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(current_level : felt) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 0
    let base_crystal = 4000
    let base_deuterium = 2000
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

# ################################## ENGINES #########################################
func _combustion_drive_upgrade_cost{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(current_level : felt) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 400
    let base_crystal = 0
    let base_deuterium = 600
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _impulse_drive_upgrade_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    current_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 2000
    let base_crystal = 4000
    let base_deuterium = 600
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

func _hyperspace_drive_upgrade_cost{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(current_level : felt) -> (metal : felt, crystal : felt, deuterium : felt):
    let base_metal = 10000
    let base_crystal = 20000
    let base_deuterium = 6000
    if current_level == 0:
        tempvar syscall_ptr = syscall_ptr
        return (base_metal, base_crystal, base_deuterium)
    else:
        let (multiplier) = pow(2, current_level)
        return (base_metal * multiplier, base_crystal * multiplier, base_deuterium * multiplier)
    end
end

# ##################################################################################
#                                TECH UPGRADE REQUIREMENTS CHECK                   #
####################################################################################

func _energy_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    with_attr error_message("ENERGY TECH::RESEARCH LAB MUST BE AT LEVEL 1"):
        assert_le(1, research_lab_level)
    end
    return ()
end

func _computer_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    with_attr error_message("COMPUTER TECH::RESEARCH LAB MUST BE AT LEVEL 1"):
        assert_le(1, research_lab_level)
    end
    return ()
end

func _laser_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let energy_tech_level = tech_levels.energy_tech
    with_attr error_message("LASER TECH::RESEARCH LAB MUST BE AT LEVEL 1"):
        assert_le(1, research_lab_level)
    end
    with_attr error_message("LASER TECH::ENERGY TECH MUST BE AT LEVEL 2"):
        assert_le(2, energy_tech_level)
    end
    return ()
end

func _armour_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    with_attr error_message("ARMOUR TECH::RESEARCH LAB MUST BE AT LEVEL 2"):
        assert_le(2, research_lab_level)
    end
    return ()
end

func _astrophysics_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let impulse_drive_level = tech_levels.impulse_drive
    let espionage_tech_level = tech_levels.espionage_tech
    with_attr error_message("ASTROPHYSICS::RESEARCH LAB MUST BE AT LEVEL 3"):
        assert_le(3, research_lab_level)
    end
    with_attr error_message("ASTROPHYSICS::IMPULSE DRIVE MUST BE AT LEVEL 3"):
        assert_le(3, impulse_drive_level)
    end
    with_attr error_message("ASTROPHYSICS::ESPIONAGE TECH MUST BE AT LEVEL 4"):
        assert_le(4, espionage_tech_level)
    end
    return ()
end

func _espionage_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    with_attr error_message("ESPIONAGE TECH::RESEARCH LAB MUST BE AT LEVEL 3"):
        assert_le(3, research_lab_level)
    end
    return ()
end

func _ion_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let laser_tech_level = tech_levels.laser_tech
    let energy_tech_level = tech_levels.energy_tech
    with_attr error_message("ION TECH::RESEARCH LAB MUST BE AT LEVEL 4"):
        assert_le(4, research_lab_level)
    end
    with_attr error_message("ION TECH::LASER TECH MUST BE AT LEVEL 5"):
        assert_le(5, laser_tech_level)
    end
    with_attr error_message("ION TECH::ENERGY TECH MUST BE AT LEVEL 4"):
        assert_le(4, energy_tech_level)
    end
    return ()
end

func _plasma_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let laser_tech_level = tech_levels.laser_tech
    let energy_tech_level = tech_levels.energy_tech
    let ion_tech_level = tech_levels.ion_tech
    with_attr error_message("PLASMA TECH::RESEARCH LAB MUST BE AT LEVEL 4"):
        assert_le(4, research_lab_level)
    end
    with_attr error_message("PLASMA TECH::ENERGY TECH MUST BE AT LEVEL 8"):
        assert_le(8, energy_tech_level)
    end
    with_attr error_message("PLASMA TECH::LASER TECH MUST BE AT LEVEL 10"):
        assert_le(10, laser_tech_level)
    end
    with_attr error_message("PLASMA TECH::HYPERSPACE TECH MUST BE AT LEVEL 5"):
        assert_le(5, ion_tech_level)
    end
    return ()
end

func _weapons_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    with_attr error_message("WEAPONS TECH::RESEARCH LAB MUST BE AT LEVEL 4"):
        assert_le(4, research_lab_level)
    end
    return ()
end

func _shielding_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let energy_tech_level = tech_levels.energy_tech
    with_attr error_message("SHIELDING TECH::RESEARCH LAB MUST BE AT LEVEL 6"):
        assert_le(6, research_lab_level)
    end
    with_attr error_message("SHIELDING TECH::ENERGY TECH MUST BE AT LEVEL 3"):
        assert_le(3, energy_tech_level)
    end
    return ()
end

func _hyperspace_tech_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let energy_tech_level = tech_levels.energy_tech
    let shielding_tech_level = tech_levels.shielding_tech
    with_attr error_message("HYPERSPACE TECH::RESEARCH LAB MUST BE AT LEVEL 7"):
        assert_le(7, research_lab_level)
    end
    with_attr error_message("HYPERSPACE TECH::ENERGY TECH MUST BE AT LEVEL 5"):
        assert_le(5, energy_tech_level)
    end
    with_attr error_message("HYPERSPACE TECH::SHIELDING TECH MUST BE AT LEVEL 5"):
        assert_le(5, shielding_tech_level)
    end
    return ()
end
# ###################### ENGINES SPECIFIC UPGRADE REQUIREMENTS CHECK #########################

func _combustion_drive_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let energy_tech_level = tech_levels.energy_tech

    with_attr error_message("COMBUSTION DRIVE::RESEARCH LAB MUST BE AT LEVEL 1"):
        assert_le(1, research_lab_level)
    end
    with_attr error_message("COMBUSTION DRIVE::ENERGY TECH MUST BE AT LEVEL 1"):
        assert_le(1, energy_tech_level)
    end

    return ()
end

func _impulse_drive_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let energy_tech_level = tech_levels.energy_tech
    with_attr error_message("IMPULSE DRIVE::RESEARCH LAB MUST BE AT LEVEL 2"):
        assert_le(2, research_lab_level)
    end
    with_attr error_message("IMPULSE DRIVE::ENERGY TECH MUST BE AT LEVEL 1"):
        assert_le(1, energy_tech_level)
    end
    return ()
end

func _hyperspace_drive_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> ():
    alloc_locals
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = _get_tech_levels(caller)
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let energy_tech_level = tech_levels.energy_tech
    let shielding_tech_level = tech_levels.shielding_tech
    let hyperspace_tech_level = tech_levels.hyperspace_tech
    with_attr error_message("HYPERSPACE DRIVE::RESEARCH LAB MUST BE AT LEVEL 7"):
        assert_le(7, research_lab_level)
    end
    with_attr error_message("HYPERSPACE DRIVE::ENERGY TECH MUST BE AT LEVEL 5"):
        assert_le(5, energy_tech_level)
    end
    with_attr error_message("HYPERSPACE DRIVE::SHIELDING TECH MUST BE AT LEVEL 5"):
        assert_le(5, shielding_tech_level)
    end
    with_attr error_message("HYPERSPACE DRIVE::HYPERSPACE TECH MUST BE AT LEVEL 3"):
        assert_le(3, hyperspace_tech_level)
    end
    return ()
end

# func _graviton_tech_requirements_check{
#     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
# }(caller : felt) -> ():
#     let (no_game_address) = Research_no_game_address.read()
#     let (_, _, _, enengy_available) = INoGame.getResourcesAvailable(no_game_address, caller)
#     with_attr error_message("RESEARCH LAB MUST BE AT LEVEL 1"):
#         assert_le(300000, enengy_available)
#     end
#     return ()
# end

#######################################################################################################
#                                           PRIVATE FUNC                                              #
#######################################################################################################
func _get_available_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (no_game_address) = Research_no_game_address.read()
    let (_, metal_address, crystal_address, deuterium_address) = INoGame.getTokensAddresses(
        no_game_address
    )
    let (metal_available) = IERC20.balanceOf(metal_address, caller)
    let (crystal_available) = IERC20.balanceOf(crystal_address, caller)
    let (deuterium_available) = IERC20.balanceOf(deuterium_address, caller)
    return (metal_available.low, crystal_available.low, deuterium_available.low)
end

func _get_tech_levels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (result : TechLevels):
    let (no_game_address) = Research_no_game_address.read()
    let (tech_levels) = INoGame.getTechLevels(no_game_address, caller)
    return (tech_levels)
end

func _reset_timelock{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
):
    Research_timelock.write(address, ResearchQue(0, 0))
    return ()
end

func _reset_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt, id : felt
):
    Research_qued.write(address, id, FALSE)
    return ()
end

func _check_que_not_busy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    let (que_status) = Research_timelock.read(caller)
    let current_timelock = que_status.lock_end
    with_attr error_message("RESEARCH LAB::RESEARCH QUE IS BUSY"):
        assert current_timelock = 0
    end
    let (game) = Research_no_game_address.read()
    let (lab_available) = INoGame.getBuildingQueStatus(game, caller)
    with_attr error_message("RESEARCH LAB::RESEARCH LAB IS UPGRADING"):
        assert_not_equal(lab_available.id, RESEARCH_LAB_ID)
    end

    return ()
end

func _check_enough_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, metal_required : felt, crystal_required : felt, deuterium_required : felt
):
    alloc_locals
    let (metal_available, crystal_available, deuterium_available) = _get_available_resources(caller)
    with_attr error_message("RESEARCH LAB::NOT ENOUGH RESOURCES"):
        let (enough_metal) = is_le(metal_required, metal_available)
        assert enough_metal = TRUE
        let (enough_crystal) = is_le(crystal_required, crystal_available)
        assert enough_crystal = TRUE
        let (enough_deuterium) = is_le(deuterium_required, deuterium_available)
        assert enough_deuterium = TRUE
    end
    return ()
end

func _check_trying_complete_right_tech{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt, TECH_ID : felt):
    let (is_qued) = Research_qued.read(caller, TECH_ID)
    with_attr error_message("RESEARCH LAB::TRIED TO COMPLETE THE WRONG TECH"):
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
    let (cue_details) = Research_timelock.read(caller)
    let timelock_end = cue_details.lock_end
    let (waited_enough) = is_le(timelock_end, time_now)
    with_attr error_message("RESEARCH LAB::TIMELOCK NOT YET EXPIRED"):
        assert waited_enough = TRUE
    end
    return ()
end

func _set_timelock_and_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, TECH_ID : felt, metal_required : felt, crystal_required : felt
) -> (time_end : felt):
    let (no_game_address) = Research_no_game_address.read()
    let (_, _, research_lab_level, _) = INoGame.getFacilitiesLevels(no_game_address, caller)
    let (research_time) = Formulas.buildings_production_time(
        metal_required, crystal_required, research_lab_level, 0
    )
    let (time_now) = get_block_timestamp()
    let time_end = time_now + research_time
    let que_details = ResearchQue(TECH_ID, time_end)
    Research_qued.write(caller, TECH_ID, TRUE)
    Research_timelock.write(caller, que_details)
    return (time_end)
end
