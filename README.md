<div align="center">
  <img src="readme/NoGame_logo.svg" width=900 alt="nogame-logo" />

  <h4>Space themed MMORPG running on Starknet</h4>
</div>

## Usage

Create a virtual environment (with python 3.9):

```
python3.9 -m venv ~/cairo_venv
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

### Testing:

```
protostar test
```

### Compile

```
./run build
```

### Deploy

```
./run deploy
```

### Clean build folder

```
./run clean
```

## Functionalities Roadmap.

### v0.1 :heavy_check_mark:

-   [x] Account can create a planet and upgrade mines. Only mines are available. :heavy_check_mark:
-   [x] Integration of ERC721: planets will be NFTs. :heavy_check_mark:
-   [x] Integration of ERC20: resources will be tokenised. :heavy_check_mark:
-   [x] Add energy production requirements for mines. :heavy_check_mark:
-   [x] Add time constraints for buildings upgrades. :heavy_check_mark:
-   [x] Add energy requirements for energy production. :heavy_check_mark:

### v0.2

-   [x] Implement Modules Manager. :heavy_check_mark:
-   [x] Implement upgradable modules. :heavy_check_mark:
-   [x] Implement game’s modules. :heavy_check_mark:
    -   [x] Shipyard module.
    -   [x] Resources module.
    -   [x] Facilities module.
    -   [x] Research module.
    -   [x] Testing
-   [x] Implement Resources :heavy_check_mark:
    -   [x] Mines upgrades
    -   [x] Mines costs
    -   [x] Mines constraints
    -   [x] Testing
-   [x] Implement Facilities :heavy_check_mark:
    -   [x] Facilities upgrades.
    -   [x] Facilities costs.
    -   [x] Facilities constraints.
    -   [x] Testing
-   [x] Implement Shipyard :heavy_check_mark:
    -   [x] Ships build.
    -   [x] Ships costs.
    -   [x] Ships constraints.
    -   [x] Testing
-   [x] Implement Research :heavy_check_mark:
    -   [x] Research upgrades.
    -   [x] Research cost.
    -   [x] Research contsraints.
    -   [x] Testing

### v0.3

-   [x] Implement defences. :heavy_check_mark:
-   [x] Implement coordinates system for planets. :heavy_check_mark:
-   [x] Implement ships characteristics.:heavy_check_mark:
-   [x] Implement Fleet Movements module.
    -   [x] Travel time calculation :heavy_check_mark:
    -   [x] Fuel cost calculation :heavy_check_mark:
-   [ ] Implement Space War module.
    -   [ ] Battle damage calculation
    -   [ ] Loot amounts calculation
    -   [ ] ERC20 loot managment
