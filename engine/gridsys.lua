local Grid = {}
local GRID_SIZE = 32
local crops = {}

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function Grid.CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+(w2/2) and
           x2 < x1+(w1/2) and
           y1 < y2+(h2/2) and
           y2 < y1+(h1/2)
  end

function Grid.draw(Player)
    local width = love.graphics.getWidth() / GRID_SIZE
    local height = love.graphics.getHeight() / GRID_SIZE
    local toolX, toolY = Player.tool.x or 0, Player.tool.y or 0
    local toolH, toolW = Player.tool.h or 0, Player.tool.w or 0
    love.graphics.setColor(255, 255, 255, 0.2)
    
    for y = 0, height do
        for x = 0, width do
            local gridX = x * GRID_SIZE
            local gridY = y * GRID_SIZE

            if Grid.CheckCollision(gridX, gridY, GRID_SIZE, GRID_SIZE, toolX, toolY, toolW, toolH) then
                love.graphics.rectangle("fill", gridX, gridY, GRID_SIZE, GRID_SIZE)
            else
                love.graphics.rectangle("line", gridX, gridY, GRID_SIZE, GRID_SIZE)
            end
        end
    end
end

return Grid
