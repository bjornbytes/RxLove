-- RxLove
-- https://github.com/bjornbytes/RxLove
-- MIT License

local rx = require 'rx'

local events = {
  'draw',
  'focus',
  'keypressed',
  'keyreleased',
  'mousefocus',
  'mousemove',
  'mousepressed',
  'mousereleased',
  'quit',
  'resize',
  'textinput',
  'threaderror',
  'update',
  'visible'
}

for _, event in pairs(events) do
  love[event] = rx.Subject.create()
end
