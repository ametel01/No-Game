%lang starknet

@contract_interface
namespace IShipyard:
    func cargoShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func cargoShipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func recyclerShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func recyclerShipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func espionageProbeBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func espionageProbeBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func solarSatelliteBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func solarSatelliteBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func lightFighterBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func lightFighterBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func cruiserBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func cruiserBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func battleshipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func battleshipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func deathstarShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func deathstarShipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end
end
