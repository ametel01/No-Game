%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256
from manager.IModulesManager import IModulesManager as Manager
from tests.interfaces import Minter, NoGame
from shipyard.library import Fleet

const E18 = 10 ** 18;
const ERC721_NAME = 0x4e6f47616d6520;
const ERC721_SYMBOL = 0x4f474d302e31;
const URI_LEN = 1;
const URI = 10101010;

const PK = 11111;
const PK2 = 22222;

const METAL_NAME = 0x6f67616d65206d6574616c2076302e31;
const METAL_SYMBOL = 0x4f674d455476302e31;

const CRYSTAL_NAME = 0x6f67616d65206372797374616c2076302e31;
const CRYSTAL_SYMBOL = 0x4f6743525976302e31;

const DEUTERIUM_NAME = 0x6f67616d652064657574657269756d2076302e31;
const DEUTERIUM_SYMBOL = 0x4f6744455576302e31;

struct Contracts {
    owner: felt,
    p1: felt,
    minter: felt,
    manager: felt,
    erc721: felt,
    game: felt,
    metal: felt,
    crystal: felt,
    deuterium: felt,
    resources: felt,
    facilities: felt,
    shipyard: felt,
    research: felt,
    defences: felt,
}

struct ClassHashes {
    resources: felt,
    facilities: felt,
    shipyard: felt,
    research: felt,
}

func deploy_game{syscall_ptr: felt*, range_check_ptr}() -> Contracts {
    tempvar contracts: Contracts;
    %{
        declared = declare("lib/openzeppelin/account/presets/Account.cairo")
        prepared = prepare(declared, [ids.PK])
        deploy(prepared)
        ids.contracts.owner = prepared.contract_address

        declared = declare("lib/openzeppelin/account/presets/Account.cairo")
        prepared = prepare(declared, [ids.PK2])
        deploy(prepared)
        ids.contracts.p1 = prepared.contract_address

        declared = declare("src/minter/erc721_minter.cairo")
        prepared = prepare(declared, [ids.contracts.owner])
        deploy(prepared)
        ids.contracts.minter = prepared.contract_address

        declared = declare("src/token/erc721/ERC721.cairo")
        prepared = prepare(declared, [ids.ERC721_NAME, ids.ERC721_SYMBOL, ids.contracts.minter, ids.URI_LEN, ids.URI])
        deploy(prepared)
        ids.contracts.erc721 = prepared.contract_address

        declared = declare("src/manager/ModulesManager.cairo")
        prepared = prepare(declared, [ids.contracts.owner])
        deploy(prepared)
        ids.contracts.manager = prepared.contract_address

        declared = declare("src/main/NoGame.cairo")
        prepared = prepare(declared, [ids.contracts.manager])
        deploy(prepared)
        ids.contracts.game = prepared.contract_address

        declared = declare("src/token/erc20/ERC20_Mintable_Burnable.cairo")
        prepared = prepare(declared, [ids.METAL_NAME, ids.METAL_SYMBOL, 18, 0, 0, ids.contracts.game, ids.contracts.game])
        deploy(prepared)
        ids.contracts.metal = prepared.contract_address

        declared = declare("src/token/erc20/ERC20_Mintable_Burnable.cairo")
        prepared = prepare(declared, [ids.CRYSTAL_NAME, ids.CRYSTAL_SYMBOL,18,  0, 0, ids.contracts.game, ids.contracts.game])
        deploy(prepared)
        ids.contracts.crystal = prepared.contract_address

        declared = declare("src/token/erc20/ERC20_Mintable_Burnable.cairo")
        prepared = prepare(declared, [ids.DEUTERIUM_NAME, ids.DEUTERIUM_SYMBOL,18, 0, 0,ids.contracts.game, ids.contracts.game])
        deploy(prepared)
        ids.contracts.deuterium = prepared.contract_address

        declared = declare("src/resources/Resources.cairo")
        prepared = prepare(declared, [ids.contracts.game])
        deploy(prepared)
        ids.contracts.resources = prepared.contract_address

        declared = declare("src/facilities/Facilities.cairo")
        prepared = prepare(declared, [ids.contracts.game])
        deploy(prepared)
        ids.contracts.facilities = prepared.contract_address

        declared = declare("src/shipyard/Shipyard.cairo")
        prepared = prepare(declared, [ids.contracts.game])
        deploy(prepared)
        ids.contracts.shipyard = prepared.contract_address

        declared = declare("src/research/ResearchLab.cairo")
        prepared = prepare(declared, [ids.contracts.game])
        deploy(prepared)
        ids.contracts.research = prepared.contract_address

        declared = declare("src/defences/Defences.cairo")
        prepared = prepare(declared, [ids.contracts.game])
        deploy(prepared)
        ids.contracts.defences = prepared.contract_address
    %}
    return contracts;
}

