fx_version 'cerulean'
game 'gta5'

author 'Dohja'
description 'Portable EV Battery Script'
version '1.0.0'

shared_script 'config.lua'
client_script 'client/client.lua'
server_script 'server/server.lua'

dependencies {
    'TAM_Fuel', -- Ensure TAM_fuel is loaded first
    'ox_target', -- Add ox_target dependency
    'ox_inventory', -- Add ox_inventory dependency
    'ox_lib' -- Add ox_lib dependency (if using lib.progress)
}