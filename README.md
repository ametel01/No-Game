<div align="center">
  <img src="readme/NoGame_logo.svg" width=900 alt="nogame-logo" />

  <h4>Space themed MMORPG running on Starknet</h4>
</div>

## Usage

Create a virtual environment (with python 3.7):

```
python3.7 -m venv ~/cairo_venv
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

-   [ ] Implement coordinates system for planets
-   [ ] Implement ships characteristics
-   [ ] Implement Fleet Movements module
    -   [ ] Travel time calculation
    -   [ ] Fuel cost calculation
-   [ ] Implement Space War module
    -   [ ] Battle damage calculation
    -   [ ] Loot amounts calculation
    -   [ ] ERC20 loot managment

## Deployment

run:

```
protostar build
```

1. deploy minter contract:

```
protostar deploy ./build/minter.json --network alpha-goerli --inputs [admin.contract_address]
```

2. deploy the ERC721 contract:

```
protostar deploy ./build/erc721.json --network alpha-goerli --inputs  0x4e6f47616d6520 0x4f474d302e31 [minter.contrac_address] 54 105 112 102 115 58 47 47 81 109 98 87 78 103 117 89 106 85 115 53 101 50 102 55 88 119 113 65 106 54 121 72 69 119 111 74 109 104 89 78 121 72 78 78 90 122 105 102 56 78 109 56 53 68 47
```

3. deploy the modules manager contract:

```
protostar deploy ./build/manager.json --network alpha-goerli --inputs [admin.contract_address]
```

4. deploy NoGame main contract:

```
protostar deploy ./build/main.json --network alpha-goerli --inputs [admin.contract_address] [manager.contract_address]
```

5. deploy erc20 metal contract:

```
protostar deploy ./build/erc20.json --network alpha-goerli --inputs 0x4e6f47616d652d4d6574616c 0x4e472d4d 18 0 0 [main.contract_address] [main.contract_address]
```

6. deploy erc20 crystal contract:

```
protostar deploy ./build/erc20.json --network alpha-goerli --inputs  0x4e6f47616d652d4372797374616c 0x4e472d43 18 0 0 [main.contract_address] [main.contract_address]
```

7. deploy erc20 deuterium contract:

```
protostar deploy ./build/erc20.json --network alpha-goerli --inputs  0x4e6f47616d652d44657574657269756d 0x4e472d44 18 0 0 [main.contract_address] [main.contract_address]
```

8. deploy the resources contract:

```
protostar deploy ./build/resources.json --network alpha-goerli --inputs [main.contract_address]
```

9. deploy the facilities contract:

```
protostar deploy ./build/facilities.json --network alpha-goerli --inputs [main.contract_address]
```

10. deploy the shipyard contract:

```
protostar deploy ./build/shipyard.json --network alpha-goerli --inputs [main.contract_address]
```

11. deploy research lab contract:

```
protostar deploy ./build/research.json --network alpha-goerli --inputs [main.contract_address]
```
