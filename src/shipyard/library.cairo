%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, unsigned_div_rem, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_block_timestamp
from main.INoGame import INoGame
from token.erc20.interfaces.IERC20 import IERC20

#########################################################################################
#                                           CONSTANTS                                   #
#########################################################################################

const CARGO_SHIP_ID = 31
const RECYCLER_SHIP_ID = 32
const ESPIONAGE_PROBE_ID = 33
const SOLAR_SATELLITE_ID = 34
const LIGHT_FIGHTER_ID = 35
const CRUISER_ID = 36
const BATTLESHIP_ID = 37
const DEATHSTAR_ID = 38

#########################################################################################
#                                           STRUCTS                                     #
#########################################################################################
struct ShipsCost:
    member metal : felt
    member crystal : felt
    member deuterium : felt
end

struct Performance:
    member structural_intergrity : felt
    member shield_power : felt
    member weapon_power : felt
    member cargo_capacity : felt
    member base_speed : felt
    member fuel_consumption : felt
end

struct Ships:
    member cost : ShipsCost
    member performance : Performance
end

struct ShipyardQue:
    member ship_id : felt
    member units : felt
    member lock_end : felt
end

#########################################################################################
#                                           STORAGES                                    #
#########################################################################################

@storage_var
func Shipyard_no_game_address() -> (address : felt):
end

# @dev Stores the timestamp of the end of the timelock for buildings upgrades.
# @params The address of the player.
@storage_var
func Shipyard_timelock(address : felt) -> (cued_details : ShipyardQue):
end

# @dev Stores the que status for a specific ship.
@storage_var
func Shipyard_qued(address : felt, id : felt) -> (is_qued : felt):
end

