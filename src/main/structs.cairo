const E18 = 10 ** 18;

//#########################################################################################
//                                               Structs                                  #
//#########################################################################################

// @dev Stores the levels of the mines.
struct MineLevels {
    metal: felt,
    crystal: felt,
    deuterium: felt,
}

// @dev Stores the energy available.
struct Energy {
    solar_plant: felt,
    // member satellites : felt
}

// @dev The main planet struct.
struct Planet {
    mines: MineLevels,
    energy: Energy,
}

// @dev Used to handle costs.
struct Cost {
    metal: felt,
    crystal: felt,
    deuterium: felt,
    energy_cost: felt,
}

// @dev Stores the building on cue details
struct BuildingQue {
    id: felt,
    lock_end: felt,
}

struct ResearchQue {
    tech_id: felt,
    lock_end: felt,
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
