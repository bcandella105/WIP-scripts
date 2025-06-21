local placedProps = {}

RegisterNetEvent('dohja_propplacer:placeLightProp')
AddEventHandler('dohja_propplacer:placeLightProp', function(propNetId, propCoords, playerId)
    table.insert(placedProps, { netId = propNetId, coords = propCoords, player = playerId, timePlaced = os.time() })
    TriggerClientEvent('dohja_propplacer:addPlacedProp', -1, propNetId, propCoords, playerId)
end)

RegisterNetEvent('dohja_propplacer:pickupLightProp')
AddEventHandler('dohja_propplacer:pickupLightProp', function(propNetId, playerId)
    for i, prop in ipairs(placedProps) do
        if prop.netId == propNetId and prop.player == playerId then
            table.remove(placedProps, i)
            TriggerClientEvent('dohja_propplacer:removePlacedProp', -1, propNetId)
            break
        end
    end
end)

-- Cleanup Task
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Check every minute
        local currentTime = os.time()
        for i = #placedProps, 1, -1 do
            if currentTime - placedProps[i].timePlaced >= 3600 then -- 1 hour timeout
                TriggerClientEvent('dohja_propplacer:removePlacedProp', -1, placedProps[i].netId)
                table.remove(placedProps, i)
            end
        end
    end
end)