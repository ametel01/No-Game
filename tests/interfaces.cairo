%lang starknet

from starkware.cairo.common.uint256 import Uint256
from main.structs import Cost, TechLevels, TechCosts
from resources.library import ResourcesQue
from shipyard.library import Fleet, ShipyardQue
from defences.library import Defence

@contract_interface
namespace NoGame:
    func getTokensAddresses() -> (
        erc721 : felt, erc20_metal : felt, erc20_crystal : felt, erc20_deuterium : felt
    ):
    end

    func getModulesAddresses() -> (
        _resources : felt, _facilities : felt, _shipyard : felt, _research : felt
    ):
    end

    func getResourcesBuildingsLevels() -> (
        metal_mine : felt, crystal_mine : felt, deuterium_mine : felt, solar_plant : felt
    ):
    end

    func getResourcesUpgradeCost() -> (
        metal_mine : Cost, crystal_mine : Cost, deuterium_mine : Cost, solar_plant : Cost
    ):
    end

    func getFacilitiesLevels() -> (
        robot_factory : felt, shipyard : felt, research_lab : felt, nanite_factory : felt
    ):
    end

    func getFacilitiesUpgradeCost() -> (
        robot_factory : Cost, shipyard : Cost, research_lab : Cost, nanite_factory : Cost
    ):
    end

    func getResourcesAvailable() -> (metal : felt, crystal : felt, deuterium : felt, energy : felt):
    end

    func getFleetLevels(address : felt) -> (levels : Fleet):
    end

    func getDefenceLevels(address : felt) -> (levels : Defence):
    end

    func getShipsCost() -> (
        cargo : Cost,
        recycler : Cost,
        espionage_probe : Cost,
        solar_satellite : Cost,
        light_fighter : Cost,
        cruiser : Cost,
        battleship : Cost,
    ):
    end

    func getTechLevels() -> (tech_levels : TechLevels):
    end

    func getTechUpgradeCost() -> (
        a : Cost,
        b : Cost,
        c : Cost,
        d : Cost,
        e : Cost,
        f : Cost,
        g : Cost,
        h : Cost,
        i : Cost,
        l : Cost,
        m : Cost,
        n : Cost,
        o : Cost,
        p : Cost,
    ):
    end

    func getResourcesQueStatus() -> (status : ResourcesQue):
    end

    func getShipyardQueStatus() -> (status : ShipyardQue):
    end

    func numberOfPlanets() -> (n_planets : felt):
    end

    func generatePlanet():
    end

    func collectResources():
    end

    func metalUpgradeStart():
    end

    func metalUpgradeComplete():
    end

    func crystalUpgradeStart():
    end

    func crystalUpgradeComplete():
    end

    func deuteriumUpgradeStart():
    end

    func deuteriumUpgradeComplete():
    end

    func solarUpgradeStart():
    end

    func solarUpgradeComplete():
    end

    func robotUpgradeStart():
    end

    func robotUpgradeComplete():
    end

    func shipyardUpgradeStart():
    end

    func shipyardUpgradeComplete():
    end

    func researchUpgradeStart():
    end

    func researchUpgradeComplete():
    end

    func naniteUpgradeStart():
    end

    func naniteUpgradeComplete():
    end

    func cargoShipBuildStart(units : felt):
    end

    func cargoShipBuildComplete():
    end

    func recyclerShipBuildStart(units : felt):
    end

    func recyclerShipBuildComplete():
    end

    func espionageProbeBuildStart(units : felt):
    end

    func espionageProbeBuildComplete():
    end

    func solarSatelliteBuildStart(units : felt):
    end

    func solarSatelliteBuildComplete():
    end

    func lightFighterBuildStart(units : felt):
    end

    func lightFighterBuildComplete():
    end

    func cruiserBuildStart(units : felt):
    end

    func cruiserBuildComplete():
    end

    func battleShipBuildStart(units : felt):
    end

    func battleShipBuildComplete():
    end

    func armourTechUpgradeStart():
    end

    func armourTechUpgradeComplete():
    end

    func astrophysicsUpgradeStart():
    end

    func astrophysicsUpgradeComplete():
    end

    func combustionDriveUpgradeStart():
    end

    func combustionDriveUpgradeComplete():
    end

    func computerTechUpgradeStart():
    end

    func computerTechUpgradeComplete():
    end

    func energyTechUpgradeStart():
    end

    func energyTechUpgradeComplete():
    end

    func espionageTechUpgradeStart():
    end

    func espionageTechUpgradeComplete():
    end

    func hyperspaceDriveUpgradeStart():
    end

    func hyperspaceDriveUpgradeComplete():
    end

    func hyperspaceTechUpgradeStart():
    end

    func hyperspaceTechUpgradeComplete():
    end

    func impulseDriveUpgradeStart():
    end

    func impulseDriveUpgradeComplete():
    end

    func ionTechUpgradeStart():
    end

    func ionTechUpgradeComplete():
    end

    func laserTechUpgradeStart():
    end

    func laserTechUpgradeComplete():
    end

    func plasmaTechUpgradeStart():
    end

    func plasmaTechUpgradeComplete():
    end

    func shieldingTechUpgradeStart():
    end

    func shieldingTechUpgradeComplete():
    end

    func weaponsTechUpgradeStart():
    end

    func weaponsTechUpgradeComplete():
    end

    func rocketBuildStart(units : felt):
    end

    func rocketBuildComplete():
    end

    func lightLaserBuildStart(units : felt):
    end

    func lightLaserBuildComplete():
    end

    func heavyLaserBuildStart(units : felt):
    end

    func heavyLaserBuildComplete():
    end

    func ionCannonBuildStart(units : felt):
    end

    func ionCannonBuildComplete():
    end

    func gaussBuildStart(units : felt):
    end

    func gaussBuildComplete():
    end

    func plasmaTurretBuildStart(units : felt):
    end

    func plasmaTurretBuildComplete():
    end

    func smallDomeBuildStart():
    end

    func smallDomeBuildComplete():
    end

    func largeDomeBuildStart():
    end

    func largeDomeBuildComplete():
    end
