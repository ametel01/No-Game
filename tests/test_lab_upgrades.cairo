%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from research.library import (
    TechLevels,
    _energy_tech_upgrade_cost,
    _computer_tech_upgrade_cost,
    _laser_tech_upgrade_cost,
    _armour_tech_upgrade_cost,
    _espionage_tech_upgrade_cost,
    _ion_tech_upgrade_cost,
    _plasma_tech_upgrade_cost,
    _astrophysics_upgrade_cost,
    _weapons_tech_upgrade_cost,
    _shielding_tech_upgrade_cost,
    _hyperspace_tech_upgrade_cost,
    _combustion_drive_upgrade_cost,
    _impulse_drive_upgrade_cost,
    _hyperspace_drive_upgrade_cost,
)
from tests.setup import (
    Contracts,
    deploy_game,
    run_modules_manager,
    run_minter,
    time_warp,
    set_facilities_levels,
    set_resources_levels,
    set_tech_levels,
    reset_lab_timelock,
    reset_que,
)
from tests.interfaces import NoGame, ERC20
from utils.formulas import Formulas

@external
func test_base{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let addresses: Contracts = deploy_game();
    run_modules_manager(addresses);
    run_minter(addresses, 10);
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game);
    set_resources_levels(addresses, addresses.owner, 2000000000);
    set_facilities_levels(addresses.game, 1, 0, 0, 7, 0);

    let (prior_levels: TechLevels) = NoGame.getTechLevels(addresses.game, addresses.owner);
    assert prior_levels = TechLevels(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    set_tech_levels(addresses.game, 1, 0, 0, 0, 1, 8, 4, 0, 3, 3, 5, 10, 0, 5, 0);

    NoGame.armourTechUpgradeStart(addresses.game);
    time_warp(1000000, addresses.research);
    NoGame.armourTechUpgradeComplete(addresses.game);

    NoGame.astrophysicsUpgradeStart(addresses.game);
    time_warp(20000000, addresses.research);
    NoGame.astrophysicsUpgradeComplete(addresses.game);

    NoGame.combustionDriveUpgradeStart(addresses.game);
    time_warp(30000000, addresses.research);
    NoGame.combustionDriveUpgradeComplete(addresses.game);

    NoGame.computerTechUpgradeStart(addresses.game);
    time_warp(40000000, addresses.research);
    NoGame.computerTechUpgradeComplete(addresses.game);

    NoGame.energyTechUpgradeStart(addresses.game);
    time_warp(50000000, addresses.research);
    NoGame.energyTechUpgradeComplete(addresses.game);

    NoGame.espionageTechUpgradeStart(addresses.game);
    time_warp(60000000, addresses.research);
    NoGame.espionageTechUpgradeComplete(addresses.game);

    NoGame.hyperspaceDriveUpgradeStart(addresses.game);
    time_warp(70000000, addresses.research);
    NoGame.hyperspaceDriveUpgradeComplete(addresses.game);

    NoGame.hyperspaceTechUpgradeStart(addresses.game);
    time_warp(90000000, addresses.research);
    NoGame.hyperspaceTechUpgradeComplete(addresses.game);

    NoGame.impulseDriveUpgradeStart(addresses.game);
    time_warp(100000000, addresses.research);
    NoGame.impulseDriveUpgradeComplete(addresses.game);

    NoGame.ionTechUpgradeStart(addresses.game);
    time_warp(110000000, addresses.research);
    NoGame.ionTechUpgradeComplete(addresses.game);

    NoGame.laserTechUpgradeStart(addresses.game);
    time_warp(120000000, addresses.research);
    NoGame.laserTechUpgradeComplete(addresses.game);

    NoGame.plasmaTechUpgradeStart(addresses.game);
    time_warp(130000000, addresses.research);
    NoGame.plasmaTechUpgradeComplete(addresses.game);

    NoGame.shieldingTechUpgradeStart(addresses.game);
    time_warp(140000000, addresses.research);
    NoGame.shieldingTechUpgradeComplete(addresses.game);

    NoGame.weaponsTechUpgradeStart(addresses.game);
    time_warp(150000000, addresses.research);
    NoGame.weaponsTechUpgradeComplete(addresses.game);

    let (new_levels: TechLevels) = NoGame.getTechLevels(addresses.game, addresses.owner);
    // %{ print(ids.new_levels) %}
    assert new_levels.armour_tech = 1;
    assert new_levels.astrophysics = 1;
    assert new_levels.combustion_drive = 1;
    assert new_levels.computer_tech = 2;
    assert new_levels.energy_tech = 9;
    assert new_levels.espionage_tech = 5;
    assert new_levels.hyperspace_drive = 1;
    assert new_levels.hyperspace_tech = 4;
    assert new_levels.impulse_drive = 4;
    assert new_levels.ion_tech = 6;
    assert new_levels.laser_tech = 11;
    assert new_levels.plasma_tech = 1;
    assert new_levels.shielding_tech = 6;
    assert new_levels.weapons_tech = 1;

    return ();
}
