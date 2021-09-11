fx_version 'cerulean'

game 'gta5'

author 'APX Developers'

shared_script {
    '@es_extended/imports.lua',
    'config.lua'
} 

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependecy {
    'jsfour-idcard' -- (https://github.com/jonassvensson4/jsfour-idcard)
}
