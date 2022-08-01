<div align="center">
  <img src="readme/NoGame_logo.svg" width=700 alt="nogame-logo" />

  <h4>Space themed MMORPG running on Starknet</h4>
</div>

## Usage

Create a virtual environment:

```
python -m venv ~/cairo_venv
source ~/cairo_venv/bin/activate
```

From the repo's root install dependencies:

```
pip install poetry
poetry install
```

Install Protostar:

```
curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash
```

Install OpenZeppelin contracts:

```
protostar install https://github.com/OpenZeppelin/cairo-contracts
```

To run the tests:

```
protostar test
```

## Functionalities Roadmap.

### v0.1 :heavy_check_mark:

- [x] Account can create a planet and upgrade mines. Only mines are available. :heavy_check_mark:
- [x] Integration of ERC721: planets will be NFTs. :heavy_check_mark:
- [x] Integration of ERC20: resources will be tokenised. :heavy_check_mark:
- [x] Add energy production requirements for mines. :heavy_check_mark:
- [x] Add time constraints for buildings upgrades. :heavy_check_mark:
- [x] Add energy requirements for energy production. :heavy_check_mark:

### v0.2

- [x] Implement Modules Manager. :heavy_check_mark:
- [x] Implement upgradable modules. :heavy_check_mark:
- [x] Implement game’s modules. :heavy_check_mark:
  - [x] Shipyard module.
  - [x] Resources module.
  - [x] Facilities module.
  - [x] Research module.
  - [x] Testing
- [x] Implement Resources :heavy_check_mark:
  - [x] Mines upgrades
  - [x] Mines costs
  - [x] Mines constraints
  - [x] Testing
- [x] Implement Facilities :heavy_check_mark:
  - [x] Facilities upgrades.
  - [x] Facilities costs.
  - [x] Facilities constraints.
  - [x] Testing
- [ ] Implement Shipyard
  - [x] Ships build.
  - [x] Ships costs.
  - [x] Ships constraints.
  - [ ] Testing
- [ ] Implement Research
  - [x] Research upgrades.
  - [x] Research cost.
  - [x] Research contsraints.
  - [ ] Testing

### v0.3

- [ ] Implement coordinates system for planets
- [ ] Implement ships characteristics
- [ ] Implement Fleet Movements module
  - [ ] Travel time calculation
  - [ ] Fuel cost calculation
- [ ] Implement Space War module
  - [ ] Battle damage calculation
  - [ ] Loot amounts calculation
  - [ ] ERC20 loot managment

```

```
