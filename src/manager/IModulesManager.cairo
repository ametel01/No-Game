%lang starknet

@contract_interface
namespace IModulesManager {
    func getERC721Address() -> (address: felt) {
    }

    func getModulesAddresses() -> (
        resources: felt, facilities: felt, shipyard: felt, research_lab: felt, defences: felt
    ) {
    }

    func getResourcesAddresses() -> (metal: felt, crystal: felt, deuterium: felt) {
    }

    func setERC721(address: felt) {
    }

    func setMetal(address: felt) {
    }

    func setCrystal(address: felt) {
    }

    func setDeuterium(address: felt) {
    }

    func setResources(address: felt) {
    }

    func setFacilities(address: felt) {
    }

    func setShipyard(address: felt) {
    }

    func setResearch(address: felt) {
    }

    func setDefences(address: felt) {
    }
}
