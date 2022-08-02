%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from research.library import (
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
from tests.conftest import (
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
    _set_facilities_levels,
    _set_tech_levels,
    _reset_lab_timelock,
    _reset_que,
)
from tests.interfaces import NoGame, ERC20
from utils.formulas import Formulas
from main.structs import TechLevels

@external
func test_base{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game)

    let (current_levels : Fleet) = NoGame.getFleetLevels(addresses.game, addresses.owner)
    assert current_levels = Fleet(0, 0, 0, 0, 0, 0, 0, 0)
