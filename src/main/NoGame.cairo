%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_check
from starkware.starknet.common.syscalls import get_caller_address
from defences.library import Defence
from facilities.IFacilities import IFacilities
from fleet_movements.IFleetMovements import IFleetMovements
from main.library import NoGame
from resources.IResources import IResources
from research.IResearchLab import IResearchLab
from main.structs import (
    FleetQue,
    Cost,
    ResearchQue,
    TechLevels,
    TechCosts,
    ResourcesQue,
    Fleet,
    ShipyardQue,
    EspionageReport,
)
from shipyard.IShipyard import IShipyard

//########################################################################################
//                                   Constructor                                         #
//########################################################################################

// Initialize the contract writing the addresses of the owner and
// the module manager to storage.
// @param modules_manager: the address of the contract responsible setting.
// the modules addresses.
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    modules_manager: felt
) {
    NoGame.initializer(modules_manager);
    return ();
}

//########################################################################################
//                                       Getters                                         #
//########################################################################################

// Gets the addresses of the games tokens.
// @return ERC721 address, ERC20 addresses for metal, crystal, deuterium.
@view
func getTokensAddresses{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    erc721: felt, erc20_metal: felt, erc20_crystal: felt, erc20_deuterium: felt
) {
    let (erc721, metal, crystal, deuterium) = NoGame.tokens_addresses();
    return (erc721, metal, crystal, deuterium);
}

// Gets the address of the game modules.
// @return the addresses of the game's module currently in use.
@view
func getModulesAddresses{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    _resources: felt,
    _facilities: felt,
    _shipyard: felt,
    _research: felt,
    _defences: felt,
    _fleet: felt,
) {
    let (resources, facilities, shipyard, research, defences, fleet) = NoGame.modules_addresses();

    return (resources, facilities, shipyard, research, defences, fleet);
}

// Gets the total number of planets currently in the game.
// @return number of planets.
@view
func numberOfPlanets{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    n_planets: felt
) {
    let (n) = NoGame.number_of_planets();
    return (n_planets=n);
}

// Gets the points of the player (1 point every 1000 metal or crystal spent).
// @param caller the address of the player we are quering.
// @return points.
@view
func getPlayerPoints{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (points: felt) {
    let (points) = NoGame.player_points(caller);
    return (points,);
}

// Gets the level of the resources producing buildings.
// @param caller the address of the player we are quering.
// @return level of metal, crystal, deuterium mines + solar_plant level.
@view
func getResourcesBuildingsLevels{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal_mine: felt, crystal_mine: felt, deuterium_mine: felt, solar_plant: felt) {
    let (metal, crystal, deuterium, solar_plant) = NoGame.resources_buildings_levels(caller);
    return (metal, crystal, deuterium, solar_plant);
}

// Gets the cost of the next upgrade for each resources building.
// @param caller the address of the player we are quering.
// @return the cost of type Cost for each building.
@view
func getResourcesUpgradeCost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal_mine: Cost, crystal_mine: Cost, deuterium_mine: Cost, solar_plant: Cost) {
    let (resources, _, _, _, _, _) = NoGame.modules_addresses();
    let (metal, crystal, deuterium, solar_plant) = IResources.getUpgradeCost(resources, caller);
    return (metal, crystal, deuterium, solar_plant);
}

