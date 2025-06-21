-- Detect interaction with radios
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(ped, false)
        local pos = GetEntityCoords(ped)
        
        -- Example: Press "E" to open radio UI
        if not inVehicle and IsControlJustPressed(1, 51) then -- 'E' key
            TriggerEvent('radio')
        end

        Citizen.Wait(0)
    end
end)
