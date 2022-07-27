%lang starknet

from tests.conftest import (
    E18,
    Contracts,
    _get_test_addresses,
    _run_modules_manager,
    _run_minter,
    _time_warp,
)
from tests.interfaces import NoGame

@external
func test_upgrade_mines_base{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (addresses : Contracts) = _get_test_addresses()
    _run_modules_manager(addresses)
    _run_minter(addresses, 10)
    %{
        stop_prank_callable1 = start_prank(
                   ids.addresses.owner, target_contract_address=ids.addresses.game)
    %}
    NoGame.generatePlanet(addresses.game)
    let (prev_metal, prev_crystal, prev_deuterium, prev_solar) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.owner
    )
    NoGame.metalUpgradeStart(addresses.game)
    _time_warp(1000, addresses.resources)
    NoGame.metalUpgradeComplete(addresses.game)

    NoGame.crystalUpgradeStart(addresses.game)
    _time_warp(2000, addresses.resources)
    NoGame.crystalUpgradeComplete(addresses.game)

    NoGame.deuteriumUpgradeStart(addresses.game)
    _time_warp(3000, addresses.resources)
    NoGame.deuteriumUpgradeComplete(addresses.game)

    NoGame.solarUpgradeStart(addresses.game)
    _time_warp(4000, addresses.resources)
    NoGame.solarUpgradeComplete(addresses.game)

    let (new_metal, new_crystal, new_deuterium, new_solar) = NoGame.getResourcesBuildingsLevels(
        addresses.game, addresses.owner
    )
    assert new_metal = prev_metal + 1
    assert new_crystal = prev_crystal + 1
    assert new_deuterium = prev_deuterium + 1
    assert new_solar = prev_solar + 1
    return ()
end
