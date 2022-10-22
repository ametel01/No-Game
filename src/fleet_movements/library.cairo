%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.math import (
    abs_value,
    assert_not_zero,
    sqrt,
    unsigned_div_rem,
    assert_lt_felt,
    assert_le_felt,
)
from starkware.cairo.common.math_cmp import is_not_zero, is_nn
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_block_timestamp
from shipyard.ships_performance import FleetPerformance
from main.INoGame import INoGame
from main.storage import NoGame_max_slots
from main.structs import (
    PlanetResources,
    ResourcesBuildings,
    FacilitiesBuildings,
    Fleet,
    TechLevels,
    FleetQue,
    EspionageReport,
)
from token.erc721.interfaces.IERC721 import IERC721

const SCALER = 10 ** 9;

@storage_var
func FleetMovements_no_game_address() -> (address: felt) {
}

@storage_var
func FleetMovements_que_details(planet_id: Uint256, mission_id: felt) -> (res: FleetQue) {
}

@storage_var
func FleetMovements_active_missions(planet_id: Uint256) -> (res: felt) {
}

namespace FleetMovements {
    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        no_game_address: felt
    ) {
        FleetMovements_no_game_address.write(no_game_address);
        return ();
    }

    func get_que_status{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: felt, mission_id: felt
    ) -> FleetQue {
        let planet_id = get_planet_id(caller);
        let (res) = FleetMovements_que_details.read(planet_id, mission_id);
        return res;
    }

    func send_spy_mission{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: felt, ships: Fleet, destination: Uint256
    ) -> felt {
        alloc_locals;
        check_fleet_composition(caller, ships);
        let planet_id = get_planet_id(caller);
        let distance = calculate_distance(planet_id.low, destination.low);
        let speed = calculate_speed(ships);
        let travel_time = calculate_travel_time(distance, speed);
        let mission_id = set_fleet_que(planet_id, destination, travel_time);
        return (mission_id);
    }

    func read_espionage_report{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: felt, mission_id: felt
    ) -> EspionageReport {
        alloc_locals;
        let planet_id = get_planet_id(caller);
        let (que_details) = FleetMovements_que_details.read(planet_id, mission_id);
        check_timelock_expired(que_details);
        let destination = Uint256(que_details.destination, 0);
        let espionage_difference = get_espionage_power_difference(planet_id, destination);
        reduce_active_missions(planet_id);

        if (espionage_difference == 0) {
            return spy_report_0(planet_id, destination);
        }
        if (espionage_difference == 1) {
            return spy_report_1(planet_id, destination);
        }
        if (espionage_difference == 2) {
            return spy_report_2(planet_id, destination);
        }
        if (espionage_difference == 3) {
            return spy_report_3(planet_id, destination);
        }
        if (espionage_difference == 4) {
            return spy_report_4(planet_id, destination);
        } else {
            return spy_report_5(planet_id, destination);
        }
    }
}

func check_fleet_composition{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, ships: Fleet
) {
    let (game) = FleetMovements_no_game_address.read();
    let (fleet_available) = INoGame.getFleetLevels(game, caller);

    // Checks that no solar satellite are part of the fleet sent to mission.
    with_attr error_message("FLEET MOVEMENTS::Solar satellite can not be sent on mission") {
        assert_lt_felt(ships.solar_satellite, 1);
    }

    with_attr error_message("FLEET MOVEMENTS::Not enough cargo ships available") {
        assert_le_felt(ships.cargo, fleet_available.cargo);
    }

    with_attr error_message("FLEET MOVEMENTS::Not enough recycler ships available") {
        assert_le_felt(ships.recycler, fleet_available.recycler);
    }

    with_attr error_message("FLEET MOVEMENTS::Not enough espionage probes available") {
        assert_le_felt(ships.espionage_probe, fleet_available.espionage_probe);
    }

    with_attr error_message("FLEET MOVEMENTS::Not enough light fighters available") {
        assert_le_felt(ships.light_fighter, fleet_available.light_fighter);
    }

    with_attr error_message("FLEET MOVEMENTS::Not enough cruisers available") {
        assert_le_felt(ships.cruiser, fleet_available.cruiser);
    }

    with_attr error_message("FLEET MOVEMENTS::Not enough battleships available") {
        assert_le_felt(ships.battle_ship, fleet_available.battle_ship);
    }

    with_attr error_message("FLEET MOVEMENTS::Not enough death star available") {
        assert_le_felt(ships.death_star, fleet_available.death_star);
    }
    return ();
}

