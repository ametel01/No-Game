%lang starknet

from shipyard.library import ShipyardQue, ShipsCosts

@contract_interface
namespace IShipyard:
    func getQueStatus(caller : felt) -> (status : ShipyardQue):
    end

    func getShipsCost() -> (costs : ShipsCosts):
    end

    func cargoShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func cargoShipBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func recyclerShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func recyclerShipBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func espionageProbeBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func espionageProbeBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func solarSatelliteBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func solarSatelliteBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func lightFighterBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func lightFighterBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func cruiserBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func cruiserBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func battleshipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func battleshipBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func deathstarShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt, time_end : felt
    ):
    end

    func deathstarShipBuildComplete(caller : felt) -> (units_produced : felt):
    end
end
