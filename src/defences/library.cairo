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

const ROCKET_LAUNCHER = 51
const LIGHT_LASER = 52
const HEAVY_LASOR = 53
const ION_CANNON = 54
const GAUSS_CANNON = 55
const PLASMA_TURRET = 56
const SMALL_DOME = 57
const LARGE_DOME = 58

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
    member plasma_tourette : Cost
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
end

#######################################################################################################
#                                           PRIVATE FUNC                                              #
#######################################################################################################

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

func _check_trying_to_complete_the_right_ship{
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
    let (no_game) = Shipyard_no_game_address.read()
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