// Gets the level of each facilitel building.
// @param caller the address of the player we are quering.
// @return the level for robot factory, shiyard, research lab, nanite factory.
@view
func getFacilitiesLevels{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (robot_factory: felt, shipyard: felt, research_lab: felt, nanite_factory: felt) {
    let (robot, shipyard, lab, nanite) = NoGame.facilities_levels(caller);
    return (robot, shipyard, lab, nanite);
}

@view
func getFacilitiesUpgradeCost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (robot_factory: Cost, shipyard: Cost, research_lab: Cost, nanite_factory: Cost) {
    let (_, facilities, _, _, _, _) = NoGame.modules_addresses();
    let (robot, shipyard, research, nanite) = IFacilities.getUpgradeCost(facilities, caller);
    return (robot, shipyard, research, nanite);
}

@view
func getTechLevels{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (result: TechLevels) {
    let (res) = NoGame.tech_levels(caller);
    return (res,);
}

@view
func getTechUpgradeCost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (
    armour_tech: Cost,
    astrophysics: Cost,
    combustion_drive: Cost,
    computer_tech: Cost,
    energy_tech: Cost,
    espionage_tech: Cost,
    hyperspace_drive: Cost,
    hyperspace_tech: Cost,
    impulse_drive: Cost,
    ion_tech: Cost,
    laser_tech: Cost,
    plasma_tech: Cost,
    shielding_tech: Cost,
    weapons_tech: Cost,
) {
    let (_, _, _, lab, _, _) = NoGame.modules_addresses();
    let (costs: TechCosts) = IResearchLab.getUpgradesCost(lab, caller);
    return (
        costs.armour_tech,
        costs.astrophysics,
        costs.combustion_drive,
        costs.computer_tech,
        costs.energy_tech,
        costs.espionage_tech,
        costs.hyperspace_drive,
        costs.hyperspace_tech,
        costs.impulse_drive,
        costs.ion_tech,
        costs.laser_tech,
        costs.plasma_tech,
        costs.shielding_tech,
        costs.weapons_tech,
    );
}

@view
func getFleetLevels{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (result: Fleet) {
    let (res) = NoGame.fleet_levels(caller);
    return (res,);
}

@view
func getDefenceLevels{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (res: Defence) {
    let (res) = NoGame.defence_levels(caller);
    return (res,);
}

@view
func getShipsCost{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    cargo: Cost,
    recycler: Cost,
    espionage_probe: Cost,
    solar_satellite: Cost,
    light_fighter: Cost,
    cruiser: Cost,
    battleship: Cost,
) {
    let (_, _, shipyard, _, _, _) = NoGame.modules_addresses();
    let (costs) = IShipyard.getShipsCost(shipyard);
    return (
        costs.cargo,
        costs.recycler,
        costs.espionage_probe,
        costs.solar_satellite,
        costs.light_fighter,
        costs.cruiser,
        costs.battle_ship,
    );
}

@view
func getResourcesAvailable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (metal: felt, crystal: felt, deuterium: felt, energy: felt) {
    let (
        metal_available, crystal_available, deuterium_available, energy_available
    ) = NoGame.resources_available(caller);
    return (metal_available, crystal_available, deuterium_available, energy_available);
}

@view
func getBuildingQueStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (status: ResourcesQue) {
    let (status) = NoGame.resources_que(caller);
    return (status,);
}

@view
func getShipyardQueStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (status: ShipyardQue) {
    let (_, _, shipyard, _, _, _) = getModulesAddresses();
    let (que_details) = IShipyard.getQueStatus(shipyard, caller);
    return (que_details,);
}

@view
func getResearchQueStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (status: ResearchQue) {
    let (_, _, _, lab, _, _) = getModulesAddresses();
    let (que_details) = IResearchLab.getQueStatus(lab, caller);
    return (que_details,);
}

@view
func getFleetMovementsQueStatus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, mission_id: felt
) -> (res: FleetQue) {
    let (_, _, _, _, _, fleet) = getModulesAddresses();
    let (que_details) = IFleetMovements.getQueStatus(fleet, caller, mission_id);
    return (que_details,);
}

// ##########################################################################################
// #                                      Externals                                         #
// ##########################################################################################

@external
func generatePlanet{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    NoGame.generate_planet(caller);
    return ();
}

@external
func collectResources{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    NoGame.collect_resources(caller);
    return ();
}

// ##############################################################################################
// #                               RESOURCES EXTERNALS FUNCS                                    #
// ##############################################################################################

@external
func metalUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.metal_upgrade_start();
    return ();
}

@external
func metalUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.metal_upgrade_complete();
    return ();
}

@external
func crystalUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.crystal_upgrade_start();
    return ();
}

@external
func crystalUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.crystal_upgrade_complete();
    return ();
}

@external
func deuteriumUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.deuterium_upgrade_start();
    return ();
}

@external
func deuteriumUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.deuterium_upgrade_complete();
    return ();
}

@external
func solarUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.solar_upgrade_start();
    return ();
}

@external
func solarUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.solar_upgrade_complete();
    return ();
}

//#############################################################################################
//                              FACILITIES UPGRADES FUNCS                                     #
//#############################################################################################

@external
func robotUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.robot_upgrade_start();
    return ();
}

@external
func robotUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.robot_upgrade_complete();
    return ();
}

@external
func shipyardUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.shipyard_upgrade_start();
    return ();
}

@external
func shipyardUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.shipyard_upgrade_complete();
    return ();
}

@external
func researchUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.research_upgrade_start();
    return ();
}

@external
func researchUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.research_upgrade_complete();
    return ();
}

@external
func naniteUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.nanite_upgrade_start();
    return ();
}

@external
func naniteUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.nanite_upgrade_complete();
    return ();
}

//########################################################################################################
//                                           SHIPYARD FUNCTIONS                                          #
//########################################################################################################

@external
func cargoShipBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.cargo_ship_build_start(units);
    return ();
}

@external
func cargoShipBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.cargo_ship_build_complete();
    return ();
}

@external
func recyclerShipBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.recycler_ship_build_start(units);
    return ();
}

@external
func recyclerShipBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.recycler_ship_build_complete();
    return ();
}

@external
func espionageProbeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.espionage_probe_build_start(units);
    return ();
}

@external
func espionageProbeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.espionage_probe_build_complete();
    return ();
}

@external
func solarSatelliteBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.solar_satellite_build_start(units);
    return ();
}

@external
func solarSatelliteBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.solar_satellite_build_complete();
    return ();
}

