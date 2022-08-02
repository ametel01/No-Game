%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from main.structs import TechCosts
from research.library import ResearchLab

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    no_game_address : felt
):
    ResearchLab.initializer(no_game_address)
    return ()
end

@external
func getUpgradesCost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (costs : TechCosts):
    alloc_locals
    let (costs) = ResearchLab.upgrades_cost(caller)
    return (costs)
end

# ######### UPGRADES FUNCS ############################

@external
func energyTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.energy_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func energyTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.energy_tech_upgrade_complete(caller)
    return ()
end

@external
func computerTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.computer_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func computerTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.computer_tech_upgrade_complete(caller)
    return ()
end

@external
func laserTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.laser_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func laserTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.ion_tech_upgrade_complete(caller)
    return ()
end

@external
func armourTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.armour_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func armourTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.armour_tech_upgrade_complete(caller)
    return ()
end

@external
func ionTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (metal_required, crystal_required, deuterium_required) = ResearchLab.ion_tech_upgrade_start(
        caller, current_tech_level
    )
    return (metal_required, crystal_required, deuterium_required)
end

@external
func ionTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.ion_tech_upgrade_complete(caller)
    return ()
end

@external
func espionageTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.espionage_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func espionageTechUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt):
    ResearchLab.espionage_tech_upgrade_complete(caller)
    return ()
end

@external
func plasmaTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.plasma_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func plasmaTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.plasma_tech_upgrade_complete(caller)
    return ()
end

@external
func weaponsTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.weapons_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func weaponsTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.weapons_tech_upgrade_complete(caller)
    return ()
end

@external
func shieldingTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.shielding_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func shieldingTechUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt):
    ResearchLab.shielding_tech_upgrade_complete(caller)
    return ()
end

@external
func hyperspaceTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.hyperspace_tech_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func hyperspaceTechUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt):
    ResearchLab.hyperspace_tech_upgrade_complete(caller)
    return ()
end

@external
func astrophysicsUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.astrophysics_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func astrophysicsUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.astrophysics_upgrade_complete(caller)
    return ()
end

@external
func combustionDriveUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.combustion_drive_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func combustionDriveUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt):
    ResearchLab.combustion_drive_upgrade_complete(caller)
    return ()
end

@external
func hyperspaceDriveUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.hyperspace_drive_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func hyperspaceDriveUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(caller : felt):
    ResearchLab.hyperspace_drive_upgrade_complete(caller)
    return ()
end

@external
func impulseDriveUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt, current_tech_level : felt
) -> (metal : felt, crystal : felt, deuterium : felt):
    let (
        metal_required, crystal_required, deuterium_required
    ) = ResearchLab.impulse_drive_upgrade_start(caller, current_tech_level)
    return (metal_required, crystal_required, deuterium_required)
end

@external
func impulseDriveUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
):
    ResearchLab.impulse_drive_upgrade_complete(caller)
    return ()
end
