local isRecharging = false

-- Function to check if the player is near the hood of the vehicle
function IsNearHood(vehicle)
    local hoodPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'bonnet'))
    local playerPos = GetEntityCoords(PlayerPedId())
    return #(playerPos - hoodPos) < Config.HoodDistance
end

-- Function to play the mechanic animation
function PlayMechanicAnimation()
    RequestAnimDict('mini@repair')
    while not HasAnimDictLoaded('mini@repair') do
        Citizen.Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_player', 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Function to stop the animation
function StopMechanicAnimation()
    StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0)
end

-- Function to recharge EV using the battery
function RechargeEV(vehicle)
    if isRecharging then return end

    -- Check if the vehicle is an electric vehicle (class 18)
    if GetVehicleClass(vehicle) ~= 18 then
        ShowNotification("This vehicle is not an electric vehicle.")
        return
    end

    -- Check if the player has the battery item
    local hasBattery = exports.ox_inventory:Search('count', Config.BatteryItem) > 0
    if not hasBattery then
        ShowNotification("You don't have a portable battery.")
        return
    end

    -- Check the battery charge level
    local batteryCharge = exports['dohja_evbattery']:GetBatteryCharge()
    if batteryCharge <= 0 then
        ShowNotification("Your battery is out of charge.")
        return
    end

    isRecharging = true

    -- Open the hood
    SetVehicleDoorOpen(vehicle, 4, false, false) -- 4 is the hood door index

    -- Play animation
    PlayMechanicAnimation()

    -- Start progress bar using lib.progress
    lib.progress({
        duration = Config.ChargingDuration,
        label = "Recharging EV...",
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_player',
        },
    })

    -- Recharge the EV
    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < Config.ChargingDuration do
        local currentFuel = exports['TAM_fuel']:GetFuel(vehicle)
        if currentFuel >= 100 then
            ShowNotification("EV fully charged.")
            break
        end

        exports['TAM_fuel']:SetFuel(vehicle, currentFuel + Config.EVRechargeRate)
        TriggerServerEvent('dohja_evbattery:UpdateBatteryCharge', -Config.EVRechargeRate)
        Citizen.Wait(1000)
    end

    -- Stop animation and close the hood
    StopMechanicAnimation()
    SetVehicleDoorShut(vehicle, 4, false)
    isRecharging = false
end

-- Add target option for the hood
exports.ox_target:addGlobalVehicle({
    {
        name = 'rechargeEV',
        icon = 'fa-solid fa-battery-full',
        label = 'Recharge EV',
        distance = Config.HoodDistance,
        canInteract = function(entity)
            local vehicle = entity
            return IsNearHood(vehicle) and GetVehicleClass(vehicle) == 18
        end,
        onSelect = function(data)
            RechargeEV(data.entity)
        end
    }
})

-- Notification function
function ShowNotification(message)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Stop animations and close the hood if the script stops
        StopMechanicAnimation()
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= 0 then
            SetVehicleDoorShut(vehicle, 4, false)
        end
    end
end)