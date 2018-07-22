local cameraHeight = 0.5

local backgroundColor = {0.7, 0.8, 0.9}

local heightMap, colorMap

local phi = 0

local startPoint = {x = 0, y = 0}

local rotationSpeed = 0.5
local moveSpeed = 30

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  heightMapData = love.image.newImageData('height.png')

  heightMap = love.graphics.newImage('height.png')
  heightMap:setWrap('repeat', 'repeat')
  heightMap:setFilter('nearest', 'nearest')

  colorMap = love.graphics.newImage('color.png')
  colorMap:setWrap('repeat', 'repeat')
  colorMap:setFilter('nearest', 'nearest')

  love.graphics.setBackgroundColor(backgroundColor)

  myShader = love.graphics.newShader('shader.glsl')
  myShader:send('heightMap', heightMap)
  myShader:send('colorMap', colorMap)
  print(myShader:getWarnings());

  canvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)
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

  if love.keyboard.isDown('q') then
    cameraHeight = cameraHeight - dt * rotationSpeed
  elseif love.keyboard.isDown('e') then
    cameraHeight = cameraHeight + dt * rotationSpeed
  end

  myShader:send('phi', phi)
  myShader:send('player', {startPoint.x, startPoint.y, cameraHeight})
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setShader(myShader)

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  love.graphics.setShader()

  love.graphics.setCanvas()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, SCALE_X, SCALE_Y)
  love.graphics.setBlendMode('alpha')

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(love.timer.getFPS() .. ' FPS')
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end
