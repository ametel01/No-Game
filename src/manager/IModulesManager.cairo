%lang starknet

@contract_interface
namespace IModulesManager:
    func getERC721Address() -> (address : felt):
    end

    func getModulesAddresses() -> (
        resources : felt, facilities : felt, shipyard : felt, research_lab : felt
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
