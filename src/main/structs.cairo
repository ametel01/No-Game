const E18 = 10 ** 18

##########################################################################################
#                                               Structs                                  #
##########################################################################################

# @dev Stores the levels of the mines.
struct MineLevels:
    member metal : felt
    member crystal : felt
    member deuterium : felt
end

# @dev Stores the energy available.
struct Energy:
    member solar_plant : felt
    # member satellites : felt
end

# @dev The main planet struct.
struct Planet:
    member mines : MineLevels
    member energy : Energy
end

# @dev Used to handle costs.
struct Cost:
    member metal : felt
    member crystal : felt
    member deuterium : felt
    member energy_cost : felt
end

# @dev Stores the building on cue details
struct BuildingQue:
    member id : felt
    member lock_end : felt
end

struct ResearchQue:
    member tech_id : felt
    member lock_end : felt
end

struct TechLevels:
    member armour_tech : felt
    member astrophysics : felt
    member combustion_drive : felt
    member computer_tech : felt
    member energy_tech : felt
    member espionage_tech : felt
    member hyperspace_drive : felt
    member hyperspace_tech : felt
    member impulse_drive : felt
    member ion_tech : felt
    member laser_tech : felt
    member plasma_tech : felt
    member shielding_tech : felt
    member weapons_tech : felt
end

struct TechCosts:
    member armour_tech : Cost
    member astrophysics : Cost
    member combustion_drive : Cost
    member computer_tech : Cost
    member energy_tech : Cost
    member espionage_tech : Cost
    member hyperspace_drive : Cost
    member hyperspace_tech : Cost
    member impulse_drive : Cost
    member ion_tech : Cost
    member laser_tech : Cost
    member plasma_tech : Cost
    member shielding_tech : Cost
    member weapons_tech : Cost
end