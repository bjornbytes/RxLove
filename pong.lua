local Rx = require 'rx'
require 'rx-love'

-- Map parameters
local width = 800
local height = 600
local border = 10

-- Player parameters
local paddleWidth = 20
local paddleHeight = 80
local paddleSpeed = 500

-- Ball parameters
local ballSize = 20

-- Maps keys to players and directions
local keyMap = {
  w = {'player1', -1},
  s = {'player1', 1},
  up = {'player2', -1},
  down = {'player2', 1}
}

local state

-- Declare initial state of game
function love.load()
  state = {
    ball = {
      x = width / 2 - ballSize / 2,
      y = height / 2 - ballSize / 2,
      width = ballSize,
      height = ballSize,
      direction = 3 * math.pi / 4,
      speed = 400
    },
    player1 = {
      x = border,
      y = height / 2 - paddleHeight / 2,
      width = paddleWidth,
      height = paddleHeight
    },
    player2 = {
      x = width - (border + paddleWidth / 2),
      y = height / 2 - paddleHeight / 2,
      width = paddleWidth,
      height = paddleHeight
    }
  }
end

-- Helper functions
local function identity(...) return ... end
local function const(val) return function() return val end end
local function dt() return love.update:getValue() end
local function move(dt, player, direction)
  state[player].y = state[player].y + direction * paddleSpeed * dt
end

-- Respond to key presses to move players
for _, key in pairs({'up', 'down', 'w', 's'}) do
  love.update
    :filter(function()
      return love.keyboard.isDown(key)
    end)
    :map(function(dt)
      return dt, unpack(keyMap[key])
    end)
    :subscribe(move)
end

-- Move ball
love.update
  :skip(1)
  :subscribe(function(dt)
    state.ball.x = state.ball.x + math.cos(state.ball.direction) * state.ball.speed * dt
    state.ball.y = state.ball.y + math.sin(state.ball.direction) * state.ball.speed * dt
  end)

-- Collision on top and bottom
love.update
  :filter(function()
    return state.ball.y < 0 or state.ball.y > height - ballSize
  end)
  :subscribe(function()
    state.ball.direction = -state.ball.direction
    state.ball.y = math.max(state.ball.y, 0)
    state.ball.y = math.min(state.ball.y, height - ballSize)
  end)

-- Paddle collision
love.update
  :map(function()
    local left = state.ball.x - ballSize / 2 < state.player1.x + paddleWidth and
      state.ball.y + ballSize / 2 > state.player1.y and
      state.ball.y + ballSize / 2 < state.player1.y + paddleHeight

    local right = state.ball.x + ballSize / 2 > state.player2.x and
      state.ball.y + ballSize / 2 > state.player2.y and
      state.ball.y + ballSize / 2 < state.player2.y + paddleHeight

    return left and 'left' or (right and 'right' or nil)
  end)
  :compact()
  :subscribe(function(side)
    local x, y = math.cos(state.ball.direction), math.sin(state.ball.direction)
    x = -x
    state.ball.direction = math.atan2(y, x)
    if side == 'left' then
      state.ball.x = math.max(state.ball.x, state.player1.x + paddleWidth + ballSize / 2)
    elseif side == 'right' then state.ball.x = math.max(state.ball.x, state.player1.x + paddleWidth)
      state.ball.x = math.min(state.ball.x, state.player2.x - ballSize / 2)
    end

    state.ball.speed = state.ball.speed + 20
  end)

-- Game over
love.update
  :filter(function()
    return state.ball.x < 0 or state.ball.x + ballSize > width
  end)
  :subscribe(love.load)

-- Draw state
love.draw:subscribe(function()
  local g = love.graphics

  g.setColor(0, 0, 0)
  g.rectangle('fill', 0, 0, width, height)

  g.setColor(255, 255, 255)
  g.rectangle('fill', state.player1.x, state.player1.y, state.player1.width, state.player1.height)
  g.rectangle('fill', state.player2.x, state.player2.y, state.player2.width, state.player2.height)
  g.rectangle('fill', state.ball.x, state.ball.y, state.ball.width, state.ball.height)
end)
