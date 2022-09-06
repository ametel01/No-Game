%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from defences.library import Defence
from facilities.IFacilities import IFacilities
from main.library import NoGame
from main.structs import Cost, TechLevels, TechCosts
from resources.IResources import IResources
from resources.library import ResourcesQue
from research.IResearchLab import IResearchLab
from research.library import ResearchQue
from shipyard.library import Fleet, ShipyardQue
from shipyard.IShipyard import IShipyard

#########################################################################################
#                                   Constructor                                         #
#########################################################################################

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, modules_manager : felt
):
    NoGame.initializer(owner, modules_manager)
    return ()
end

#########################################################################################
#                                       Getters                                         #
#########################################################################################

@view
func getTokensAddresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    erc721 : felt, erc20_metal : felt, erc20_crystal : felt, erc20_deuterium : felt
):
    let (erc721, metal, crystal, deuterium) = NoGame.tokens_addresses()
    return (erc721, metal, crystal, deuterium)
end

@view
func getModulesAddresses{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    _resources : felt, _facilities : felt, _shipyard : felt, _research : felt, _defences : felt
):
    let (resources, facilities, shipyard, research, defences) = NoGame.modules_addresses()
    return (resources, facilities, shipyard, research, defences)
end

@view
func numberOfPlanets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    n_planets : felt
):
    let (n) = NoGame.number_of_planets()
    return (n_planets=n)
end

@view
func getPlayerPoints{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (points : felt):
    let (points) = NoGame.player_points(caller)
    return (points)
end

@view
func getResourcesBuildingsLevels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal_mine : felt, crystal_mine : felt, deuterium_mine : felt, solar_plant : felt):
    let (metal, crystal, deuterium, solar_plant) = NoGame.resources_buildings_levels(caller)
    return (metal, crystal, deuterium, solar_plant)
end

@view
func getResourcesUpgradeCost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal_mine : Cost, crystal_mine : Cost, deuterium_mine : Cost, solar_plant : Cost):
    let (resources, _, _, _, _) = NoGame.modules_addresses()
    let (metal, crystal, deuterium, solar_plant) = IResources.getUpgradeCost(resources, caller)
    return (metal, crystal, deuterium, solar_plant)
end

@view
func getFacilitiesLevels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (robot_factory : felt, shipyard : felt, research_lab : felt, nanite_factory : felt):
    let (robot, shipyard, lab, nanite) = NoGame.facilities_levels(caller)
    return (robot, shipyard, lab, nanite)
end

@view
func getFacilitiesUpgradeCost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (robot_factory : Cost, shipyard : Cost, research_lab : Cost, nanite_factory : Cost):
    let (_, facilities, _, _, _) = NoGame.modules_addresses()
    let (robot, shipyard, research, nanite) = IFacilities.getUpgradeCost(facilities, caller)
    return (robot, shipyard, research, nanite)
end

@view
func getTechLevels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (result : TechLevels):
    let (res) = NoGame.tech_levels(caller)
    return (res)
end

@view
func getTechUpgradeCost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (
    armour_tech : Cost,
    astrophysics : Cost,
    combustion_drive : Cost,
    computer_tech : Cost,
    energy_tech : Cost,
    espionage_tech : Cost,
    hyperspace_drive : Cost,
    hyperspace_tech : Cost,
    impulse_drive : Cost,
    ion_tech : Cost,
    laser_tech : Cost,
    plasma_tech : Cost,
    shielding_tech : Cost,
    weapons_tech : Cost,
):
    let (_, _, _, lab, _) = NoGame.modules_addresses()
    let (costs : TechCosts) = IResearchLab.getUpgradesCost(lab, caller)
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
    )
end

