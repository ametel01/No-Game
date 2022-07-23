%lang starknet

from main.structs import Cost
from resources.library import ResourcesQue

@contract_interface
namespace IResources:
    func getBuildingTimelockStatus(caller) -> (building_id : felt, timelock_end : felt):
    end

    func metalUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func metalUpgradeComplete(caller : felt):
    end

    func crystalUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func crystalUpgradeComplete(caller : felt):
    end

    func deuteriumUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func deuteriumUpgradeComplete(caller : felt):
    end

    func solarPlantUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func solarPlantUpgradeComplete(caller : felt):
    end

    func fusionReactorUpgradeStart(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_unlocked : felt
    ):
    end

    func fusionReactorUpgradeComplete(caller : felt):
    end

    func getResourcesUpgradeCost(caller : felt) -> (
        metal_mine : Cost,
        crystal_mine : Cost,
        deuterium_mine : Cost,
        solar_plant : Cost,
        fusion_reactor : Cost,
    ):
    end

    func getTimelockStatus(caller : felt) -> (cued_details : ResourcesQue):
    end
end