func run_modules_manager{syscall_ptr: felt*, range_check_ptr}(addresses: Contracts) {
    %{
        stop_prank_callable1 = start_prank(
                          ids.addresses.owner, target_contract_address=ids.addresses.manager)
    %}
    Manager.setERC721(addresses.manager, addresses.erc721);
    Manager.setMetal(addresses.manager, addresses.metal);
    Manager.setCrystal(addresses.manager, addresses.crystal);
    Manager.setDeuterium(addresses.manager, addresses.deuterium);

    Manager.setResources(addresses.manager, addresses.resources);
    Manager.setFacilities(addresses.manager, addresses.facilities);
    Manager.setShipyard(addresses.manager, addresses.shipyard);
    Manager.setResearch(addresses.manager, addresses.research);
    Manager.setDefences(addresses.manager, addresses.defences);
    return ();
}

func run_minter{syscall_ptr: felt*, range_check_ptr}(addresses: Contracts, n_planets: felt) {
    %{ stop_prank_callable2 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.minter) %}
    Minter.setNFTaddress(addresses.minter, addresses.erc721);
    Minter.setNFTapproval(addresses.minter, addresses.game, TRUE);
    Minter.mintAll(addresses.minter, n_planets, Uint256(1, 0));
    return ();
}

func _get_class_hashes{syscall_ptr: felt*, range_check_ptr}() -> (class_hashes: ClassHashes) {
    tempvar resources: felt;
    tempvar facilities: felt;
    tempvar shipyard: felt;
    tempvar research: felt;
    %{
        declared_resources = declare("src/resources/library.cairo")
               ids.resources = declared_resources

               declared_facilities = declare("src/facilities/library.cairo")
               ids.facilities = declared_facilities

               declared_shipyard = declare("src/shipyard/library.cairo")
               ids.shipyard = declared_shipyard

               declared_research = declare("src/research/library.cairo")
               ids.research = declared_facilities
    %}
    return (ClassHashes(resources, facilities, shipyard, research),);
}

func time_warp{syscall_ptr: felt*, range_check_ptr}(new_timestamp: felt, target: felt) {
    %{ stop_warp = warp(ids.new_timestamp, target_contract_address=ids.target) %}
    return ();
}

func warp_all{syscall_ptr: felt*, range_check_ptr}(new_timestamp: felt, addresses: Contracts) {
    %{
        stop_warp1 = warp(ids.new_timestamp, target_contract_address=ids.addresses.game)
        stop_warp2 = warp(ids.new_timestamp, target_contract_address=ids.addresses.resources)
        stop_warp3 = warp(ids.new_timestamp, target_contract_address=ids.addresses.facilities)
        stop_warp4 = warp(ids.new_timestamp, target_contract_address=ids.addresses.shipyard)
        stop_warp5 = warp(ids.new_timestamp, target_contract_address=ids.addresses.research)
    %}
    return ();
}

func _set_resource_levels{syscall_ptr: felt*, range_check_ptr}(
    resource, wallet: felt, amount: felt
) {
    %{
        store(ids.resource, "ERC20_total_supply", [ids.amount*ids.E18, 0])
        store(ids.resource, "ERC20_balances", [ids.amount*ids.E18, 0], key=[ids.wallet])
    %}
    return ();
}