@view
func getFleetLevels{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (result : Fleet):
    let (res) = NoGame.fleet_levels(caller)
    return (res)
end

@view
func getDefenceLevels{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> (res: Defence):
    let (res) = NoGame.defence_levels(caller)
    return (res,)
end


@view
func getShipsCost{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    cargo : Cost,
    recycler : Cost,
    espionage_probe : Cost,
    solar_satellite : Cost,
    light_fighter : Cost,
    cruiser : Cost,
    battleship : Cost,
):
    let (_, _, shipyard, _, _) = NoGame.modules_addresses()
    let (costs) = IShipyard.getShipsCost(shipyard)
    return (
        costs.cargo,
        costs.recycler,
        costs.espionage_probe,
        costs.solar_satellite,
        costs.light_fighter,
        costs.cruiser,
        costs.battle_ship,
    )
end

@view
func getResourcesAvailable{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (metal : felt, crystal : felt, deuterium : felt, energy : felt):
    let (
        metal_available, crystal_available, deuterium_available, energy_available
    ) = NoGame.resources_available(caller)
    return (metal_available, crystal_available, deuterium_available, energy_available)
end

@view
func getBuildingQueStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (status : ResourcesQue):
    let (status) = NoGame.resources_que(caller)
    return (status)
end

@view
func getShipyardQueStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (status : ShipyardQue):
    let (_, _, shipyard, _, _) = getModulesAddresses()
    let (que_details) = IShipyard.getQueStatus(shipyard, caller)
    return (que_details)
end

@view
func getResearchQueStatus{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    caller : felt
) -> (status : ResearchQue):
    let (_, _, _, lab, _) = getModulesAddresses()
    let (que_details) = IResearchLab.getQueStatus(lab, caller)
    return (que_details)
end

# ##########################################################################################
# #                                      Externals                                         #
# ##########################################################################################

@external
func generatePlanet{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (caller) = get_caller_address()
    NoGame.generate_planet(caller)
    return ()
end

@external
func collectResources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (caller) = get_caller_address()
    NoGame.collect_resources(caller)
    return ()
end

# ##############################################################################################
# #                                        RESOURCES                                           #
# ##############################################################################################

@external
func metalUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.metal_upgrade_start()
    return ()
end

@external
func metalUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.metal_upgrade_complete()
    return ()
end

@external
func crystalUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.crystal_upgrade_start()
    return ()
end

@external
func crystalUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.crystal_upgrade_complete()
    return ()
end

@external
func deuteriumUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.deuterium_upgrade_start()
    return ()
end

@external
func deuteriumUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.deuterium_upgrade_complete()
    return ()
end

@external
func solarUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.solar_upgrade_start()
    return ()
end

@external
func solarUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.solar_upgrade_complete()
    return ()
end

##############################################################################################
#                                   FACILITIES                                               #
##############################################################################################

@external
func robotUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.robot_upgrade_start()
    return ()
end

@external
func robotUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.robot_upgrade_complete()
    return ()
end

@external
func shipyardUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.shipyard_upgrade_start()
    return ()
end

@external
func shipyardUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.shipyard_upgrade_complete()
    return ()
end

@external
func researchUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.research_upgrade_start()
    return ()
end

@external
func researchUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.research_upgrade_complete()
    return ()
end

@external
func naniteUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.nanite_upgrade_start()
    return ()
end

@external
func naniteUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.nanite_upgrade_complete()
    return ()
end

#########################################################################################################
#                                           SHIPYARD                                                    #
#########################################################################################################

@external
func cargoShipBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    units : felt
):
    NoGame.cargo_ship_build_start(units)
    return ()
end

@external
func cargoShipBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.cargo_ship_build_complete()
    return ()
end

@external
func recyclerShipBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    units : felt
):
    NoGame.recycler_ship_build_start(units)
    return ()
end

@external
func recyclerShipBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.recycler_ship_build_complete()
    return ()
end

@external
func espionageProbeBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    units : felt
):
    NoGame.espionage_probe_build_start(units)
    return ()
end

@external
func espionageProbeBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.espionage_probe_build_complete()
    return ()
end

@external
func solarSatelliteBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    units : felt
):
    NoGame.solar_satellite_build_start(units)
    return ()
end

@external
func solarSatelliteBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.solar_satellite_build_complete()
    return ()
end

@external
func lightFighterBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    units : felt
):
    NoGame.light_fighter_build_start(units)
    return ()
end

@external
func lightFighterBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.light_fighter_build_complete()
    return ()
end

@external
func cruiserBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    units : felt
):
    NoGame.cruiser_build_start(units)
    return ()
end

@external
func cruiserBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.cruiser_build_complete()
    return ()
end

@external
func battleShipBuildStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    units : felt
):
    NoGame.battleship_build_start(units)
    return ()
