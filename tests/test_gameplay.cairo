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
const TIME = 36000
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

    _print_game_state(addresses)
    return ()
end
