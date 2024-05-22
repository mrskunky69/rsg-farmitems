fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'Phil'
description 'Object Carrying System'
version '1.0.0'

-- Client Scripts
client_scripts {
    'client/client.lua'
}

-- Server Scripts
server_scripts {
    'server/server.lua'
}

-- Shared Scripts
shared_scripts {
    'config.lua'
}

-- Dependencies
dependencies {
    'rsg-core',
    'rsg-target'
}