func set_resources_levels{syscall_ptr: felt*, range_check_ptr}(
    addresses: Contracts, wallet: felt, amount: felt
) {
    %{
        store(ids.addresses.metal, "ERC20_total_supply", [ids.amount*ids.E18, 0])
        store(ids.addresses.metal, "ERC20_balances", [ids.amount*ids.E18, 0], key=[ids.wallet])

        store(ids.addresses.crystal, "ERC20_total_supply", [ids.amount*ids.E18, 0])
        store(ids.addresses.crystal, "ERC20_balances", [ids.amount*ids.E18, 0], key=[ids.wallet])

        store(ids.addresses.deuterium, "ERC20_total_supply", [ids.amount*ids.E18, 0])
        store(ids.addresses.deuterium, "ERC20_balances", [ids.amount*ids.E18, 0], key=[ids.wallet])
    %}
    return ();
}

func set_mines_levels{syscall_ptr: felt*, range_check_ptr}(
    game: felt, id: felt, m: felt, c: felt, d: felt, s: felt
) {
    %{
        store(ids.game, "NoGame_metal_mine_level", [ids.m], key=[ids.id,0])
        store(ids.game, "NoGame_crystal_mine_level", [ids.c], key=[ids.id,0])
        store(ids.game, "NoGame_deuterium_mine_level", [ids.d], key=[ids.id,0])
        store(ids.game, "NoGame_solar_plant_level", [ids.s], key=[ids.id,0])
    %}
    return ();
}

func set_facilities_levels{syscall_ptr: felt*, range_check_ptr}(
    game: felt, id: felt, robot: felt, shipyard: felt, research: felt, nanite: felt
) {
    %{
        store(ids.game, "NoGame_robot_factory_level", [ids.robot], key=[ids.id,0])
        store(ids.game, "NoGame_shipyard_level", [ids.shipyard], key=[ids.id,0])
        store(ids.game, "NoGame_research_lab_level", [ids.research], key=[ids.id,0])
        store(ids.game, "NoGame_nanite_factory_level", [ids.nanite], key=[ids.id,0])
    %}
    return ();
}

func set_tech_levels{syscall_ptr: felt*, range_check_ptr}(
    game: felt,
    id: felt,
    armour_tech: felt,
    astrophysics: felt,
    combustion_drive: felt,
    computer_tech: felt,
    energy_tech: felt,
    espionage_tech: felt,
    hyperspace_drive: felt,
    hyperspace_tech: felt,
    impulse_drive: felt,
    ion_tech: felt,
    laser_tech: felt,
    plasma_tech: felt,
    shielding_tech: felt,
    weapons_tech: felt,
) {
    %{
        store(ids.game, "NoGame_armour_tech", [ids.armour_tech], key=[ids.id,0])
        store(ids.game, "NoGame_astrophysics", [ids.astrophysics], key=[ids.id,0])
        store(ids.game, "NoGame_combustion_drive", [ids.combustion_drive], key=[ids.id,0])
        store(ids.game, "NoGame_computer_tech", [ids.computer_tech], key=[ids.id,0])
        store(ids.game, "NoGame_energy_tech", [ids.energy_tech], key=[ids.id,0])
        store(ids.game, "NoGame_espionage_tech", [ids.espionage_tech], key=[ids.id,0])
        store(ids.game, "NoGame_hyperspace_drive", [ids.hyperspace_drive], key=[ids.id,0])
        store(ids.game, "NoGame_hyperspace_tech", [ids.hyperspace_tech], key=[ids.id,0])
        store(ids.game, "NoGame_impulse_drive", [ids.impulse_drive], key=[ids.id,0])
        store(ids.game, "NoGame_ion_tech", [ids.ion_tech], key=[ids.id,0])
        store(ids.game, "NoGame_laser_tech", [ids.laser_tech], key=[ids.id,0])
        store(ids.game, "NoGame_plasma_tech", [ids.plasma_tech], key=[ids.id,0])
        store(ids.game, "NoGame_shielding_tech", [ids.shielding_tech], key=[ids.id,0])
        store(ids.game, "NoGame_weapons_tech", [ids.weapons_tech], key=[ids.id,0])
    %}
    return ();
}

func reset_buildings_timelock{syscall_ptr: felt*, range_check_ptr}(game_addr: felt) {
    %{ store(ids.game_addr, "NoGame_resources_que_status", [0,0], key=[1,0]) %}

    return ();
}

