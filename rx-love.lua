-- RxLove
-- https://github.com/bjornbytes/RxLove
-- MIT License

local rx = require 'rx'

local events = {
  'directorydropped',
  'draw',
  'filedropped',
  'focus',
  'keypressed',
  'keyreleased',
  'lowmemory',
  'mousefocus',
  'mousemoved',
  'mousepressed',
  'mousereleased',
  'quit',
  'resize',
  'textedited',
  'textinput',
  'touchmoved',
  'touchpressed',
  'touchreleased',
  'threaderror',
  'update',
  'visible',
  'wheelmoved'
}

for _, event in pairs(events) do
  love[event] = rx.Subject.create()
end
