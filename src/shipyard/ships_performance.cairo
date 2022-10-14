%lang starknet

namespace Fleet {
    namespace Cargo {
        const structural_intergrity = 4000;
        const shield_power = 10;
        const weapon_power = 5;
        const cargo_capacity = 5000;
        const base_speed = 5000;
        const fuel_consumption = 10;
    }

    namespace Recycler {
        const structural_intergrity = 16000;
        const shield_power = 10;
        const weapon_power = 1;
        const cargo_capacity = 20000;
        const base_speed = 2000;
        const fuel_consumption = 300;
    }

    namespace EspionageProbe {
        const structural_intergrity = 1000;
        const shield_power = 0;
        const weapon_power = 0;
        const cargo_capacity = 5;
        const base_speed = 100000000;
        const fuel_consumption = 1;
    }

    namespace SolarSatellite {
        const structural_intergrity = 2000;
        const shield_power = 1;
        const weapon_power = 1;
        const cargo_capacity = 0;
        const base_speed = 0;
        const fuel_consumption = 0;
    }

    namespace LightFighter {
        const structural_intergrity = 4000;
        const shield_power = 10;
        const weapon_power = 50;
        const cargo_capacity = 50;
        const base_speed = 12500;
        const fuel_consumption = 20;
    }

    namespace Cruiser {
        const structural_intergrity = 27000;
        const shield_power = 50;
        const weapon_power = 400;
        const cargo_capacity = 800;
        const base_speed = 15000;
        const fuel_consumption = 300;
    }

    namespace BattleShip {
        const structural_intergrity = 60000;
        const shield_power = 200;
        const weapon_power = 1000;
        const cargo_capacity = 15000;
        const base_speed = 10000;
        const fuel_consumption = 500;
    }

    namespace Deathstar {
        const structural_intergrity = 9000000;
        const shield_power = 50000;
        const weapon_power = 200000;
        const cargo_capacity = 1000000;
        const base_speed = 100;
        const fuel_consumption = 1;
    }
}