func reset_resources_timelock{syscall_ptr: felt*, range_check_ptr}(resources: felt, player: felt) {
    %{ store(ids.resources, "Resources_timelock", [0,0], key=[ids.player]) %}

    return ();
}

func reset_facilities_timelock{syscall_ptr: felt*, range_check_ptr}(
    facilities: felt, player: felt
) {
    %{ store(ids.facilities, "Facilities_timelock", [0,0], key=[ids.player]) %}

    return ();
}

func reset_shipyard_timelock{syscall_ptr: felt*, range_check_ptr}(shipyard: felt, player: felt) {
    %{ store(ids.shipyard, "Shipyard_timelock", [0,0,0], key=[ids.player]) %}

    return ();
}

func reset_lab_timelock{syscall_ptr: felt*, range_check_ptr}(lab: felt, player: felt) {
    %{ store(ids.research, "Research_timelock", [0,0], key=[ids.player]) %}

    return ();
}

func reset_que{syscall_ptr: felt*, range_check_ptr}(resources: felt, player: felt, id: felt) {
    %{ store(ids.resources, "Resources_timelock", [0], key=[ids.player, ids.id]) %}

    return ();
}

func get_expected_cost{syscall_ptr: felt*, range_check_ptr}(
    base_m: felt, base_c: felt, multiplier: felt, level: felt
) -> (metal: felt, crystal: felt) {
    tempvar metal: felt;
    tempvar crystal: felt;
    %{
        ids.metal = (ids.base_m * (ids.multiplier)**(ids.level)) // 10**ids.level
        ids.crystal = (ids.base_c * (ids.multiplier)**(ids.level)) // 10**ids.level
    %}
    return (metal, crystal);
}

func print_game_state{syscall_ptr: felt*, range_check_ptr}(addresses: Contracts) {
    let (m, c, d, s) = NoGame.getResourcesBuildingsLevels(addresses.game, addresses.owner);
    let (ro, sh, re, na) = NoGame.getFacilitiesLevels(addresses.game, addresses.owner);
    let (t) = NoGame.getTechLevels(addresses.game, addresses.owner);
    let (metal, crystal, deuterium, _) = NoGame.getResourcesAvailable(
        addresses.game, addresses.owner
    );
    let (f) = NoGame.getFleetLevels(addresses.game, addresses.owner);
    %{
        print(f"metal: {ids.metal/ids.E18}\tcrystal: {ids.crystal/ids.E18}\tdeuterium: {ids.deuterium/ids.E18}\n") 
        print(f"metal level: {ids.m}\tcrystal level: {ids.c}\tdeuterium level: {ids.d}\tsolar level: {ids.s}\n")
        print(f"robot level: {ids.ro}\tshipyard level: {ids.sh}\tresearch lab level: {ids.re}\tnanite level: {ids.na}\n")

        print(f"armour_tech: {ids.t.armour_tech}\tastrophysics: {ids.t.astrophysics}\tcombustion_drive: {ids.t.combustion_drive}")
        print(f"computer_tech : {ids.t.computer_tech }\tenergy_tech: {ids.t.energy_tech}\tespionage_tech: {ids.t.espionage_tech}")
        print(f"hyperspace_drive : {ids.t.hyperspace_drive }\thyperspace_tech: {ids.t.hyperspace_tech}\timpulse_drive: {ids.t.impulse_drive}")
        print(f"ion_tech : {ids.t.ion_tech }\tlaser_tech: {ids.t.laser_tech}\tplasma_tech: {ids.t.plasma_tech}")
        print(f"shielding_tech : {ids.t.shielding_tech }\tweapons_tech: {ids.t.weapons_tech}\n")

        print(f"cargo : {ids.f.cargo }\trecycler: {ids.f.recycler}\tespionage_probe: {ids.f.espionage_probe}")
        print(f"solar_satellite : {ids.f.solar_satellite }\tlight_fighter: {ids.f.light_fighter}\tcruiser: {ids.f.cruiser}")
        print(f"battle_ship: {ids.f.battle_ship}")
    %}

    return ();
}
