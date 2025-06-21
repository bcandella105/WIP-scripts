local radioPlaying = false
local currentProximity = 10 -- Default proximity (10 meters)
local soundId = nil -- Unique sound ID

-- Open the radio UI
RegisterCommand('radio', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openRadio' })
end)

-- NUI Callbacks
RegisterNUICallback('controlRadio', function(data, cb)
    if data.action == 'play' then
        if not soundId then
            soundId = GetSoundId()
            PlayUrlPositional(soundId, data.url, 1.0, GetEntityCoords(PlayerPedId()), currentProximity)
        end
    elseif data.action == 'pause' then
        if soundId then
            PauseSound(soundId)
        end
    elseif data.action == 'stop' then
        if soundId then
            StopSound(soundId)
            ReleaseSoundId(soundId)
            soundId = nil
        end
    elseif data.action == 'volume' then
        if soundId then
            SetSoundVolume(soundId, data.volume)
        end
    elseif data.action == 'proximity' then
        currentProximity = tonumber(data.distance)
        if soundId then
            SetSoundMaxDistance(soundId, currentProximity)
        end
    end
    cb('ok')
end)

-- Function to play positional audio
function PlayUrlPositional(soundId, url, volume, position, distance)
    TriggerServerEvent('radio:play', soundId, url, position, distance)
    SetSoundVolume(soundId, volume)
    SetSoundMaxDistance(soundId, distance)
end
