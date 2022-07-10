%lang starknet

@contract_interface
namespace IResources:
    func getBuildingTimelockStatus(caller) -> (building_id : felt, timelock_end : felt):
    end

    func metal_upgrade_start():
    end

    func metal_upgrade_complete():
    end

    func crystal_upgrade_start():
    end

    func crystal_upgrade_complete():
    end

    func deuterium_upgrade_start():
    end

    func deuterium_upgrade_complete():
    end

    func solar_plant_upgrade_start():
    end

    func shielding_tech_upgrade_complete():
    end
end