end

@contract_interface
namespace ERC721:
    func balanceOf(owner : felt) -> (balance : Uint256):
    end

    func ownerOf(tokenId : Uint256) -> (owner : felt):
    end

    func name() -> (res : felt):
    end

    func symbol() -> (res : felt):
    end

    func owner() -> (res : felt):
    end

    func tokenURI() -> (uri_len, uri):
    end

    func ownerToPlanet(owner : felt) -> (tokenId : Uint256):
    end

    func isApprovedForAll(owner : felt, operator : felt) -> (res : felt):
    end

    func transferFrom(from_ : felt, to : felt, tokenId : Uint256):
    end
end

@contract_interface
namespace Minter:
    func setNFTaddress(address : felt):
    end

    func setNFTapproval(operator : felt, approved : felt):
    end

    func mintAll(n : felt, token_id : Uint256):
    end
end

@contract_interface
namespace ERC20:
    func name() -> (name : felt):
    end

    func symbol() -> (symbol : felt):
    end

    func decimals() -> (decimals : felt):
    end

    func totalSupply() -> (totalSupply : Uint256):
    end

    func balanceOf(account : felt) -> (balance : Uint256):
    end

    func allowance(owner : felt, spender : felt) -> (remaining : Uint256):
    end

    func transfer(recipient : felt, amount : Uint256) -> (success : felt):
    end

    func transferFrom(sender : felt, recipient : felt, amount : Uint256) -> (success : felt):
    end

    func approve(spender : felt, amount : Uint256) -> (success : felt):
    end

    func mint(recipient : felt, amount : Uint256):
    end

    func burn(account : felt, amount : Uint256):
    end
end
