-- Resource Metadata
fx_version 'cerulean'
game 'gta5'

-- Script Name
author 'Dohja'
description 'Light Props Placement Script'
version '1.0.0'

-- Resource Files
files {
    '../[props]/bzzz_lights_and_lamps/stream/*.ytyp',
    '../[props]/bzzz_lights_and_lamps/stream/*.ydr'
}

data_file 'DLC_ITYP_REQUEST' '../[props]/bzzz_lights_and_lamps/stream/bzzz_dream_of_lights.ytyp'

-- Server-Side Code
server_scripts {
    'server/server.lua'
}

-- Client-Side Code
client_scripts {
    'client/client.lua'
}