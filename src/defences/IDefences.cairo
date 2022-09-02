%lang starknet

from defences.library import DefenceQue, DefenceCosts

@contract_interface
namespace IDefences:
    func getQueStatus(caller : felt) -> (status : DefenceQue):
    end

    func getDefenceCost(caller : felt) -> (costs : DefenceCosts):
    end

    func rocketBuildStart(caller : felt, number_of_units : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func rocketBuildComplete(caller : felt) -> (unit_produced : felt):
    end

    func lightLaserBuildStart(caller : felt, number_of_units : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func lightLaserBuildComplete(caller : felt) -> (unit_produced : felt):
    end

    func heavyLaserBuildStart(caller : felt, number_of_units : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func heavyLaserBuildComplete(caller : felt) -> (unit_produced : felt):
    end

    func gaussBuildStart(caller : felt, number_of_units : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func gaussBuildComplete(caller : felt, number_of_units : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func plasmaTurretBuildStart(caller : felt, number_of_units : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func plasmaTurretBuildComplete(caller : felt) -> (units_produced : felt):
    end

    func smallDomeBuildStart(caller : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func smallDomeBuildComplete(caller : felt):
    end

    func largeDomeBuildStart(caller : felt) -> (
        metal : felt, crystal : felt, deuterium : felt, time_end : felt
    ):
    end

    func largeDomeBuildComplete(caller : felt):
    end
end
