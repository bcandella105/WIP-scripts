-- Initialize our core resources
local QBox = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory

-- Debug logging function to help track events
local function DebugLog(message)
    print("[Graffiti Debug] " .. message)
end

-- Register the initial use item event for ox_inventory
-- This catches when a player uses the spray paint item from their inventory
RegisterNetEvent('ox_inventory:useItem', function(source, itemName, data)
    DebugLog("Item use triggered - Item: " .. itemName .. ", Source: " .. source)
    
    if itemName == 'spray_paint' then
        local src = source
        -- Check if player has the item using ox_inventory's method
        local hasItem = ox_inventory:GetItem(src, 'spray_paint', nil, true)
        
        if hasItem > 0 then
            DebugLog("Player " .. src .. " has spray paint, showing menu")
            -- Trigger the client-side menu
            TriggerClientEvent("graffiti:showSelectionMenuUI", src)
            -- Send confirmation notification
            TriggerClientEvent('ox:notify', src, {
                title = 'Graffiti',
                description = 'Use arrow keys to select a design',
                type = 'inform'
            })
        else
            DebugLog("Player " .. src .. " tried to use spray paint without having the item")
            TriggerClientEvent('ox:notify', src, {
                title = 'Error',
                description = 'You need Spray Paint to do this!',
                type = 'error'
            })
        end
    end
end)

-- Register the event for when a player uses the spray paint item
-- This is triggered from the client side
RegisterNetEvent('graffiti:useSprayPaint', function()
    local src = source
    DebugLog("useSprayPaint event received from player: " .. src)
    
    -- Verify player has the item
    local hasItem = ox_inventory:GetItem(src, 'spray_paint', nil, true)
    if hasItem > 0 then
        DebugLog("Player has spray paint, showing selection menu")
        TriggerClientEvent("graffiti:showSelectionMenuUI", src)
    else
        DebugLog("Player attempted to use spray paint without having the item")
        TriggerClientEvent('ox:notify', src, {
            title = 'Error',
            description = 'You need Spray Paint to do this!',
            type = 'error'
        })
    end
end)

-- Handle the actual placement of graffiti
RegisterNetEvent("graffiti:placeGraffiti", function(coords, texture)
    local src = source
    DebugLog("Placement attempt by player " .. src)
    
    -- Validate coordinates
    if not coords or not coords.x or not coords.y or not coords.z then
        DebugLog("Invalid coordinates received from player " .. src)
        TriggerClientEvent('ox:notify', src, {
            title = 'Error',
            description = 'Invalid placement location',
            type = 'error'
        })
        return
    end
    
    -- Check if player still has the item when trying to place
    local hasItem = ox_inventory:GetItem(src, 'spray_paint', nil, true)
    
    if hasItem > 0 then
        -- Try to remove one spray paint can
        local success = ox_inventory:RemoveItem(src, 'spray_paint', 1)
        
        if success then
            DebugLog("Successfully removed spray paint from player " .. src)
            -- Broadcast the graffiti to all players
            TriggerClientEvent("graffiti:showGraffiti", -1, coords, texture)
            
            -- Notify the player of successful placement
            TriggerClientEvent('ox:notify', src, {
                title = 'Success',
                description = 'You created some graffiti art!',
                type = 'success'
            })
            
            -- Log the placement coordinates for debugging
            DebugLog(string.format("Graffiti placed at: %f, %f, %f", coords.x, coords.y, coords.z))
        else
            DebugLog("Failed to remove spray paint from player " .. src)
            TriggerClientEvent('ox:notify', src, {
                title = 'Error',
                description = 'Failed to use spray paint',
                type = 'error'
            })
        end
    else
        DebugLog("Player " .. src .. " tried to place graffiti without having spray paint")
        TriggerClientEvent('ox:notify', src, {
            title = 'Error',
            description = 'You need Spray Paint to do this!',
            type = 'error'
        })
    end
end)

-- Admin command to give spray paint (for testing)
QBox.Commands.Add('givespray', 'Give spray paint (Admin Only)', {}, false, function(source)
    local src = source
    local Player = QBox.Functions.GetPlayer(src)
    
    if Player.PlayerData.permission == "admin" or Player.PlayerData.permission == "god" then
        ox_inventory:AddItem(src, 'spray_paint', 1)
        DebugLog("Admin command: gave spray paint to player " .. src)
        TriggerClientEvent('ox:notify', src, {
            title = 'Admin',
            description = 'Added 1 spray paint to inventory',
            type = 'success'
        })
    else
        DebugLog("Non-admin player " .. src .. " attempted to use givespray command")
        TriggerClientEvent('ox:notify', src, {
            title = 'Error',
            description = 'You do not have permission to use this command',
            type = 'error'
        })
    end
end, 'admin')

-- Export the spray paint item definition for ox_inventory
-- This ensures the item is properly registered with the inventory system
exports('spray_paint', {
    label = 'Spray Paint',
    weight = 500,
    stack = true,
    close = true,
    description = 'Used for creating graffiti art',
    client = {
        event = 'graffiti:useSprayPaint',
        status = true
    }
})