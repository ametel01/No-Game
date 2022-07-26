%lang starknet

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
func __setup__{syscall_ptr : felt*, range_check_ptr}():
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

func _run_modules_manager{syscall_ptr : felt*, range_check_ptr}(
    _manager : felt,
    _erc721 : felt,
    _metal : felt,
    _crystal : felt,
    _deuterium : felt,
    _resources : felt,
    _facilities : felt,
    _shipyard : felt,
    _research : felt,
):
    Manager.setERC721(_manager, _erc721)
    Manager.setMetal(_manager, _metal)
    Manager.setCrystal(_manager, _crystal)
    Manager.setDeuterium(_manager, _deuterium)

    Manager.setResources(_manager, _resources)
    Manager.setFacilities(_manager, _facilities)
    Manager.setShipyard(_manager, _shipyard)
    Manager.setResearch(_manager, _research)
    return ()
end

func _get_test_addresses{syscall_ptr : felt*, range_check_ptr}() -> (
    owner : felt,
    manager : felt,
    erc721 : felt,
    game : felt,
    metal : felt,
    crystal : felt,
    deuterium : felt,
    resources : felt,
    facilities : felt,
    shipyard : felt,
    research : felt,
):
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
    return (
        owner,
        manager,
        erc721,
        game,
        metal,
        crystal,
        deuterium,
        resources,
        shipyard,
        facilities,
        research,
    )
end
