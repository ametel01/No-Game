%lang starknet

@contract_interface
namespace IResearchLab:
    func energyTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func energyTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func computerTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func computerTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func laserTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func laserTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func armourTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func armourTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func ionTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func ionTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func espionageTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func espionageTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func plasmaTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func plasmaTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func weaponsTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func weaponsTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func shieldingTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func ShieldingTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func hyperspaceTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func hyperspaceTechUpgradeComplete(caller : felt) -> (success : felt):
    end

    func astrophysicsUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func astrophysicsUpgradeComplete(caller : felt) -> (success : felt):
    end

    func combustionDriveUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func combustionDriveUpgradeComplete(caller : felt) -> (success : felt):
    end

    func hyperspaceDriveUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func hyperspaceDriveUpgradeComplete(caller : felt) -> (success : felt):
    end

    func impulseDriveUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt
    ):
    end

    func impulseDriveUpgradeComplete(caller : felt) -> (success : felt):
    end
end