func get_owners_from_planet_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256
) -> felt {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (res) = IERC721.ownerOf(erc721, planet_id);
    return res;
}

func get_espionage_power_difference{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(planet_id: Uint256, destination: Uint256) -> felt {
    alloc_locals;
    let attacker_addr = get_owners_from_planet_id(planet_id);
    let target_addr = get_owners_from_planet_id(destination);
    let (game) = FleetMovements_no_game_address.read();
    let (target_tech_levels: TechLevels) = INoGame.getTechLevels(game, target_addr);
    let target_espionage_level = target_tech_levels.espionage_tech;

    let target_fleet: Fleet = INoGame.getFleetLevels(game, target_addr);
    let target_probes_num = target_fleet.espionage_probe;
    let target_espionage_power = target_espionage_level * target_probes_num;

    let (attacker_tech_level: TechLevels) = INoGame.getTechLevels(game, attacker_addr);
    let attacker_espionage_level = attacker_tech_level.espionage_tech;
    let attacker_fleet: Fleet = INoGame.getFleetLevels(game, attacker_addr);
    let attacker_probes_num = attacker_fleet.espionage_probe;
    let attacker_espionage_power = attacker_espionage_level * attacker_probes_num;

    let diff = attacker_espionage_power - target_espionage_power;
    let cond_1 = is_nn(diff);
    let cond_2 = is_not_zero(diff);
    if (cond_1 * cond_2 == FALSE) {
        return 0;
    } else {
        return diff;
    }
}

func calculate_distance{range_check_ptr}(p1_position: felt, p2_position: felt) -> felt {
    let zero_check_1 = is_not_zero(p1_position);
    let zero_check_2 = is_not_zero(p2_position);
    if (zero_check_1 * zero_check_2 == FALSE) {
        return 0;
    }

    let fact1 = abs_value(p2_position - p1_position);
    let distance = 1000 + 5 * fact1;
    return distance;
}

func calculate_travel_time{range_check_ptr}(distance: felt, speed: felt) -> felt {
    let (fact1, _) = unsigned_div_rem(SCALER * distance, speed);
    let fact2 = sqrt(fact1);
    let (res, _) = unsigned_div_rem(fact2, 2);
    return res;
}

func calculate_fuel_consumption{range_check_ptr}(ships: Fleet, distance: felt) -> felt {
    alloc_locals;
    let cargo_consumption = get_ship_consumption(
        ships.cargo, FleetPerformance.Cargo.fuel_consumption, distance
    );
    let recycler_consumption = get_ship_consumption(
        ships.recycler, FleetPerformance.Recycler.fuel_consumption, distance
    );
    let probe_consumption = get_ship_consumption(
        ships.espionage_probe, FleetPerformance.EspionageProbe.fuel_consumption, distance
    );
    let fighter_consumption = get_ship_consumption(
        ships.light_fighter, FleetPerformance.LightFighter.fuel_consumption, distance
    );
    let cruiser_consumption = get_ship_consumption(
        ships.cruiser, FleetPerformance.Cruiser.fuel_consumption, distance
    );
    let bs_consumption = get_ship_consumption(
        ships.battle_ship, FleetPerformance.BattleShip.fuel_consumption, distance
    );
    let death_consumption = get_ship_consumption(
        ships.death_star, FleetPerformance.Deathstar.fuel_consumption, distance
    );

    return cargo_consumption + recycler_consumption + probe_consumption + fighter_consumption + cruiser_consumption + bs_consumption + death_consumption;
}

func get_ship_consumption{range_check_ptr}(n_ships: felt, base_cost: felt, distance: felt) -> felt {
    alloc_locals;
    let cond = is_not_zero(n_ships);
    if (cond == TRUE) {
        let consumption = fuel_consumption_formula(base_cost, distance);
        return consumption * n_ships;
    } else {
        return 0;
    }
}

func fuel_consumption_formula{range_check_ptr}(base_cost: felt, distance: felt) -> felt {
    alloc_locals;
    let fact1 = base_cost * distance;
    let (fact2, _) = unsigned_div_rem(fact1, 3500);
    let res = fact2 + 1;
    return res;
}

func calculate_speed{range_check_ptr}(fleet: Fleet) -> felt {
    let cond_1 = is_not_zero(fleet.death_star);
    if (cond_1 == TRUE) {
        return FleetPerformance.Deathstar.base_speed;
    }

    let cond_2 = is_not_zero(fleet.recycler);
    if (cond_2 == TRUE) {
        return FleetPerformance.Recycler.base_speed;
    }

    let cond_3 = is_not_zero(fleet.cargo);
    if (cond_3 == TRUE) {
        return FleetPerformance.Cargo.base_speed;
    }

    let cond_4 = is_not_zero(fleet.battle_ship);
    if (cond_4 == TRUE) {
        return FleetPerformance.BattleShip.base_speed;
    }

    let cond_5 = is_not_zero(fleet.light_fighter);
    if (cond_5 == TRUE) {
        return FleetPerformance.LightFighter.base_speed;
    }

    let cond_6 = is_not_zero(fleet.cruiser);
    if (cond_6 == TRUE) {
        return FleetPerformance.Cruiser.base_speed;
    } else {
        return FleetPerformance.EspionageProbe.base_speed;
    }
}

func check_timelock_expired{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    que_details: FleetQue
) {
    let (time_now) = get_block_timestamp();
    with_attr error_message("FLEET MOVEMENTS::Timelock not yet expired") {
        let time_end = que_details.time_end;
        assert_lt_felt(time_end, time_now);
    }
    return ();
}

func get_planet_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt
) -> Uint256 {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (planet_id) = IERC721.ownerToPlanet(erc721, caller);
    return planet_id;
}

