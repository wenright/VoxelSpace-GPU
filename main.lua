local cameraHeight = 0.5

local backgroundColor = {0.7, 0.8, 0.9}

local heightMap, colorMap

local phi = 0

local startPoint = {x = 0, y = 0}

local rotationSpeed = 2
local moveSpeed = 100

function love.load()
  heightMap = love.graphics.newImage('height.png')
  heightMap:setWrap('repeat', 'repeat')
  colorMap = love.graphics.newImage('color.png')
  colorMap:setWrap('repeat', 'repeat')

  love.graphics.setBackgroundColor(backgroundColor)

  myShader = love.graphics.newShader('shader.glsl')
  myShader:send('heightMap', heightMap)
  myShader:send('colorMap', colorMap)
  print(myShader:getWarnings());
end

function love.update(dt)
  if love.keyboard.isDown('a') then
    phi = phi + dt * rotationSpeed
  elseif love.keyboard.isDown('d') then
    phi = phi - dt * rotationSpeed
  end

  if love.keyboard.isDown('w') then
    startPoint = {
      x = startPoint.x + (math.sin(phi + math.pi * 3 / 4) + math.cos(phi + math.pi * 3 / 4)) * dt * moveSpeed,
      y = startPoint.y + (math.cos(phi + math.pi * 3 / 4) - math.sin(phi + math.pi * 3 / 4)) * dt * moveSpeed
    }
  elseif love.keyboard.isDown('s') then
    startPoint = {
      x = startPoint.x - (math.sin(phi + math.pi * 3 / 4) + math.cos(phi + math.pi * 3 / 4)) * dt * moveSpeed,
      y = startPoint.y - (math.cos(phi + math.pi * 3 / 4) - math.sin(phi + math.pi * 3 / 4)) * dt * moveSpeed
    }
  end

  myShader:send('phi', phi)
  myShader:send('player', {startPoint.x, startPoint.y, cameraHeight})
end

function love.draw()
  love.graphics.setShader(myShader)

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  love.graphics.setShader()

  -- Sin/Cos precalculations
  -- sinPhi = math.sin(phi)
  -- cosPhi = math.cos(phi)
  --
  -- for z=drawDistance, 1, -3 do
  --   local leftPointX, leftPointY  = -cosPhi * z  - sinPhi * z + startPoint.x, sinPhi * z - cosPhi * z + startPoint.y
  --   local rightPointX, rightPointY = cosPhi * z - sinPhi * z + startPoint.x,  -sinPhi * z - cosPhi * z + startPoint.y
  --
  --   local dx = (rightPointX - leftPointX) / love.graphics.getWidth()
  --   local dy = (rightPointY - leftPointY) / love.graphics.getWidth()
  --
  --   local skip = 5
  --   for x=0, love.graphics.getWidth(), skip do
  --     local drawHeight = (cameraHeight - getHeight(leftPointX, leftPointY, heightMap)) / z * heightScale + horizon
  --
  --     love.graphics.setColor(getFadedColor(leftPointX, leftPointY, colorMap, z))
  --     love.graphics.rectangle('fill', x, drawHeight, skip, 200)
  --
  --     leftPointX = leftPointX + dx * skip
  --     leftPointY = leftPointY + dy * skip
  --   end
  -- end

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
