fx_version 'cerulean'
game 'gta5'

name 'RadioPlayer'
description 'Standalone Radio Player for FiveM'
author 'YourName'
version '1.0.0'

client_scripts {
    'client/client.lua',
    'client/interaction.lua'
}

server_script 'server/server.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/script.js',
    'ui/style.css'
}
