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
func Defence_timelock(address : felt) -> (res : felt):
end

@storage_var
func Defence_qued(address : felt, id : felt) -> (res : felt):
end
