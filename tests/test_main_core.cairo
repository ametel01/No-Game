%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256
from tests.conftest import _get_test_addresses, _run_modules_manager
from manager.IModulesManager import IModulesManager as Manager

@contract_interface
namespace NoGame:
    func getTokensAddresses() -> (
        erc721 : felt, erc20_metal : felt, erc20_crystal : felt, erc20_deuterium : felt
    ):
    end

    func getModulesAddresses() -> (
        _resources : felt, _facilities : felt, _shipyard : felt, _research : felt
    ):
    end

    func numberOfPlanets() -> (n_planets : felt):
    end
end

@external
func test_game_setup{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (
        owner,
        manager,
        erc721,
        game,
        metal,
        crystal,
        deuterium,
        resources,
        facilities,
        shipyard,
        research,
    ) = _get_test_addresses()
    _run_modules_manager(
        manager, erc721, metal, crystal, deuterium, resources, facilities, shipyard, research
    )

    let (_erc721, _metal, _crystal, _deuterium) = NoGame.getTokensAddresses(game)
    assert _erc721 = erc721
    assert _metal = metal
    assert _crystal = crystal
    assert _deuterium = deuterium

    let (_resources, _facilities, _shipyard, _research) = NoGame.getModulesAddresses(game)
    assert _resources = resources
    assert _facilities = facilities
    assert _shipyard = shipyard
    assert _research = research
    return ()
end
