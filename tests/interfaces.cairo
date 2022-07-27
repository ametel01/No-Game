%lang starknet

from starkware.cairo.common.uint256 import Uint256
from main.structs import Cost, TechLevels, TechCosts

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

    func getResourcesBuildingsLevels(caller : felt) -> (
        metal_mine : felt, crystal_mine : felt, deuterium_mine : felt, solar_plant : felt
    ):
    end

    func getResourcesUpgradeCost(caller : felt) -> (
        metal_mine : Cost, crystal_mine : Cost, deuterium_mine : Cost, solar_plant : Cost
    ):
    end

    func getFacilitiesLevels(caller : felt) -> (
        robot_factory : felt, shipyard : felt, research_lab : felt, nanite_factory : felt
    ):
    end

    func getFacilitiesUpgradeCost(caller : felt) -> (
        robot_factory : Cost, shipyard : Cost, research_lab : Cost, nanite_factory : Cost
    ):
    end

    func getTechLevels(caller : felt) -> (tech_levels : TechLevels):
    end

    func getTechUpgradeCost(caller : felt) -> (tech_costs : TechCosts):
    end

    func numberOfPlanets() -> (n_planets : felt):
    end

    func generatePlanet():
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
