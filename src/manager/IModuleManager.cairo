%lang starknet

@contract_interface
namespace IModuleManager:
    func getERC721Address() -> (address : felt):
    end

    func getModulesAddresses() -> (
        robot_factory : felt, shipyard : felt, research_lab : felt, nanite_factory : felt
    ):
    end

    func getResourcesAddresses() -> (metal : felt, crystal : felt, deuterium : felt):
    end

    func setMetal(address : felt):
    end

    func setCrystal(address : felt):
    end

    func setDeuterium(address : felt):
    end

    func setResources(address : felt):
    end

    func setFacilities(address : felt):
    end

    func setResearch(address : felt):
    end
end
