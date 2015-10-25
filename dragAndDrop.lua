local rx = require 'rx'
require 'rx-love'

-- This Subject keeps track of the x and y position of the circle.
local object = rx.BehaviorSubject.create(400, 300)

local radius = 30
local isLeft = function(x, y, button) return button == 'l' end

-- Set up observables for clicking and releasing the left mouse button.
local leftPressed = love.mousepressed:filter(isLeft)
local leftReleased = love.mousereleased:filter(isLeft)

-- Run some operations on the mousepressed and mousereleased observables:
--  * filter out any mouse presses that aren't within the radius of the circle.
--  * map over the mouse presses and return an observable from the love.mousemoved event, which
--    produces the coordinates of the mouse as it moves.
--  * takeUntil to stop moving the circle when the mouse is released.
--  * flatten it to convert the observable of observables into an observable that just contains the
--    mouse coordinates.
--  * subscribe to them and set the circle's position.
local drag = leftPressed
  :filter(function(x, y)
    local ox, oy = object:getValue()
    return (x - ox) ^ 2 + (y - oy) ^ 2 < radius ^ 2
  end)
  :map(function()
    return love.mousemoved:takeUntil(leftReleased)
  end)
  :flatten()
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
