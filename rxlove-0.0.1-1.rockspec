package = 'RxLove'
version = '0.0.1-1'

source = {
  url = 'git://github.com/bjornbytes/RxLove',
  tag = 'v0.0.1'
}

description = {
  summary = 'Reactive Extensions for LÖVE',
  homepage = 'https://github.com/bjornbytes/RxLove',
  license = 'MIT/X11',
  maintainer = 'tie.372@gmail.com',
  detailed = [[
    Turn LÖVE events into reactive streams.
  ]]
}

dependencies = {
  'lua >= 5.1',
  'rxlua'
}

build = {
  type = 'builtin',
  modules = { rxlove = 'rx-love.lua' }
}
