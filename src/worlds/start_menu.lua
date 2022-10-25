StartMenu = {}

local options = {"Continue", "New game", "Credits", "Exit"}
local font = love.graphics.newFont(14)
local activeOption = 1
local textPosition = {64, 32}
local startGameCallback = nil

local function menuDown()
    if activeOption < #options then
        activeOption = activeOption + 1
    else
        activeOption = 1
    end
end

local function menuUp()
    if activeOption > 1 then
        activeOption = activeOption - 1
    else
        activeOption = #options
    end
end

function StartMenu:setStartGameCallback(cb)
    startGameCallback = cb
end

local function execAction()
    if activeOption == 1 and startGameCallback then
        startGameCallback()
    elseif activeOption == 3 then
        print("Created by Luis J. Centeno")
    elseif activeOption == 4 then
        love.event.quit()
    end
end

function StartMenu:input(Input)
    if Input:released('down') then
        menuDown()
    elseif Input:released('up') then
        menuUp()
    elseif Input:released('action') then
        execAction()
    end

end

function StartMenu:draw()
    love.graphics.setFont(font)
    love.graphics.setBackgroundColor(Color:get('green'))
    local textTop = 64

    for i = 1, #options do
        local textColor = "gray"

        if i == activeOption then
            textColor = "yellow"
        end

        love.graphics.setColor(Color:get(textColor))
        love.graphics.print(options[i], textPosition[1], textTop)
        textTop = textTop + 24
    end
end

return StartMenu
