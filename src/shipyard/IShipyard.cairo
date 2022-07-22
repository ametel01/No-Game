%lang starknet

@contract_interface
namespace IShipyard:
    func cargoShipBuildStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func cargoShipBuildComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func buildRecyclerShipStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func buildRecyclerShipComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func buildEspionageProbeStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func buildEspionageProbeComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func buildSolarSatelliteStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func buildSolarSatelliteComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func buildLightFighterStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func buildLightFighterComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func buildCruiserStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func buildCruiserComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func buildBattleshipStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func buildBattleshipComplete(caller : felt) -> (units_produced : felt, success : felt):
    end

    func buildDeathstarShipStart(caller : felt, number_of_units : felt) -> (
        metal_spent : felt, crystal_spent : felt, deuterium_spent : felt
    ):
    end

    func buildDeathstarShipComplete(caller : felt) -> (units_produced : felt, success : felt):
    end
end
