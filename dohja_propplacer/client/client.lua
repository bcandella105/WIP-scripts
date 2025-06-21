local placedProps = {}

RegisterNetEvent('dohja_propplacer:addPlacedProp')
AddEventHandler('dohja_propplacer:addPlacedProp', function(propNetId, propCoords, playerId)
    if not placedProps[propNetId] then
        local prop = NetworkGetEntityFromNetworkId(propNetId)
        if not DoesEntityExist(prop) then
            prop = CreateObject(GetHashKey('bzzz_dream_of_lights'), propCoords.x, propCoords.y, propCoords.z, true, false, true)
            PlaceObjectOnGroundProperly(prop)
            FreezeEntityPosition(prop, true)
        end
        placedProps[propNetId] = prop
    end
end)

RegisterNetEvent('dohja_propplacer:removePlacedProp')
AddEventHandler('dohja_propplacer:removePlacedProp', function(propNetId)
    local prop = placedProps[propNetId]
    if prop and DoesEntityExist(prop) then
        DeleteObject(prop)
        placedProps[propNetId] = nil
    end
end)

RegisterCommand('placeLight', function()
    local playerPed = PlayerPedId()
    local propCoords = GetEntityCoords(playerPed) + GetEntityForwardVector(playerPed) * 2.0
    local prop = CreateObject(GetHashKey('bzzz_dream_of_lights'), propCoords.x, propCoords.y, propCoords.z, true, false, true)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)

    local propNetId = NetworkGetNetworkIdFromEntity(prop)
    TriggerServerEvent('dohja_propplacer:placeLightProp', propNetId, propCoords, GetPlayerServerId(PlayerId()))
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for netId, prop in pairs(placedProps) do
            local propCoords = GetEntityCoords(prop)
            if #(playerCoords - propCoords) <= 2.0 then
                DrawText3D(propCoords, "Press ~g~E~s~ to pick up")
                if IsControlJustReleased(0, 38) then -- E key
                    TriggerServerEvent('dohja_propplacer:pickupLightProp', netId, GetPlayerServerId(PlayerId()))
                end
            end
        end
    end
end)

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local scale = 0.35
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end