%lang starknet

from starkware.cairo.common.uint256 import Uint256
from main.library import Cost
from resources.library import ResourcesQue
from research.library import TechLevels, TechCosts
from shipyard.library import ShipyardQue
from defences.library import Defence
from main.structs import Fleet, EspionageReport

@contract_interface
namespace NoGame {
    func getTokensAddresses() -> (
        erc721: felt, erc20_metal: felt, erc20_crystal: felt, erc20_deuterium: felt
    ) {
    }

    func getModulesAddresses() -> (
        _resources: felt,
        _facilities: felt,
        _shipyard: felt,
        _research: felt,
        _defences: felt,
        _fleet: felt,
    ) {
    }

    func getResourcesBuildingsLevels(caller: felt) -> (
        metal_mine: felt, crystal_mine: felt, deuterium_mine: felt, solar_plant: felt
    ) {
    }

    func getResourcesUpgradeCost(caller: felt) -> (
        metal_mine: Cost, crystal_mine: Cost, deuterium_mine: Cost, solar_plant: Cost
    ) {
    }

    func getFacilitiesLevels(caller: felt) -> (
        robot_factory: felt, shipyard: felt, research_lab: felt, nanite_factory: felt
    ) {
    }

    func getFacilitiesUpgradeCost(caller: felt) -> (
        robot_factory: Cost, shipyard: Cost, research_lab: Cost, nanite_factory: Cost
    ) {
    }

    func getResourcesAvailable(caller: felt) -> (
        metal: felt, crystal: felt, deuterium: felt, energy: felt
    ) {
    }

    func getFleetLevels(address: felt) -> (levels: Fleet) {
    }

    func getDefenceLevels(address: felt) -> (levels: Defence) {
    }

    func getShipsCost() -> (
        cargo: Cost,
        recycler: Cost,
        espionage_probe: Cost,
        solar_satellite: Cost,
        light_fighter: Cost,
        cruiser: Cost,
        battleship: Cost,
    ) {
    }

    func getTechLevels(caller: felt) -> (tech_levels: TechLevels) {
    }

    func getTechUpgradeCost(caller: felt) -> (
        a: Cost,
        b: Cost,
        c: Cost,
        d: Cost,
        e: Cost,
        f: Cost,
        g: Cost,
        h: Cost,
        i: Cost,
        l: Cost,
        m: Cost,
        n: Cost,
        o: Cost,
        p: Cost,
    ) {
    }

    func getBuildingQueStatus(caller: felt) -> (status: ResourcesQue) {
    }

    func getShipyardQueStatus(caller: felt) -> (status: ShipyardQue) {
    }

    func numberOfPlanets() -> (n_planets: felt) {
    }

    func generatePlanet() {
    }

    func collectResources() {
    }

    func metalUpgradeStart() {
    }

    func metalUpgradeComplete() {
    }

    func crystalUpgradeStart() {
    }

    func crystalUpgradeComplete() {
    }

    func deuteriumUpgradeStart() {
    }

    func deuteriumUpgradeComplete() {
    }

    func solarUpgradeStart() {
    }

    func solarUpgradeComplete() {
    }

    func robotUpgradeStart() {
    }

    func robotUpgradeComplete() {
    }

    func shipyardUpgradeStart() {
    }

    func shipyardUpgradeComplete() {
    }

    func researchUpgradeStart() {
    }

    func researchUpgradeComplete() {
    }

    func naniteUpgradeStart() {
    }

    func naniteUpgradeComplete() {
    }

    func cargoShipBuildStart(units: felt) {
    }

    func cargoShipBuildComplete() {
    }

    func recyclerShipBuildStart(units: felt) {
    }

    func recyclerShipBuildComplete() {
    }

    func espionageProbeBuildStart(units: felt) {
    }

    func espionageProbeBuildComplete() {
    }

    func solarSatelliteBuildStart(units: felt) {
    }

    func solarSatelliteBuildComplete() {
    }

    func lightFighterBuildStart(units: felt) {
    }

    func lightFighterBuildComplete() {
    }

    func cruiserBuildStart(units: felt) {
    }

    func cruiserBuildComplete() {
    }

    func battleShipBuildStart(units: felt) {
    }