namespace Shipyard:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        no_game_address : felt
    ):
        Shipyard_no_game_address.write(no_game_address)
        return ()
    end
    func cargo_ship_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal : felt, crystal : felt, deuterium : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _cargo_ship_cost(
            number_of_units
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _cargo_ship_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        _set_timelock_and_que(
            caller, CARGO_SHIP_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required)
    end

    func cargo_ship_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_ship(caller, CARGO_SHIP_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, CARGO_SHIP_ID)
        return (units_produced)
    end

    func recycler_ship_build_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _recycler_ship_cost(
            number_of_units
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _recycler_ship_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        _set_timelock_and_que(
            caller, RECYCLER_SHIP_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required)
    end

    func recycler_ship_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (unit_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_ship(caller, RECYCLER_SHIP_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, RECYCLER_SHIP_ID)
        return (units_produced)
    end

    func espionage_probe_build_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _espionage_probe_cost(
            number_of_units
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _espionage_probe_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        _set_timelock_and_que(
            caller, ESPIONAGE_PROBE_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required)
    end

    func espionage_probe_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (units_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_ship(caller, ESPIONAGE_PROBE_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, ESPIONAGE_PROBE_ID)
        return (units_produced)
    end

    func solar_satellite_build_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _solar_satellite_cost(
            number_of_units
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _solar_satellite_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        _set_timelock_and_que(
            caller, SOLAR_SATELLITE_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required)
    end

    func solar_satellite_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (units_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_ship(caller, SOLAR_SATELLITE_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, SOLAR_SATELLITE_ID)
        return (units_produced)
    end

    func light_fighter_build_start{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _light_fighter_cost(
            number_of_units
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _light_fighter_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        _set_timelock_and_que(
            caller, LIGHT_FIGHTER_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required)
    end

    func light_fighter_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (units_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_ship(caller, LIGHT_FIGHTER_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, LIGHT_FIGHTER_ID)
        return (units_produced)
    end

    func cruiser_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _cruiser_cost(number_of_units)
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _cruiser_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        _set_timelock_and_que(caller, CRUISER_ID, number_of_units, metal_required, crystal_required)
        return (metal_required, crystal_required, deuterium_required)
    end

    func cruiser_build_complete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt
    ) -> (units_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_ship(caller, CRUISER_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, CRUISER_ID)
        return (units_produced)
    end

    func battleship_build_start{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        caller : felt, number_of_units : felt
    ) -> (metal_spent : felt, crystal_spent : felt, deuterium_spent : felt):
        alloc_locals
        let (metal_required, crystal_required, deuterium_required) = _battleship_cost(
            number_of_units
        )
        assert_not_zero(caller)
        _check_que_not_busy(caller)
        _battleship_requirements_check(caller)
        _check_enough_resources(caller, metal_required, crystal_required, deuterium_required)
        _set_timelock_and_que(
            caller, BATTLESHIP_ID, number_of_units, metal_required, crystal_required
        )
        return (metal_required, crystal_required, deuterium_required)
    end

    func battleship_build_complete{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(caller : felt) -> (units_produced : felt):
        alloc_locals
        _check_trying_to_complete_the_right_ship(caller, BATTLESHIP_ID)
        let (units_produced) = _check_waited_enough(caller)
        _reset_timelock(caller)
        _reset_que(caller, BATTLESHIP_ID)
        return (units_produced)
    end
end

# ###################################################################################################
#                                SHIPS REQUIREMENTS CHECHS                                          #
#####################################################################################################

func _cargo_ship_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 2"):
        assert_le(2, shipyard_level)
    end
    with_attr error_message("SHIPYARD::COMBUSTION DRIVE MUST BE AT LEVEL 2"):
        assert_le(2, tech_levels.combustion_drive)
    end
    return (TRUE)
end

func _recycler_ship_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 4"):
        assert_le(4, shipyard_level)
    end
    with_attr error_message("SHIPYARD::COMBUSTION DRIVE MUST BE AT LEVEL 2 6"):
        assert_le(6, tech_levels.combustion_drive)
    end
    with_attr error_message("SHIPYARD::SHIELDING TECHNOLOGY MUST BE AT LEVEL 2"):
        assert_le(2, tech_levels.shielding_tech)
    end
    return (TRUE)
end

func _espionage_probe_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 3"):
        assert_le(3, shipyard_level)
    end
    with_attr error_message("SHIPYARD::COMBUSTION DRIVE MUST BE AT LEVEL 3"):
        assert_le(3, tech_levels.combustion_drive)
    end
    with_attr error_message("SHIPYARD::ESPIONAGE TECHNOLOGY MUST BE AT LEVEL 2"):
        assert_le(2, tech_levels.espionage_tech)
    end
    return (TRUE)
end

func _solar_satellite_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 1"):
        assert_le(1, shipyard_level)
    end
    return (TRUE)
end

func _light_fighter_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 1"):
        assert_le(1, shipyard_level)
    end
    with_attr error_message("SHIPYARD::COMBUSTION DRIVE MUST BE AT LEVEL 1"):
        assert_le(1, tech_levels.combustion_drive)
    end
    return (TRUE)
end

func _cruiser_requirements_check{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 5"):
        assert_le(5, shipyard_level)
    end
    with_attr error_message("SHIPYARD::ION TECH MUST BE AT LEVEL 2"):
        assert_le(2, tech_levels.ion_tech)
    end
    with_attr error_message("SHIPYARD::IMPULSE DRIVE MUST BE AT LEVEL 4"):
        assert_le(4, tech_levels.impulse_drive)
    end
    return (TRUE)
end

func _battleship_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 7"):
        assert_le(7, shipyard_level)
    end
    with_attr error_message("SHIPYARD::HYPERSPACE DRIVE MUST BE AT LEVEL 4"):
        assert_le(4, tech_levels.hyperspace_drive)
    end
    return (TRUE)
end

func _deathstar_requirements_check{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (response : felt):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (tech_levels) = INoGame.getTechLevels(no_game, caller)
    with_attr error_message("SHIPYARD::SHIPYARD MUST BE AT LEVEL 12"):
        assert_le(12, shipyard_level)
    end
    with_attr error_message("SHIPYARD::HYPERSPACE TECH MUST BE AT LEVEL 6"):
        assert_le(6, tech_levels.hyperspace_tech)
    end
    with_attr error_message("SHIPYARD::HYPERSPACE DRIVE MUST BE AT LEVEL 7"):
        assert_le(7, tech_levels.hyperspace_drive)
    end
    # TODO: add graviton tech here
    with_attr error_message("SHIPYARD::HYPERSPACE DRIVE MUST BE AT LEVEL 7"):
        assert_le(7, tech_levels.espionage_tech)
    end
    return (TRUE)
end

# ###################################################################################################
#                                SHIPS COST CALCULATION FUNCTIONS                                   #
#####################################################################################################

func _cargo_ship_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 2000
    let crystal_required = 2000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _recycler_ship_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 10000
    let crystal_required = 6000
    let deuterium_required = 2000
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _espionage_probe_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 0
    let crystal_required = 1000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _solar_satellite_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 0
    let crystal_required = 2000
    let deuterium_required = 500
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _light_fighter_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 3000
    let crystal_required = 1000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _cruiser_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 20000
    let crystal_required = 7000
    let deuterium_required = 2000
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _battleship_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 45000
    let crystal_required = 15000
    let deuterium_required = 0
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

func _deathstar_cost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    number_of_units : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let metal_required = 5000000
    let crystal_required = 4000000
    let deuterium_required = 1000000
    return (
        metal_required * number_of_units,
        crystal_required * number_of_units,
        deuterium_required * number_of_units,
    )
end

#######################################################################################################
#                                           INTERNAL FUNC                                             #
#######################################################################################################

func _production_time{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    metal_required : felt, crystal_required : felt, shipyard_level : felt
) -> (_production_time : felt):
    let fact1 = metal_required + crystal_required
    let fact2 = 1 + shipyard_level
    let fact3 = fact2 * 250
    let (res, _) = unsigned_div_rem(fact1, fact3)
    return (res)
end

func _get_available_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (no_game) = Shipyard_no_game_address.read()
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
    with_attr error_message("not enough resources"):
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
    Shipyard_timelock.write(address, ShipyardQue(0, 0, 0))
    return ()
end

func _reset_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt, id : felt
):
    Shipyard_qued.write(address, id, FALSE)
    return ()
end

func _check_que_not_busy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    let (que_status) = Shipyard_timelock.read(caller)
    let current_timelock = que_status.lock_end
    with_attr error_message("SHIPYARD::Que is busy"):
        assert current_timelock = 0
    end
    return ()
end

func _check_trying_to_complete_the_right_ship{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt, SHIP_ID : felt):
    let (is_qued) = Shipyard_qued.read(caller, SHIP_ID)
    with_attr error_message("Tried to complete the wrong ship"):
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
    let (que_details) = Shipyard_timelock.read(caller)
    let timelock_end = que_details.lock_end
    let (waited_enough) = is_le(timelock_end, time_now)
    with_attr error_message("Timelock not yet expired"):
        assert waited_enough = TRUE
    end
    let units_produced = que_details.units
    return (units_produced)
end

func _set_timelock_and_que{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt,
    SHIP_ID : felt,
    number_of_units : felt,
    metal_required : felt,
    crystal_required : felt,
):
    let (no_game) = Shipyard_no_game_address.read()
    let (_, _, shipyard_level, _) = INoGame.getFacilitiesLevels(no_game, caller)
    let (build_time) = _production_time(metal_required, crystal_required, shipyard_level)
    let (time_now) = get_block_timestamp()
    let time_end = time_now + build_time
    let que_details = ShipyardQue(SHIP_ID, number_of_units, time_end)
    Shipyard_qued.write(caller, SHIP_ID, TRUE)
    Shipyard_timelock.write(caller, que_details)
    return ()
end
