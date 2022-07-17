%lang starknet

from main.structs import Cost

@contract_interface
namespace IResources:
    func getBuildingTimelockStatus(caller) -> (building_id : felt, timelock_end : felt):
    end

    func metal_upgrade_start(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func metal_upgrade_complete(caller : felt):
    end

    func crystal_upgrade_start(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func crystal_upgrade_complete(caller : felt):
    end

    func deuterium_upgrade_start(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func deuterium_upgrade_complete(caller : felt):
    end

    func solar_plant_upgrade_start(caller : felt) -> (
        metal_spent : felt, crystal_spent : felt, time_unlocked : felt
    ):
    end

    func solar_plant_upgrade_complete(caller : felt):
    end

    func getResourcesUpgradeCost(caller : felt) -> (
        robot_factory : Cost, shipyard : Cost, research_lab : Cost, nanite_factory : Cost
    ):
    end
end
