Config = {}

-- Battery settings
Config.BatteryItem = 'ev_battery' -- Name of the battery item
Config.MaxBatteryCharge = 100 -- Maximum charge level of the battery
Config.RechargeRate = 10 -- Charge added per second when recharging the battery
Config.EVRechargeRate = 10 -- Charge added per second when recharging the EV
Config.RechargeCost = 10 -- Cost to recharge the battery at a station

-- Charging settings
Config.ChargingDuration = 10000 -- Charging duration in milliseconds (10 seconds)
Config.HoodDistance = 2.0 -- Maximum distance from the hood to interact