%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE
from facilities.library import Facilities, FacilitiesQue
from main.library import Cost

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    no_game_address: felt
) {
    Facilities.initializer(no_game_address);
    return ();
}

@view
func getTimelockStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (cued_details: FacilitiesQue) {
    let (res) = Facilities.timelock_status(caller);
    return (res,);
}

@view
func getUpgradeCost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (robot_factory: Cost, shipyard: Cost, research_lab: Cost, nanite: Cost) {
    let (robot, shipyard, research, nanite) = Facilities.upgrades_cost(caller);
    return (robot, shipyard, research, nanite);
}

@external
func shipyardUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_unlocked: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.shipyard_upgrade_start(caller);
    return (metal_required, crystal_required, deuterium_required, time_unlocked);
}

@external
func shipyardUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (success: felt) {
    Facilities.shipyard_upgrade_complete(caller);
    return (TRUE,);
}

@external
func robotFactoryUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_unlocked: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.robot_factory_upgrade_start(caller);
    return (metal_required, crystal_required, deuterium_required, time_unlocked);
}

@external
func robotFactoryUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (success: felt) {
    Facilities.robot_factory_upgrade_complete(caller);
    return (TRUE,);
}

@external
func researchLabUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_unlocked: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.research_lab_upgrade_start(caller);
    return (metal_required, crystal_required, deuterium_required, time_unlocked);
}

@external
func researchLabUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (success: felt) {
    Facilities.research_lab_upgrade_complete(caller);
    return (TRUE,);
}

@external
func naniteFactoryUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal: felt, crystal: felt, deuterium: felt, time_unlocked: felt) {
    let (
        metal_required, crystal_required, deuterium_required, time_unlocked
    ) = Facilities.nanite_factory_upgrade_start(caller);
    return (metal_required, crystal_required, deuterium_required, time_unlocked);
}

@external
func naniteFactoryUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (success: felt) {
    Facilities.nanite_factory_upgrade_complete(caller);
    return (TRUE,);
}