end

@external
func battleShipBuildComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.battleship_build_complete()
    return ()
end

##############################################################################################
#                                          RESEARCH                                          #
##############################################################################################

@external
func armourTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.armour_tech_upgrade_start()
    return ()
end

@external
func armourTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.armour_tech_upgrade_complete()
    return ()
end

@external
func astrophysicsUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.astrophysics_upgrade_start()
    return ()
end

@external
func astrophysicsUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.astrophysics_tech_upgrade_complete()
    return ()
end

@external
func combustionDriveUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.combustion_drive_upgrade_start()
    return ()
end

@external
func combustionDriveUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    NoGame.combustion_drive_upgrade_complete()
    return ()
end

@external
func computerTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.computer_tech_upgrade_start()
    return ()
end

@external
func computerTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.computer_tech_upgrade_complete()
    return ()
end

@external
func energyTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.energy_tech_upgrade_start()
    return ()
end

@external
func energyTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.energy_tech_upgrade_complete()
    return ()
end

@external
func espionageTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.espionage_tech_upgrade_start()
    return ()
end

@external
func espionageTechUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    NoGame.espionage_tech_upgrade_complete()
    return ()
end

@external
func hyperspaceDriveUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.hyperspace_drive_upgrade_start()
    return ()
end

@external
func hyperspaceDriveUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    NoGame.hyperspace_drive_upgrade_complete()
    return ()
end

@external
func hyperspaceTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.hyperspace_tech_upgrade_start()
    return ()
end

@external
func hyperspaceTechUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    NoGame.hyperspace_tech_upgrade_complete()
    return ()
end

@external
func impulseDriveUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.impulse_drive_upgrade_start()
    return ()
end

@external
func impulseDriveUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.impulse_drive_upgrade_complete()
    return ()
end

@external
func ionTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.ion_tech_upgrade_start()
    return ()
end

@external
func ionTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.ion_tech_upgrade_complete()
    return ()
end

@external
func laserTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.laser_tech_upgrade_start()
    return ()
end

@external
func laserTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.laser_tech_upgrade_complete()
    return ()
end

@external
func plasmaTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.plasma_tech_upgrade_start()
    return ()
end

@external
func plasmaTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.plasma_tech_upgrade_complete()
    return ()
end

@external
func shieldingTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.shielding_tech_upgrade_start()
    return ()
end

@external
func shieldingTechUpgradeComplete{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    NoGame.shielding_tech_upgrade_complete()
    return ()
end

@external
func weaponsTechUpgradeStart{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    NoGame.weapons_tech_upgrade_start()
    return ()
end

@external
func weaponsTechUpgradeComplete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    NoGame.weapons_tech_upgrade_complete()
    return ()
end

##########################################################################################
#                                      DEFENCES                                          #
##########################################################################################

@external
func rocketBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
):
    NoGame.rocket_build_start(units)
    return ()
end

@external
func rocketBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.rocket_build_complete()
    return ()
end

@external
func lightLaserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
):
    NoGame.light_laser_build_start(units)
    return ()
end

@external
func lightLaserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.light_laser_build_complete()
    return ()
end

@external
func heavyLaserBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
):
    NoGame.heavy_laser_build_start(units)
    return ()
end

@external
func heavyLaserBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.heavy_laser_build_complete()
    return ()
end

@external
func ionCannonBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
):
    NoGame.ion_cannon_build_start(units)
    return ()
end

@external
func ionCannonBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.ion_cannon_build_complete()
    return ()
end

@external
func gaussBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(units: felt):
    NoGame.gauss_build_start(units)
    return ()
end

@external
func gaussBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.gauss_build_complete()
    return ()
end

@external
func plasmaTurretBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    units: felt
):
    NoGame.plasma_turret_build_start(units)
    return ()
end

@external
func plasmaTurretBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.plasma_turret_build_complete()
    return ()
end

@external
func smallDomeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.small_dome_build_start()
    return ()
end

@external
func smallDomeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.small_dome_build_complete()
    return ()
end

@external
func largeDomeBuildStart{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.large_dome_build_start()
    return ()
end

@external
func largeDomeBuildComplete{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    NoGame.large_dome_build_complete()
    return ()
end
