%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from facilities.library import (
    _robot_factory_upgrade_cost,
    _shipyard_upgrade_cost,
    _research_lab_upgrade_cost,
    _nanite_factory_upgrade_cost,
)
from tests.conftest import (
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
    _set_mines_levels,
    _set_resource_levels,
    _reset_timelock,
    _reset_que,
)
from tests.interfaces import NoGame, ERC20
from utils.formulas import Formulas
from facilities.library import (
    FacilitiesQue,
    ROBOT_FACTORY_ID,
    SHIPYARD_ID,
    RESEARCH_LAB_ID,
    NANITE_FACTORY_ID,
)

@external
func test_upgrade_facilities_base{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game)
    let (prev_robot, prev_shipyard, prev_lab, prev_nanite) = NoGame.getFacilitiesLevels(
        addresses.game, addresses.owner
    )
    let (robot, shipyard, lab, nanite) = NoGame.getFacilitiesUpgradeCost(
        addresses.game, addresses.owner
    )
    _set_resource_levels(addresses.metal, addresses.owner, robot.metal)
    _set_resource_levels(addresses.crystal, addresses.owner, robot.crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, robot.deuterium)
    NoGame.robotUpgradeStart(addresses.game)
    _time_warp(1000, addresses.facilities)
    NoGame.robotUpgradeComplete(addresses.game)

    _set_resource_levels(addresses.metal, addresses.owner, shipyard.metal)
    _set_resource_levels(addresses.crystal, addresses.owner, shipyard.crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, shipyard.deuterium)
    %{ store(ids.addresses.game, "NoGame_robot_factory_level", [2], [1,0]) %}
    NoGame.shipyardUpgradeStart(addresses.game)
    _time_warp(3000, addresses.facilities)
    NoGame.shipyardUpgradeComplete(addresses.game)

    _set_resource_levels(addresses.metal, addresses.owner, lab.metal)
    _set_resource_levels(addresses.crystal, addresses.owner, lab.crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, lab.deuterium)
    NoGame.researchUpgradeStart(addresses.game)
    _time_warp(4000, addresses.facilities)
    NoGame.researchUpgradeComplete(addresses.game)

    _set_resource_levels(addresses.metal, addresses.owner, nanite.metal)
    _set_resource_levels(addresses.crystal, addresses.owner, nanite.crystal)
    _set_resource_levels(addresses.deuterium, addresses.owner, nanite.deuterium)
    %{ store(ids.addresses.game, "NoGame_computer_tech", [10], [1,0]) %}
    %{ store(ids.addresses.game, "NoGame_robot_factory_level", [10], [1,0]) %}
    NoGame.naniteUpgradeStart(addresses.game)
    _time_warp(10000, addresses.facilities)
    NoGame.naniteUpgradeComplete(addresses.game)

    let (new_robot, new_shipyard, new_lab, new_nanite) = NoGame.getFacilitiesLevels(
        addresses.game, addresses.owner
    )

    assert new_robot = prev_robot + 1
    assert new_shipyard = prev_shipyard + 1
    assert new_lab = prev_lab + 1
    assert new_nanite = prev_nanite + 1

    return ()
end
