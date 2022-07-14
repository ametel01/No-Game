%lang starknet

from facilities.library import FacilitiesQue
from main.structs import Cost

@contract_interface
namespace IFacilities:
    func robotFactoryUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_unlocked : felt
    ):
    end

    func robotFactoryUpgradeComplete(caller : felt) -> (success : felt):
    end

    func shipyardUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_unlocked : felt
    ):
    end

    func shipyardUpgradeComplete(caller : felt) -> (success : felt):
    end

    func researchLabUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_unlocked : felt
    ):
    end

    func researchLabUpgradeComplete(caller : felt) -> (success : felt):
    end

    func naniteFactoryUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_unlocked : felt
    ):
    end

    func naniteFactoryUpgradeComplete(caller : felt) -> (success : felt):
    end

    func getFacilitiesUpgradeCost(caller : felt) -> (
        robot_factory : Cost, shipyard : Cost, research_lab : Cost, nanite_factory : Cost
    ):
    end

    func getTimelockStatus(caller : felt) -> (cued_details : FacilitiesQue):
    end
end
