%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256
from manager.IModulesManager import IModulesManager as Manager

const ERC721_NAME = 0x4e6f47616d6520
const ERC721_SYMBOL = 0x4f474d302e31
const URI_LEN = 1
const URI = 10101010

const PK = 11111

const METAL_NAME = 0x6f67616d65206d6574616c2076302e31
const METAL_SYMBOL = 0x4f674d455476302e31

const CRYSTAL_NAME = 0x6f67616d65206372797374616c2076302e31
const CRYSTAL_SYMBOL = 0x4f6743525976302e31

const DEUTERIUM_NAME = 0x6f67616d652064657574657269756d2076302e31
const DEUTERIUM_SYMBOL = 0x4f6744455576302e31

@external
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    %{
        context.owner_address = deploy_contract("lib/cairo_contracts_git/cairo_contracts/src/openzeppelin/account/Account.cairo", [ids.PK]).contract_address
        context.erc721_address = deploy_contract("src/token/erc721/ERC721.cairo",[ids.ERC721_NAME, ids.ERC721_SYMBOL, context.owner_address, ids.URI_LEN, ids.URI]).contract_address
        context.manager_address = deploy_contract("src/manager/ModulesManager.cairo", [context.owner_address]).contract_address
        context.game_address = deploy_contract("src/main/NoGame.cairo", [context.owner_address, context.manager_address]).contract_address
        context.metal_address = deploy_contract("src/token/erc20/ERC20_Mintable_Burnable.cairo", [ids.METAL_NAME, ids.METAL_SYMBOL, 18, 0, 0, context.game_address, context.game_address]).contract_address
        context.crystal_address = deploy_contract("src/token/erc20/ERC20_Mintable_Burnable.cairo", [ids.CRYSTAL_NAME, ids.CRYSTAL_SYMBOL,18,  0, 0, context.game_address, context.game_address]).contract_address
        context.deuterium_address = deploy_contract("src/token/erc20/ERC20_Mintable_Burnable.cairo", [ids.DEUTERIUM_NAME, ids.DEUTERIUM_SYMBOL,18, 0, 0,context.game_address, context.game_address]).contract_address
        context.resources_address = deploy_contract("src/resources/Resources.cairo", [context.game_address]).contract_address
        context.facilities_address = deploy_contract("src/facilities/Facilities.cairo", [context.game_address]).contract_address
        context.shipyard_address = deploy_contract("src/shipyard/Shipyard.cairo", [context.game_address]).contract_address
        context.research_address = deploy_contract("src/research/ResearchLab.cairo", [context.game_address]).contract_address
    %}
    return ()
end

@external
func test_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    tempvar owner : felt
    tempvar manager : felt
    tempvar erc721 : felt
    tempvar game : felt
    tempvar metal : felt
    tempvar crystal : felt
    tempvar deuterium : felt
    tempvar resources : felt
    tempvar shipyard : felt
    tempvar facilities : felt
    tempvar research : felt
    %{
        ids.owner = context.owner_address
        ids.manager = context.manager_address
        ids.erc721 = context.erc721_address
        ids.game = context.game_address
        ids.metal = context.metal_address
        ids.crystal = context.crystal_address
        ids.deuterium = context.deuterium_address
        ids.resources = context.resources_address
        ids.shipyard = context.shipyard_address
        ids.facilities = context.facilities_address
        ids.research = context.research_address

        stop_prank_callable = start_prank(ids.owner, target_contract_address=ids.manager)
    %}
    Manager.setERC721(manager, erc721)
    Manager.setMetal(manager, metal)
    Manager.setCrystal(manager, crystal)
    Manager.setDeuterium(manager, deuterium)
    let (registered_erc721) = Manager.getERC721Address(manager)
    let (reg_metal, reg_crystal, reg_deuterium) = Manager.getResourcesAddresses(manager)
    assert registered_erc721 = erc721
    assert reg_metal = metal
    assert reg_crystal = crystal
    assert reg_deuterium = deuterium

    Manager.setResources(manager, resources)
    Manager.setFacilities(manager, facilities)
    Manager.setShipyard(manager, shipyard)
    Manager.setResearch(manager, research)
    let (_resources, _facilities, _shipyard, _research) = Manager.getModulesAddresses(manager)
    assert _resources = resources
    assert _facilities = facilities
    assert _shipyard = shipyard
    assert _research = research
    return ()
end
