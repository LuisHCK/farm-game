local Debugger = require 'lib.debugger'
local Utils = require 'lib.utils'
local CELL_SIZE = 32
local Grid = {
    currentCell = {
        x = nil,
        y = nil,
        size = CELL_SIZE
    }
}
local objectStack = {}

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function Grid.CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + (w2 / 2) and x2 < x1 + (w1 / 2) and y1 < y2 + (h2 / 2) and y2 < y1 + (h1 / 2)
end

function Grid.update(targetX, targetY, targetH, targetW)
    local width = love.graphics.getWidth() / CELL_SIZE
    local height = love.graphics.getHeight() / CELL_SIZE
    local toolX, toolY = targetX, targetY
    local toolH, toolW = targetH, targetW

    if toolY ~= nil and toolY ~= nil then
        for y = 0, height do
            for x = 0, width do
                local gridX = x * CELL_SIZE
                local gridY = y * CELL_SIZE

                if Grid.CheckCollision(gridX, gridY, CELL_SIZE, CELL_SIZE, toolX, toolY, toolW, toolH) then
                    -- Update current cell
                    Grid.currentCell.x = gridX
                    Grid.currentCell.y = gridY
                end
            end
        end
    end

    Debugger.addMessage(5, "Current Cell: ",
        "X: " .. tostring(Grid.currentCell.x) .. " Y: " .. tostring(Grid.currentCell.y))
end

function Grid.draw()
    local x, y = Grid.currentCell.x, Grid.currentCell.y
    if x ~= nil and y ~= nil then
        love.graphics.setColor(255, 255, 255, 0.2)
        love.graphics.rectangle("fill", x, y, CELL_SIZE, CELL_SIZE)
    end

    for i = 1, #objectStack do
        local object = Utils.split(objectStack[i], ",")
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", object[2], object[3], 32, 32)
    end
end

function Grid.placeObject(id)
    local x, y = Grid.currentCell.x, Grid.currentCell.y

    if x ~= nil and y ~= nil then
        table.insert(objectStack, #objectStack + 1, id .. "," .. x .. "," .. y)
    end
end

return Grid
