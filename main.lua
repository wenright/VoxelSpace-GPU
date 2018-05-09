local drawDistance = 150
local cameraHeight = 0.5
local horizon = 120
local heightScale = 120000

local heightMap, colorMap

function love.load()
  heightMap = love.image.newImageData('height.png')
  colorMap = love.image.newImageData('color.png')

  love.graphics.setBackgroundColor(0.7, 0.8, 0.9)
end

function love.draw()
  local startPoint = {x = 0, y = 0}

  -- https://github.com/s-macke/VoxelSpace
  for z=drawDistance, 1, -1 do
    local leftPointX, leftPointY  = -z + startPoint.x, -z + startPoint.y
    local rightPointX, rightPointY = z + startPoint.x,  z + startPoint.y

    local dx = (rightPointX - leftPointX) / love.graphics.getWidth()
    for x=0, love.graphics.getWidth() do
      local drawHeight = (cameraHeight - getHeight(leftPointX, leftPointY, heightMap)) / z * heightScale + horizon

      love.graphics.setColor(getColor(leftPointX, leftPointY, colorMap))
      love.graphics.points(x, drawHeight)

      leftPointX = leftPointX + dx
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

function getHeight(x, y, map)
  local r, g, b = getColor(x, y, map)
  return r
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end
