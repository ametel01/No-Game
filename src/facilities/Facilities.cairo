%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE
from facilities.library import Facilities, FacilitiesQue
from main.INoGame import INoGame

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    no_game_address : felt
):
    Facilities.initializer(no_game_address)
    return ()
end

@external
func shipyardUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.shipyard_upgrade_start(caller)
    return (metal_required, crystal_required, deuterium_required, time_unlocked)
end

@external
func shipyardUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (success : felt):
    Facilities.shipyard_upgrade_complete(caller)
    return (TRUE)
end

@external
func robotFactoryUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.robot_factory_upgrade_start(caller)
    return (metal_required, crystal_required, deuterium_required, time_unlocked)
end

@external
func robotFactoryUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (success : felt):
    Facilities.robot_factory_upgrade_complete(caller)
    return (TRUE)
end

@external
func researchLabUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.research_lab_upgrade_start(caller)
    return (metal_required, crystal_required, deuterium_required, time_unlocked)
end

@external
func researchLabUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (success : felt):
    Facilities.research_lab_upgrade_complete(caller)
    return (TRUE)
end

@external
func naniteFactoryUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt, time_unlocked : felt):
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.nanite_factory_upgrade_start(caller)
    return (metal_required, crystal_required, deuterium_required, time_unlocked)
end

@external
func naniteFactoryUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt) -> (success : felt):
    Facilities.nanite_factory_upgrade_complete(caller)
    return (TRUE)
end

@external
func getTimelockStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (cued_details : FacilitiesQue):
    let (res) = Facilities.get_timelock_status(caller)
    return (res)
end
