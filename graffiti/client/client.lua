-- client.lua
local graffitiTextures = {
    {label = "Dead Smiley Face", texture = "dead_smiley_face"},
    {label = "Graffiti #2", texture = "prop_spray_paint_2"},
    {label = "Graffiti #3", texture = "prop_spray_paint_3"},
}

-- State management
local isPlacingGraffiti = false
local selectedTexture = nil
local previewCoords = nil

-- Preview graffiti placement
RegisterNetEvent("graffiti:previewGraffiti", function(texture)
    print("[DEBUG] Starting graffiti preview mode with texture:", texture)
    isPlacingGraffiti = true
    selectedTexture = texture
    
    -- Start preview loop
    CreateThread(function()
        while isPlacingGraffiti do
            Wait(0)
            -- Get camera direction and perform raycast
            local camCoords = GetGameplayCamCoord()
            local direction = GetGameplayCamDirection()
            local endCoords = vector3(
                camCoords.x + direction.x * 5.0,
                camCoords.y + direction.y * 5.0,
                camCoords.z + direction.z * 5.0
            )
            
            local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(
                camCoords.x, camCoords.y, camCoords.z,
                endCoords.x, endCoords.y, endCoords.z,
                1, PlayerPedId(), 0
            )
            local _, hit, hitCoords, _, entityHit = GetShapeTestResult(rayHandle)
            
            if hit == 1 and entityHit ~= 0 then
                previewCoords = hitCoords
                -- Draw preview marker
                DrawMarker(
                    1, -- marker type
                    hitCoords.x, hitCoords.y, hitCoords.z,
                    0.0, 0.0, 0.0, -- direction
                    0.0, 0.0, 0.0, -- rotation
                    1.0, 1.0, 0.1, -- scale
                    50, 255, 50, 100, -- color (semi-transparent green)
                    false, false, 2, false, nil, nil, false -- additional parameters
                )
                
                Draw3DText(hitCoords, "Press E to place graffiti\nPress X to cancel")
                
                -- Handle placement
                if IsControlJustPressed(0, 38) then -- E key
                    print("[DEBUG] Placing graffiti at coordinates:", hitCoords)
                    TriggerServerEvent("graffiti:placeGraffiti", hitCoords, selectedTexture)
                    isPlacingGraffiti = false
                elseif IsControlJustPressed(0, 73) then -- X key
                    print("[DEBUG] Cancelled graffiti placement")
                    isPlacingGraffiti = false
                end
            end
        end
    end)
end)

-- Show placed graffiti
RegisterNetEvent("graffiti:showGraffiti", function(coords, texture)
    print("[DEBUG] Showing graffiti at coords:", coords, "with texture:", texture)
    
    -- Request the texture dictionary
    RequestStreamedTextureDict(texture, true)
    while not HasStreamedTextureDictLoaded(texture) do
        Wait(0)
    end
    
    -- Create persistent graffiti
    CreateThread(function()
        while true do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - coords)
            
            -- Only render if player is within 50.0 units
            if distance < 50.0 then
                -- Calculate size based on distance (smaller when further away)
                local size = math.max(1.0, 2.0 - (distance / 25.0))
                
                -- Draw the sprite in 3D space
                DrawSprite3D(
                    coords.x, coords.y, coords.z,
                    0.0, 0.0, 0.0, -- rotation
                    size, size, -- scale
                    texture, "graffiti", -- dict and texture name
                    255, 255, 255, 255 -- color
                )
            else
                -- If player is far away, we can wait longer between checks
                Wait(1000)
            end
        end
    end)
end)

-- Utility function to draw sprites in 3D space
function DrawSprite3D(x, y, z, rotX, rotY, rotZ, scaleX, scaleY, textureDict, textureName, r, g, b, a)
    local onScreen, screenX, screenY = World3dToScreen2d(x, y, z)
    if onScreen then
        local fov = (1 / GetGameplayCamFov()) * 100
        local scaleByFov = scaleX * fov
        
        SetDrawOrigin(x, y, z, 0)
        DrawSprite(textureDict, textureName, 0, 0, scaleByFov, scaleByFov * GetAspectRatio(false), rotZ, r, g, b, a)
        ClearDrawOrigin()
    end
end