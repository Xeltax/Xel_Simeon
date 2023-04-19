Config = {

    blipSprite = 293,

    blipColor = 3,

    blipName = "Simeon - Livraison",

    missionPercentage = 10, -- percentage chance to launch the mission (100 to debug)

    minPoliceOnline = 0, -- minimum police online to launch the mission (0 to disable)

    deliveryPoint = {
        vector3(-1359.96, -757.21, 22.30),
        vector3(1204.39, -3117.12, 5.53),
        vector3(-402.09, 510.36, 120.20),
        vector3(518.84, 169.19, 99.35),
        vector3(1149.24, -1643.34, 36.32),
        vector3(135.60, -1050.64, 29.14),
        vector3(963.95, -1856.41, 31.18),
        vector3(946.24, -1698.01, 30.07),
        vector3(-444.63, -2179.00, 10.30),
        vector3(258.63, 2590.61, 44.95),
    },

    vehicleDestruction = 750, -- vehicle destruction percentage (1000 = 100%) 750 is really damaged (broken window, broken lights, etc.)

    perfectBonus = 1.5, -- bonus for perfect delivery (100% health)

    reward = { -- reward for the mission (random between min and max)
        min = 1000,
        max = 2000
    }
}