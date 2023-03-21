fx_version 'adamant'
game 'gta5'

author 'Agatha Kalashnikov'
contact 'E-mail: abbyssid@gmail.com - Discord: Abbyssid#0047'
version '1.0.4'

ui_page 'nui/darkside.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'config/config.lua',
	'hansolo/*.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'config/config.lua',
	'skywalker.lua'
}

files {
	'nui/*.html',
	'nui/*.js',
	'nui/*.css',
	'nui/**/*'
}