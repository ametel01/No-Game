%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from main.structs import Cost, TechLevels, TechCosts
from utils.formulas import Formulas
from tests.conftest import (
    E18,
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _set_mines_levels,
    _warp_all,
    _print_game_state,
)
const TIME = 360000
from tests.interfaces import NoGame, ERC721, ERC20

@external
func test_game{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    %{ stop_prank_callable1 = start_prank(ids.addresses.owner, target_contract_address=ids.addresses.game) %}
    NoGame.generatePlanet(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 2, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 3, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 4, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 5, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 6, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 7, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _warp_all(TIME * 8, addresses)
    NoGame.crystalUpgradeComplete(addresses.game)

    _warp_all(TIME * 9, addresses)
    NoGame.collectResources(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 10, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 11, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _warp_all(TIME * 12, addresses)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _warp_all(TIME * 13, addresses)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 14, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _warp_all(TIME * 15, addresses)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _warp_all(TIME * 16, addresses)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 17, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 18, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 19, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 20, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _warp_all(TIME * 21, addresses)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _warp_all(TIME * 22, addresses)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 23, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _warp_all(TIME * 24, addresses)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _warp_all(TIME * 25, addresses)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 26, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _warp_all(TIME * 27, addresses)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.robotUpgradeStart(addresses.game)
    _warp_all(TIME * 28, addresses)
    NoGame.robotUpgradeComplete(addresses.game)

    NoGame.robotUpgradeStart(addresses.game)
    _warp_all(TIME * 29, addresses)
    NoGame.robotUpgradeComplete(addresses.game)

    NoGame.researchUpgradeStart(addresses.game)
    _warp_all(TIME * 30, addresses)
    NoGame.researchUpgradeComplete(addresses.game)

    NoGame.shipyardUpgradeStart(addresses.game)
    _warp_all(TIME * 31, addresses)
    NoGame.shipyardUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _warp_all(TIME * 32, addresses)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.shipyardUpgradeStart(addresses.game)
    _warp_all(TIME * 33, addresses)
    NoGame.shipyardUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 34, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _warp_all(TIME * 35, addresses)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 36, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.energyTechUpgradeStart(addresses.game)
    _warp_all(TIME * 37, addresses)
    NoGame.energyTechUpgradeComplete(addresses.game)

    NoGame.combustionDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 38, addresses)
    NoGame.combustionDriveUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _warp_all(TIME * 39, addresses)
    NoGame.solarUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _warp_all(TIME * 40, addresses)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.metalUpgradeStart(addresses.game)
    _warp_all(TIME * 41, addresses)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.combustionDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 42, addresses)
    NoGame.combustionDriveUpgradeComplete(addresses.game)

    NoGame.cargoShipBuildStart(addresses.game, 1)
    _warp_all(TIME * 43, addresses)
    NoGame.cargoShipBuildComplete(addresses.game)

    NoGame.combustionDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 44, addresses)
    NoGame.combustionDriveUpgradeComplete(addresses.game)

    NoGame.combustionDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 45, addresses)
    NoGame.combustionDriveUpgradeComplete(addresses.game)

    NoGame.combustionDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 46, addresses)
    NoGame.combustionDriveUpgradeComplete(addresses.game)

    NoGame.combustionDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 47, addresses)
    NoGame.combustionDriveUpgradeComplete(addresses.game)

    NoGame.shipyardUpgradeStart(addresses.game)
    _warp_all(TIME * 48, addresses)
    NoGame.shipyardUpgradeComplete(addresses.game)

    NoGame.shipyardUpgradeStart(addresses.game)
    _warp_all(TIME * 49, addresses)
    NoGame.shipyardUpgradeComplete(addresses.game)

    NoGame.researchUpgradeStart(addresses.game)
    _warp_all(TIME * 50, addresses)
    NoGame.researchUpgradeComplete(addresses.game)

    NoGame.researchUpgradeStart(addresses.game)
    _warp_all(TIME * 51, addresses)
    NoGame.researchUpgradeComplete(addresses.game)

    NoGame.researchUpgradeStart(addresses.game)
    _warp_all(TIME * 52, addresses)
    NoGame.researchUpgradeComplete(addresses.game)

    NoGame.researchUpgradeStart(addresses.game)
    _warp_all(TIME * 53, addresses)
    NoGame.researchUpgradeComplete(addresses.game)

    NoGame.researchUpgradeStart(addresses.game)
    _warp_all(TIME * 54, addresses)
    NoGame.researchUpgradeComplete(addresses.game)

    NoGame.energyTechUpgradeStart(addresses.game)
    _warp_all(TIME * 55, addresses)
    NoGame.energyTechUpgradeComplete(addresses.game)

    NoGame.energyTechUpgradeStart(addresses.game)
    _warp_all(TIME * 56, addresses)
    NoGame.energyTechUpgradeComplete(addresses.game)

    NoGame.energyTechUpgradeStart(addresses.game)
    _warp_all(TIME * 57, addresses)
    NoGame.energyTechUpgradeComplete(addresses.game)

    NoGame.shieldingTechUpgradeStart(addresses.game)
    _warp_all(TIME * 58, addresses)
    NoGame.shieldingTechUpgradeComplete(addresses.game)

    NoGame.shieldingTechUpgradeStart(addresses.game)
    _warp_all(TIME * 59, addresses)
    NoGame.shieldingTechUpgradeComplete(addresses.game)

    NoGame.recyclerShipBuildStart(addresses.game, 1)
    _warp_all(TIME * 60, addresses)
    NoGame.recyclerShipBuildComplete(addresses.game)

    NoGame.espionageTechUpgradeStart(addresses.game)
    _warp_all(TIME * 61, addresses)
    NoGame.espionageTechUpgradeComplete(addresses.game)

    NoGame.espionageTechUpgradeStart(addresses.game)
    _warp_all(TIME * 62, addresses)
    NoGame.espionageTechUpgradeComplete(addresses.game)

    NoGame.espionageProbeBuildStart(addresses.game, 1)
    _warp_all(TIME * 63, addresses)
    NoGame.espionageProbeBuildComplete(addresses.game)

    NoGame.solarSatelliteBuildStart(addresses.game, 1)
    _warp_all(TIME * 64, addresses)
    NoGame.solarSatelliteBuildComplete(addresses.game)

    NoGame.lightFighterBuildStart(addresses.game, 1)
    _warp_all(TIME * 65, addresses)
    NoGame.lightFighterBuildComplete(addresses.game)

    NoGame.laserTechUpgradeStart(addresses.game)
    _warp_all(TIME * 66, addresses)
    NoGame.laserTechUpgradeComplete(addresses.game)

    NoGame.laserTechUpgradeStart(addresses.game)
    _warp_all(TIME * 67, addresses)
    NoGame.laserTechUpgradeComplete(addresses.game)

    NoGame.laserTechUpgradeStart(addresses.game)
    _warp_all(TIME * 68, addresses)
    NoGame.laserTechUpgradeComplete(addresses.game)

    NoGame.laserTechUpgradeStart(addresses.game)
    _warp_all(TIME * 69, addresses)
    NoGame.laserTechUpgradeComplete(addresses.game)

    NoGame.laserTechUpgradeStart(addresses.game)
    _warp_all(TIME * 70, addresses)
    NoGame.laserTechUpgradeComplete(addresses.game)

    NoGame.ionTechUpgradeStart(addresses.game)
    _warp_all(TIME * 71, addresses)
    NoGame.ionTechUpgradeComplete(addresses.game)

    NoGame.ionTechUpgradeStart(addresses.game)
    _warp_all(TIME * 72, addresses)
    NoGame.ionTechUpgradeComplete(addresses.game)

    NoGame.impulseDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 73, addresses)
    NoGame.impulseDriveUpgradeComplete(addresses.game)

    NoGame.impulseDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 74, addresses)
    NoGame.impulseDriveUpgradeComplete(addresses.game)

    NoGame.impulseDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 75, addresses)
    NoGame.impulseDriveUpgradeComplete(addresses.game)

    NoGame.impulseDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 76, addresses)
    NoGame.impulseDriveUpgradeComplete(addresses.game)

    NoGame.shipyardUpgradeStart(addresses.game)
    _warp_all(TIME * 77, addresses)
    NoGame.shipyardUpgradeComplete(addresses.game)

    NoGame.cruiserBuildStart(addresses.game, 1)
    _warp_all(TIME * 78, addresses)
    NoGame.cruiserBuildComplete(addresses.game)

    NoGame.shipyardUpgradeStart(addresses.game)
    _warp_all(TIME * 79, addresses)
    NoGame.shipyardUpgradeComplete(addresses.game)

    NoGame.shipyardUpgradeStart(addresses.game)
    _warp_all(TIME * 80, addresses)
    NoGame.shipyardUpgradeComplete(addresses.game)

    NoGame.energyTechUpgradeStart(addresses.game)
    _warp_all(TIME * 81, addresses)
    NoGame.energyTechUpgradeComplete(addresses.game)

    NoGame.shieldingTechUpgradeStart(addresses.game)
    _warp_all(TIME * 82, addresses)
    NoGame.shieldingTechUpgradeComplete(addresses.game)

    NoGame.shieldingTechUpgradeStart(addresses.game)
    _warp_all(TIME * 83, addresses)
    NoGame.shieldingTechUpgradeComplete(addresses.game)

    NoGame.shieldingTechUpgradeStart(addresses.game)
    _warp_all(TIME * 84, addresses)
    NoGame.shieldingTechUpgradeComplete(addresses.game)

    NoGame.researchUpgradeStart(addresses.game)
    _warp_all(TIME * 85, addresses)
    NoGame.researchUpgradeComplete(addresses.game)

    NoGame.hyperspaceTechUpgradeStart(addresses.game)
    _warp_all(TIME * 86, addresses)
    NoGame.hyperspaceTechUpgradeComplete(addresses.game)

    NoGame.hyperspaceTechUpgradeStart(addresses.game)
    _warp_all(TIME * 87, addresses)
    NoGame.hyperspaceTechUpgradeComplete(addresses.game)

    NoGame.hyperspaceTechUpgradeStart(addresses.game)
    _warp_all(TIME * 88, addresses)
    NoGame.hyperspaceTechUpgradeComplete(addresses.game)

    NoGame.hyperspaceDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 89, addresses)
    NoGame.hyperspaceDriveUpgradeComplete(addresses.game)

    NoGame.hyperspaceDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 90, addresses)
    NoGame.hyperspaceDriveUpgradeComplete(addresses.game)

    NoGame.collectResources(addresses.game)

    NoGame.hyperspaceDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 91, addresses)
    NoGame.hyperspaceDriveUpgradeComplete(addresses.game)

    NoGame.hyperspaceDriveUpgradeStart(addresses.game)
    _warp_all(TIME * 92, addresses)
    NoGame.hyperspaceDriveUpgradeComplete(addresses.game)

    NoGame.battleShipBuildStart(addresses.game, 1)
    _warp_all(TIME * 93, addresses)
    NoGame.battleShipBuildComplete(addresses.game)

    _print_game_state(addresses)
    return ()
end
