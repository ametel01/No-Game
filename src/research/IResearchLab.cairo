%lang starknet

from main.structs import TechCosts
from research.library import ResearchQue

@contract_interface
namespace IResearchLab:
    func getQueStatus(caller : felt) -> (status : ResearchQue):
    end

    func armourTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func armourTechUpgradeComplete(caller : felt):
    end

    func astrophysicsUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func astrophysicsUpgradeComplete(caller : felt):
    end

    func combustionDriveUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func combustionDriveUpgradeComplete(caller : felt):
    end

    func computerTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func computerTechUpgradeComplete(caller : felt):
    end

    func energyTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func energyTechUpgradeComplete(caller : felt):
    end

    func espionageTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func espionageTechUpgradeComplete(caller : felt):
    end

    func hyperspaceDriveUpgradeComplete(caller : felt):
    end

    func hyperspaceTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func hyperspaceDriveUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func hyperspaceTechUpgradeComplete(caller : felt):
    end

    func impulseDriveUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func impulseDriveUpgradeComplete(caller : felt):
    end

    func ionTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func ionTechUpgradeComplete(caller : felt):
    end

    func laserTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func laserTechUpgradeComplete(caller : felt):
    end

    func plasmaTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func plasmaTechUpgradeComplete(caller : felt):
    end

    func shieldingTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func shieldingTechUpgradeComplete(caller : felt):
    end

    func weaponsTechUpgradeStart(caller : felt, current_tech_level : felt) -> (
        metal_required : felt, crystal_required : felt, deuterium_required : felt, time_end : felt
    ):
    end

    func weaponsTechUpgradeComplete(caller : felt):
    end

    func getUpgradesCost(caller : felt) -> (cost : TechCosts):
    end
end
