fx_version 'cerulean'
game 'gta5'

name 'Graffiti Script'
description 'Standalone graffiti script for QBox/OX Inventory'
author 'Dohja'

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

files {
    'stream/dead_smiley_face.ytd', -- optional for custom textures
}

data_file 'DLC_ITYP_REQUEST' 'dead_smiley_face.ytd' -- optional for custom textures
