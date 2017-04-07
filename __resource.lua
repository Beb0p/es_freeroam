resource_type 'gametype' { name = 'es_freeroam'}

description 'FiveM Essential FreeRoam.'

-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {
  'client.lua',
  'player/map.lua',
  'player/scoreboard.lua',
  'stores/stripclub.lua',
  'events/fleecaJob.lua',
}

server_scripts {
  'server.lua',
  'player/commands.lua',
}