    func battleShipBuildComplete() {
    }

    func armourTechUpgradeStart() {
    }

    func armourTechUpgradeComplete() {
    }

    func astrophysicsUpgradeStart() {
    }

    func astrophysicsUpgradeComplete() {
    }

    func combustionDriveUpgradeStart() {
    }

    func combustionDriveUpgradeComplete() {
    }

    func computerTechUpgradeStart() {
    }

    func computerTechUpgradeComplete() {
    }

    func energyTechUpgradeStart() {
    }

    func energyTechUpgradeComplete() {
    }

    func espionageTechUpgradeStart() {
    }

    func espionageTechUpgradeComplete() {
    }

    func hyperspaceDriveUpgradeStart() {
    }

    func hyperspaceDriveUpgradeComplete() {
    }

    func hyperspaceTechUpgradeStart() {
    }

    func hyperspaceTechUpgradeComplete() {
    }

    func impulseDriveUpgradeStart() {
    }

    func impulseDriveUpgradeComplete() {
    }

    func ionTechUpgradeStart() {
    }

    func ionTechUpgradeComplete() {
    }

    func laserTechUpgradeStart() {
    }

    func laserTechUpgradeComplete() {
    }

    func plasmaTechUpgradeStart() {
    }

    func plasmaTechUpgradeComplete() {
    }

    func shieldingTechUpgradeStart() {
    }

    func shieldingTechUpgradeComplete() {
    }

    func weaponsTechUpgradeStart() {
    }

    func weaponsTechUpgradeComplete() {
    }

    func rocketBuildStart(units: felt) {
    }

    func rocketBuildComplete() {
    }

    func lightLaserBuildStart(units: felt) {
    }

    func lightLaserBuildComplete() {
    }

    func heavyLaserBuildStart(units: felt) {
    }

    func heavyLaserBuildComplete() {
    }

    func ionCannonBuildStart(units: felt) {
    }

    func ionCannonBuildComplete() {
    }

    func gaussBuildStart(units: felt) {
    }

    func gaussBuildComplete() {
    }

    func plasmaTurretBuildStart(units: felt) {
    }

    func plasmaTurretBuildComplete() {
    }

    func smallDomeBuildStart() {
    }

    func smallDomeBuildComplete() {
    }

    func largeDomeBuildStart() {
    }

    func largeDomeBuildComplete() {
    }

    func sendEspionageMission(ships: Fleet, destination: Uint256) -> (mission_id: felt) {
    }

    func readEspionageReport(caller: felt, mission_id: felt) -> (res: EspionageReport) {
    }
}

@contract_interface
namespace ERC721 {
    func balanceOf(owner: felt) -> (balance: Uint256) {
    }

    func ownerOf(tokenId: Uint256) -> (owner: felt) {
    }

    func name() -> (res: felt) {
    }

    func symbol() -> (res: felt) {
    }

    func owner() -> (res: felt) {
    }

    func tokenURI() -> (uri_len: felt, uri: felt) {
    }

    func ownerToPlanet(owner: felt) -> (tokenId: Uint256) {
    }

    func isApprovedForAll(owner: felt, operator: felt) -> (res: felt) {
    }

    func transferFrom(from_: felt, to: felt, tokenId: Uint256) {
    }
}

@contract_interface
namespace Minter {
    func setNFTaddress(address: felt) {
    }

    func setNFTapproval(operator: felt, approved: felt) {
    }

    func mintAll(n: felt, token_id: Uint256) {
    }
}

@contract_interface
namespace ERC20 {
    func name() -> (name: felt) {
    }

    func symbol() -> (symbol: felt) {
    }

    func decimals() -> (decimals: felt) {
    }

    func totalSupply() -> (totalSupply: Uint256) {
    }

    func balanceOf(account: felt) -> (balance: Uint256) {
    }

    func allowance(owner: felt, spender: felt) -> (remaining: Uint256) {
    }

    func transfer(recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func transferFrom(sender: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func approve(spender: felt, amount: Uint256) -> (success: felt) {
    }

    func mint(recipient: felt, amount: Uint256) {
    }

    func burn(account: felt, amount: Uint256) {
    }
}