@external
func lightFighterBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.light_fighter_build_start(units);
    return ();
}

@external
func lightFighterBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.light_fighter_build_complete();
    return ();
}

@external
func cruiserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.cruiser_build_start(units);
    return ();
}

@external
func cruiserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.cruiser_build_complete();
    return ();
}

@external
func battleShipBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.battleship_build_start(units);
    return ();
}

@external
func battleShipBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.battleship_build_complete();
    return ();
}

//#############################################################################################
//                              RESEARCH UPGRADES FUNCTIONS                                      #
//#############################################################################################

@external
func armourTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.armour_tech_upgrade_start();
    return ();
}

@external
func armourTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.armour_tech_upgrade_complete();
    return ();
}

@external
func astrophysicsUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.astrophysics_upgrade_start();
    return ();
}

@external
func astrophysicsUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.astrophysics_tech_upgrade_complete();
    return ();
}

@external
func combustionDriveUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.combustion_drive_upgrade_start();
    return ();
}

@external
func combustionDriveUpgradeComplete{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    NoGame.combustion_drive_upgrade_complete();
    return ();
}

@external
func computerTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.computer_tech_upgrade_start();
    return ();
}

@external
func computerTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.computer_tech_upgrade_complete();
    return ();
}

@external
func energyTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.energy_tech_upgrade_start();
    return ();
}

@external
func energyTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.energy_tech_upgrade_complete();
    return ();
}

@external
func espionageTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.espionage_tech_upgrade_start();
    return ();
}

@external
func espionageTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.espionage_tech_upgrade_complete();
    return ();
}

@external
func hyperspaceDriveUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.hyperspace_drive_upgrade_start();
    return ();
}

@external
func hyperspaceDriveUpgradeComplete{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    NoGame.hyperspace_drive_upgrade_complete();
    return ();
}

@external
func hyperspaceTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.hyperspace_tech_upgrade_start();
    return ();
}

@external
func hyperspaceTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.hyperspace_tech_upgrade_complete();
    return ();
}

@external
func impulseDriveUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.impulse_drive_upgrade_start();
    return ();
}

@external
func impulseDriveUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.impulse_drive_upgrade_complete();
    return ();
}

@external
func ionTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.ion_tech_upgrade_start();
    return ();
}

@external
func ionTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.ion_tech_upgrade_complete();
    return ();
}

@external
func laserTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.laser_tech_upgrade_start();
    return ();
}

@external
func laserTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.laser_tech_upgrade_complete();
    return ();
}

@external
func plasmaTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.plasma_tech_upgrade_start();
    return ();
}

@external
func plasmaTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.plasma_tech_upgrade_complete();
    return ();
}

@external
func shieldingTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.shielding_tech_upgrade_start();
    return ();
}

@external
func shieldingTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    NoGame.shielding_tech_upgrade_complete();
    return ();
}

@external
func weaponsTechUpgradeStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.weapons_tech_upgrade_start();
    return ();
}

@external
func weaponsTechUpgradeComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.weapons_tech_upgrade_complete();
    return ();
}

@external
func rocketBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.rocket_build_start(units);
    return ();
}

@external
func rocketBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.rocket_build_complete();
    return ();
}

@external
func lightLaserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.light_laser_build_start(units);
    return ();
}

@external
func lightLaserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.light_laser_build_complete();
    return ();
}

@external
func heavyLaserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.heavy_laser_build_start(units);
    return ();
}

@external
func heavyLaserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.heavy_laser_build_complete();
    return ();
}

@external
func ionCannonBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.ion_cannon_build_start(units);
    return ();
}

@external
func ionCannonBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.ion_cannon_build_complete();
    return ();
}

@external
func gaussBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(units: felt) {
    NoGame.gauss_build_start(units);
    return ();
}

@external
func gaussBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.gauss_build_complete();
    return ();
}

@external
func plasmaTurretBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
) {
    NoGame.plasma_turret_build_start(units);
    return ();
}

@external
func plasmaTurretBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.plasma_turret_build_complete();
    return ();
}

@external
func smallDomeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.small_dome_build_start();
    return ();
}

@external
func smallDomeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.small_dome_build_complete();
    return ();
}

@external
func largeDomeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.large_dome_build_start();
    return ();
}

@external
func largeDomeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    NoGame.large_dome_build_complete();
    return ();
}

//#############################################################################################
//                              FLEET MOVEMENTS FUNCTIONS                                     #
//#############################################################################################

@external
func sendEspionageMission{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ships: Fleet, destination: Uint256
) -> (mission_id: felt) {
    uint256_check(destination);
    let mission_id = NoGame.send_spy_mission(ships, destination);
    return (mission_id,);
}

@external
func readEspionageReport{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, mission_id: felt
) -> (res: EspionageReport) {
    let res = NoGame.read_espionage_report(caller, mission_id);
    return (res,);
}
