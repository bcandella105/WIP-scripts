local batteryCharges = {}

-- Function to get battery charge
function GetBatteryCharge(source)
    return batteryCharges[source] or 0
end

-- Function to update battery charge
function UpdateBatteryCharge(source, amount)
    if not batteryCharges[source] then batteryCharges[source] = 0 end
    batteryCharges[source] = math.max(0, math.min(Config.MaxBatteryCharge, batteryCharges[source] + amount))
end

-- Event to recharge the battery at a station
RegisterServerEvent('dohja_evbattery:RechargeBattery')
AddEventHandler('dohja_evbattery:RechargeBattery', function()
    local source = source
    UpdateBatteryCharge(source, Config.RechargeRate)
end)

-- Event to update battery charge
RegisterServerEvent('dohja_evbattery:UpdateBatteryCharge')
AddEventHandler('dohja_evbattery:UpdateBatteryCharge', function(amount)
    UpdateBatteryCharge(source, amount)
end)

-- Export to get battery charge
exports('GetBatteryCharge', GetBatteryCharge)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Clear battery charge data
        batteryCharges = {}
    end
end)