func reduce_active_missions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256
) {
    let (active_missions) = FleetMovements_active_missions.read(planet_id);
    FleetMovements_active_missions.write(planet_id, active_missions - 1);
    return ();
}

func set_fleet_que{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    starting_planet: Uint256, destination: Uint256, travel_time: felt
) -> felt {
    let (time_now) = get_block_timestamp();
    let time_end = time_now + travel_time;
    let (active_missions) = FleetMovements_active_missions.read(starting_planet);
    let new_que_point = FleetQue(
        planet_id=starting_planet.low,
        mission_id=active_missions + 1,
        time_end=time_end,
        destination=destination.low,
    );
    let sender_addr = get_owners_from_planet_id(starting_planet);
    FleetMovements_que_details.write(starting_planet, active_missions + 1, new_que_point);
    FleetMovements_active_missions.write(starting_planet, active_missions + 1);
    return (active_missions + 1);
}

func spy_report_0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256, destination: Uint256
) -> EspionageReport {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (target_addr) = IERC721.ownerOf(erc721, destination);
    let (attacker_addr) = IERC721.ownerOf(erc721, planet_id);
    let (
        metal_available, crystal_available, deuterium_available, _
    ) = INoGame.getResourcesAvailable(game, target_addr);
    let planet_resources = PlanetResources(metal_available, crystal_available, deuterium_available);
    let report = EspionageReport(
        PlanetResources(0, 0, 0),
        ResourcesBuildings(0, 0, 0, 0),
        Fleet(0, 0, 0, 0, 0, 0, 0, 0),
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    return report;
}

func spy_report_1{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256, destination: Uint256
) -> EspionageReport {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (target_addr) = IERC721.ownerOf(erc721, destination);
    let (attacker_addr) = IERC721.ownerOf(erc721, planet_id);
    let (
        metal_available, crystal_available, deuterium_available, _
    ) = INoGame.getResourcesAvailable(game, target_addr);
    let planet_resources = PlanetResources(metal_available, crystal_available, deuterium_available);
    let report = EspionageReport(
        planet_resources,
        ResourcesBuildings(0, 0, 0, 0),
        Fleet(0, 0, 0, 0, 0, 0, 0, 0),
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    return report;
}

func spy_report_2{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256, destination: Uint256
) -> EspionageReport {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (target_addr) = IERC721.ownerOf(erc721, destination);
    let (attacker_addr) = IERC721.ownerOf(erc721, planet_id);
    let (
        metal_available, crystal_available, deuterium_available, _
    ) = INoGame.getResourcesAvailable(game, target_addr);
    let planet_resources = PlanetResources(metal_available, crystal_available, deuterium_available);
    let (
        metal_level, crystal_level, deuterium_level, solar_plant_level
    ) = INoGame.getResourcesBuildingsLevels(game, target_addr);
    let resources_buildings = ResourcesBuildings(
        metal_level, crystal_level, deuterium_level, solar_plant_level
    );

    let report = EspionageReport(
        planet_resources,
        resources_buildings,
        Fleet(0, 0, 0, 0, 0, 0, 0, 0),
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    return report;
}

func spy_report_3{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256, destination: Uint256
) -> EspionageReport {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (target_addr) = IERC721.ownerOf(erc721, destination);
    let (attacker_addr) = IERC721.ownerOf(erc721, planet_id);
    let (
        metal_available, crystal_available, deuterium_available, _
    ) = INoGame.getResourcesAvailable(game, target_addr);
    let planet_resources = PlanetResources(metal_available, crystal_available, deuterium_available);
    let (
        metal_level, crystal_level, deuterium_level, solar_plant_level
    ) = INoGame.getResourcesBuildingsLevels(game, target_addr);
    let resources_buildings = ResourcesBuildings(
        metal_level, crystal_level, deuterium_level, solar_plant_level
    );
    let (fleet_on_the_planet) = INoGame.getFleetLevels(game, target_addr);
    let fleet = fleet_on_the_planet;
    let report = EspionageReport(
        planet_resources,
        resources_buildings,
        fleet_on_the_planet,
        FacilitiesBuildings(0, 0, 0, 0),
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    return report;
}

func spy_report_4{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256, destination: Uint256
) -> EspionageReport {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (target_addr) = IERC721.ownerOf(erc721, destination);
    let (attacker_addr) = IERC721.ownerOf(erc721, planet_id);
    let (
        metal_available, crystal_available, deuterium_available, _
    ) = INoGame.getResourcesAvailable(game, target_addr);
    let planet_resources = PlanetResources(metal_available, crystal_available, deuterium_available);
    let (
        metal_level, crystal_level, deuterium_level, solar_plant_level
    ) = INoGame.getResourcesBuildingsLevels(game, target_addr);
    let resources_buildings = ResourcesBuildings(
        metal_level, crystal_level, deuterium_level, solar_plant_level
    );
    let (fleet_on_the_planet) = INoGame.getFleetLevels(game, target_addr);
    let fleet = fleet_on_the_planet;
    let (robot, shipyard, lab, nanite) = INoGame.getFacilitiesLevels(game, target_addr);
    let facilities = FacilitiesBuildings(robot, shipyard, lab, nanite);
    let report = EspionageReport(
        planet_resources,
        resources_buildings,
        fleet_on_the_planet,
        facilities,
        TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    return report;
}

func spy_report_5{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    planet_id: Uint256, destination: Uint256
) -> EspionageReport {
    let (game) = FleetMovements_no_game_address.read();
    let (erc721, _, _, _) = INoGame.getTokensAddresses(game);
    let (target_addr) = IERC721.ownerOf(erc721, destination);
    let (attacker_addr) = IERC721.ownerOf(erc721, planet_id);
    let (
        metal_available, crystal_available, deuterium_available, _
    ) = INoGame.getResourcesAvailable(game, target_addr);
    let planet_resources = PlanetResources(metal_available, crystal_available, deuterium_available);
    let (
        metal_level, crystal_level, deuterium_level, solar_plant_level
    ) = INoGame.getResourcesBuildingsLevels(game, target_addr);
    let resources_buildings = ResourcesBuildings(
        metal_level, crystal_level, deuterium_level, solar_plant_level
    );
    let (fleet_on_the_planet) = INoGame.getFleetLevels(game, target_addr);
    let fleet = fleet_on_the_planet;
    let (robot, shipyard, lab, nanite) = INoGame.getFacilitiesLevels(game, target_addr);
    let facilities = FacilitiesBuildings(robot, shipyard, lab, nanite);
    let (tech_on_planet) = INoGame.getTechLevels(game, target_addr);
    let tech_levels = tech_on_planet;
    let report = EspionageReport(
        planet_resources, resources_buildings, fleet_on_the_planet, facilities, tech_levels
    );
    return report;
}
