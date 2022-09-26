local anim8 = require 'lib.anim8'
Debugger = require 'lib.debugger'

local Player = {
    x = 100,
    y = 100,
    speed = 150,
    image = nil,
    animation = nil,
    isMoving = false,
    currentAction = nil,
    tool = {
        x = nil,
        y = nil,
        h = 0,
        w = 0
    }
}

local buttons = {
    UP = "UP",
    DOWN = "DOWN",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
    DIE = "DIE"
}

local actions = {
    WALKING = "WALKING",
    AXE = "AXE",
    STANDING = "STANDING",
    DIE = "DIE",
    ATTACK = "ATTACK"
}

local tools = {
    SHOVEL = "SHOVEL",
    AXE = "AXE",
    SWORD = "SWORD",
    HAND = "HAND"
}

local frames = {
    LEFT = nil,
    RIGHT = nil,
    UP = nil,
    DOWN = nil,
    DIE = nil,
    AXE_LEFT = nil,
    AXE_RIGHT = nil,
    AXE_UP = nil,
    AXE_DOWN = nil
}

local toolBoundingBox = {
    HAND = {
        SIZE = {32, 32},
        LEFT = {-24, 8},
        RIGHT = {24, 8},
        DOWN = {0, 32},
        UP = {0, -24}
    },
    SHOVEL = {
        SIZE = {32, 24},
        LEFT = {-24, 8},
        RIGHT = {24, 8},
        DOWN = {0, 32},
        UP = {0, -24}
    }
}

local MOVE_DIRECTION = buttons.DOWN
local MAIN_ACTION = actions.STANDING
local SELECTED_TOOL = tools.HAND

function Player.load()
    Player.image = love.graphics.newImage('sprites/player_default.png')
    local defaultAnim = anim8.newGrid(64, 64, Player.image:getWidth(), Player.image:getHeight())

    -- Define all animations
    frames.DOWN = anim8.newAnimation(defaultAnim('1-9', 11), 0.08)
    frames.LEFT = anim8.newAnimation(defaultAnim('1-9', 10), 0.08)
    frames.RIGHT = anim8.newAnimation(defaultAnim('1-9', 12), 0.08)
    frames.UP = anim8.newAnimation(defaultAnim('1-9', 9), 0.08)
    frames.DIE = anim8.newAnimation(defaultAnim('1-6', 21), 0.1)

    -- Hand animations
    frames.HAND_UP = anim8.newAnimation(defaultAnim('1-6', 13), 0.085)
    frames.HAND_LEFT = anim8.newAnimation(defaultAnim('1-6', 14), 0.085)
    frames.HAND_DOWN = anim8.newAnimation(defaultAnim('1-6', 15), 0.085)
    frames.HAND_RIGHT = anim8.newAnimation(defaultAnim('1-6', 16), 0.085)

    -- Axe animations
    frames.AXE_UP = anim8.newAnimation(defaultAnim('7-12', 13), 0.085)
    frames.AXE_LEFT = anim8.newAnimation(defaultAnim('7-12', 14), 0.085)
    frames.AXE_RIGHT = anim8.newAnimation(defaultAnim('7-12', 16), 0.085)
    frames.AXE_DOWN = anim8.newAnimation(defaultAnim('7-12', 15), 0.085)

    -- Set the default animation
    Player.animation = frames[MOVE_DIRECTION]
end

function Player.updateInput(Input)
    if Input:down('up') then
        MOVE_DIRECTION = buttons.UP
        MAIN_ACTION = actions.WALKING
    elseif Input:down("left") then
        MOVE_DIRECTION = buttons.LEFT
        MAIN_ACTION = actions.WALKING
    elseif Input:down("down") then
        MOVE_DIRECTION = buttons.DOWN
        MAIN_ACTION = actions.WALKING
    elseif Input:down("right") then
        MOVE_DIRECTION = buttons.RIGHT
        MAIN_ACTION = actions.WALKING
    elseif Input:down("action") then
        MAIN_ACTION = actions.ATTACK
    else
        MAIN_ACTION = actions.STANDING
    end
end

function Player.getTool()
    local toolBoundingBox = toolBoundingBox[SELECTED_TOOL]
    return toolBoundingBox, toolBoundingBox[MOVE_DIRECTION]
end

function Player.update(dt, Input)
    Player.updateInput(Input)
    Player.animation:update(dt)
    Player.isMoving = MAIN_ACTION == actions.WALKING

    if SELECTED_TOOL then
        local toolBox, toolDirection = Player.getTool()
        Player.tool.x = Player.x + 16 + toolDirection[1]
        Player.tool.y = Player.y + 16 + toolDirection[2]
        Player.tool.h = toolBox.SIZE[1]
        Player.tool.w = toolBox.SIZE[2]
    else
        Player.tool.x = nil
        Player.tool.y = nil
    end

    -- Debugging
    Debugger.addMessage(2, "MAIN_ACTION", MAIN_ACTION)
    Debugger.addMessage(3, "MOVE_DIRECTION", MOVE_DIRECTION)
    Debugger.addMessage(4, "SELECTED_TOOL", SELECTED_TOOL)
end

function Player.move(dt)
    if MAIN_ACTION == actions.WALKING then
        -- Set the animation
        Player.animation = frames[MOVE_DIRECTION]
    elseif MAIN_ACTION == actions.STANDING then
        Player.animation:gotoFrame(1)
        Player.animation = frames[MOVE_DIRECTION]
    elseif MAIN_ACTION == actions.ATTACK then
        Player.animation = frames[SELECTED_TOOL .. "_" .. MOVE_DIRECTION]
    else
        Player.animation = frames[MOVE_DIRECTION]
        Player.animation:gotoFrame(1)
    end

    if Player.isMoving then
        if MOVE_DIRECTION == buttons.DOWN then
            Player.y = Player.y + Player.speed * dt
        elseif MOVE_DIRECTION == buttons.UP then
            Player.y = Player.y - Player.speed * dt
        elseif MOVE_DIRECTION == buttons.RIGHT then
            Player.x = Player.x + Player.speed * dt
        elseif MOVE_DIRECTION == buttons.LEFT then
            Player.x = Player.x - Player.speed * dt
        end
    end
end

function Player.draw()
    love.graphics.setColor(255, 255, 255)
    Player.animation:draw(Player.image, Player.x, Player.y)

    -- Draw item collision
    if Player.tool.x and Player.tool.y then
        local toolCollision = Player.getTool()
        love.graphics.setColor(0, 255, 60, 0.5)
        love.graphics.rectangle("fill", Player.tool.x, Player.tool.y, Player.tool.h, Player.tool.w)
    end
end

return Player
