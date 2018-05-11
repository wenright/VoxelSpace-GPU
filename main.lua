local drawDistance = 1000
local cameraHeight = 0.5
local horizon = 120
local heightScale = 120000

local backgroundColor = {0.7, 0.8, 0.9}

local heightMap, colorMap

local phi = 0

local startPoint = {x = 0, y = 0}

function love.load()
  heightMap = love.image.newImageData('height.png')
  colorMap = love.image.newImageData('color.png')

  love.graphics.setBackgroundColor(backgroundColor)
end

function love.update(dt)
  if love.keyboard.isDown('a') then
    phi = phi + dt
  elseif love.keyboard.isDown('d') then
    phi = phi - dt
  end
end

function love.draw()
  -- Sin/Cos precalculations
  sinPhi = math.sin(phi)
  cosPhi = math.cos(phi)

  for z=drawDistance, 1, -3 do
    local leftPointX, leftPointY  = -cosPhi * z  - sinPhi * z + startPoint.x, sinPhi * z - cosPhi * z + startPoint.y
    local rightPointX, rightPointY = cosPhi * z - sinPhi * z + startPoint.x,  -sinPhi * z - cosPhi * z + startPoint.y

    local dx = (rightPointX - leftPointX) / love.graphics.getWidth()
    local dy = (rightPointY - leftPointY) / love.graphics.getWidth()

    local skip = 5
    for x=0, love.graphics.getWidth(), skip do
      local drawHeight = (cameraHeight - getHeight(leftPointX, leftPointY, heightMap)) / z * heightScale + horizon

      love.graphics.setColor(getFadedColor(leftPointX, leftPointY, colorMap, z))
      love.graphics.rectangle('fill', x, drawHeight, skip, 100)

      leftPointX = leftPointX + dx * skip
      leftPointY = leftPointY + dy * skip
    end
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(love.timer.getFPS())
end

function getColor(x, y, map)
  local x, y = math.floor(x + 0.5) % map:getWidth(), math.floor(y + 0.5) % map:getHeight()
  local r, g, b = map:getPixel(x, y)
  return r, g, b
end

function getFadedColor(x, y, map, z)
  local r, g, b = getColor(x, y, map)

  local v = math.pow((drawDistance - z) / drawDistance, 0.5)

  r = ((v * r) + ((1 - v) * backgroundColor[1]))
  g = ((v * g) + ((1 - v) * backgroundColor[2]))
  b = ((v * b) + ((1 - v) * backgroundColor[3]))

  return r, g, b
end

function getHeight(x, y, map)
  local r, g, b = getColor(x, y, map)
  return r
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end
