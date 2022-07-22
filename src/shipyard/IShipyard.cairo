%lang starknet

@contract_interface
namespace IShipyard:
    func cargoShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func cargoShipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func RecyclerShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func RecyclerShipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func EspionageProbeBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func EspionageProbeBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func SolarSatelliteBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func SolarSatelliteBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func LightFighterBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func LightFighterBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func CruiserBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func CruiserBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func BattleshipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func BattleshipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func DeathstarShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func DeathstarShipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end
end
