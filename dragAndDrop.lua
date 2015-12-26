local rx = require 'rx'
require 'rx-love'

-- This Subject keeps track of the x and y position of the circle.
local object = rx.BehaviorSubject.create(400, 300)

local radius = 30
local isLeft = function(x, y, button) return button == 1 end

-- Set up observables for clicking and releasing the left mouse button.
local leftPressed = love.mousepressed:filter(isLeft)
local leftReleased = love.mousereleased:filter(isLeft)

-- Run some operations on the mousepressed and mousereleased observables:
--  * filter out any mouse presses that aren't within the radius of the circle.
--  * flatMap the mousepresses to start producing values from the love.mousemoved event.  takeUntil
--    ensures that the dragging stops when the mouse button is released.
--  * subscribe to the mouse positions and set the circle's position accordingly.
local drag = leftPressed
  :filter(function(x, y)
    local ox, oy = object:getValue()
    return (x - ox) ^ 2 + (y - oy) ^ 2 < radius ^ 2
  end)
  :flatMap(function()
    return love.mousemoved:takeUntil(leftReleased)
  end)
  :subscribe(function(x, y)
    object:onNext(x, y)
  end)

-- Subscribe to the love.draw event and draw the circle.
love.draw:subscribe(function()
  local x, y = object:getValue()
  love.graphics.setColor(255, 0, 0)
  love.graphics.circle('fill', x, y, radius)
  love.graphics.circle('line', x, y, radius)
end)
