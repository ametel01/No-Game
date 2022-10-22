%lang starknet

struct BuildingQue {
    id: felt,
    lock_end: felt,
}

struct Cost {
    metal: felt,
    crystal: felt,
    deuterium: felt,
    energy_cost: felt,
}

struct DefenceQue {
    defence_id: felt,
    units: felt,
    lock_end: felt,
}

struct DefenceCosts {
    rocket: Cost,
    light_laser: Cost,
    heavy_laser: Cost,
    ion_cannon: Cost,
    gauss: Cost,
    plasma_turette: Cost,
    small_dome: Cost,
    large_dome: Cost,
}

struct Defence {
    rocket: felt,
    light_laser: felt,
    heavy_laser: felt,
    ion_cannon: felt,
    gauss: felt,
    plasma_turret: felt,
    small_dome: felt,
    large_dome: felt,
}

struct FacilitiesQue {
    facility_id: felt,
    lock_end: felt,
}

struct Fleet {
    cargo: felt,
    recycler: felt,
    espionage_probe: felt,
    solar_satellite: felt,
    light_fighter: felt,
    cruiser: felt,
    battle_ship: felt,
    death_star: felt,
}

struct ResearchQue {
    tech_id: felt,
    lock_end: felt,
}

struct ResourcesQue {
    building_id: felt,
    lock_end: felt,
}

struct ShipsCosts {
    cargo: Cost,
    recycler: Cost,
    espionage_probe: Cost,
    solar_satellite: Cost,
    light_fighter: Cost,
    cruiser: Cost,
    battle_ship: Cost,
}

struct ShipyardQue {
    ship_id: felt,
    units: felt,
    lock_end: felt,
}

struct TechCosts {
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
}

struct TechLevels {
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
}

//
// FLEET MOVEMENTS
//

struct ResourcesBuildings {
    metal_mine: felt,
    crystal_mine: felt,
    deuterium_mine: felt,
    solar_plant: felt,
}

struct FacilitiesBuildings {
    robot_factory: felt,
    shipyard: felt,
    research_lab: felt,
    nanite: felt,
}

struct PlanetResources {
    metal: felt,
    crystal: felt,
    deuterium: felt,
}

struct FleetQue {
    planet_id: felt,
    mission_id: felt,
    time_end: felt,
    destination: felt,
}

struct EspionageReport {
    resources_available: PlanetResources,
    resources_buildings: ResourcesBuildings,
    fleet: Fleet,
    facilities: FacilitiesBuildings,
    research: TechLevels,
}
