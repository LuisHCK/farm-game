local anim8 = require 'lib.anim8'
local Debugger = require 'lib.debugger'
local Grid = require 'engine.gridsys'

local Player = {
    x = 100,
    y = 100,
    speed = 150,
    image = nil,
    animation = nil,
    isMoving = false,
    tool = {
        canModifyTerrain = false,
        x = nil,
        y = nil,
        h = 0,
        w = 0
    }
}

local BUTTONS = {
    UP = "UP",
    DOWN = "DOWN",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
    DIE = "DIE"
}

local ACTIONS = {
    WALKING = "WALKING",
    STANDING = "STANDING",
    DIE = "DIE",
    USE = "USE"
}

local OBJECTS = {
    SHOVEL = "SHOVEL",
    AXE = "AXE",
    SWORD = "SWORD",
    HAND = "HAND",
}

local FRAMES = {
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

local TOOL_BOUNDING_BOX = {
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
        UP = {0, -16}
    }
}

local MOVE_DIRECTION = BUTTONS.DOWN
local MAIN_ACTION = ACTIONS.STANDING
local SELECTED_OBJECT = OBJECTS.HAND

function Player.load()
    Player.image = love.graphics.newImage('sprites/player_default.png')
    local defaultAnim = anim8.newGrid(64, 64, Player.image:getWidth(), Player.image:getHeight())

    -- Define all animations
    FRAMES.DOWN = anim8.newAnimation(defaultAnim('1-9', 11), 0.08)
    FRAMES.LEFT = anim8.newAnimation(defaultAnim('1-9', 10), 0.08)
    FRAMES.RIGHT = anim8.newAnimation(defaultAnim('1-9', 12), 0.08)
    FRAMES.UP = anim8.newAnimation(defaultAnim('1-9', 9), 0.08)
    FRAMES.DIE = anim8.newAnimation(defaultAnim('1-6', 21), 0.1)

    -- Hand animations
    FRAMES.HAND_UP = anim8.newAnimation(defaultAnim('1-6', 13), 0.085)
    FRAMES.HAND_LEFT = anim8.newAnimation(defaultAnim('1-6', 14), 0.085)
    FRAMES.HAND_DOWN = anim8.newAnimation(defaultAnim('1-6', 15), 0.085)
    FRAMES.HAND_RIGHT = anim8.newAnimation(defaultAnim('1-6', 16), 0.085)

    -- Axe animations
    FRAMES.AXE_UP = anim8.newAnimation(defaultAnim('7-12', 13), 0.085)
    FRAMES.AXE_LEFT = anim8.newAnimation(defaultAnim('7-12', 14), 0.085)
    FRAMES.AXE_RIGHT = anim8.newAnimation(defaultAnim('7-12', 16), 0.085)
    FRAMES.AXE_DOWN = anim8.newAnimation(defaultAnim('7-12', 15), 0.085)

    -- Shovel animations
    FRAMES.SHOVEL_UP = anim8.newAnimation(defaultAnim('7-12', 13), 0.085)
    FRAMES.SHOVEL_LEFT = anim8.newAnimation(defaultAnim('7-12', 14), 0.085)
    FRAMES.SHOVEL_RIGHT = anim8.newAnimation(defaultAnim('7-12', 16), 0.085)
    FRAMES.SHOVEL_DOWN = anim8.newAnimation(defaultAnim('7-12', 15), 0.085)

    -- Set the default animation
    Player.animation = FRAMES[MOVE_DIRECTION]
end

function Player.updateInput(Input)
    if Input:down("action") then
        MAIN_ACTION = ACTIONS.USE
    elseif Input:down('up') then
        MOVE_DIRECTION = BUTTONS.UP
        MAIN_ACTION = ACTIONS.WALKING
    elseif Input:down("left") then
        MOVE_DIRECTION = BUTTONS.LEFT
        MAIN_ACTION = ACTIONS.WALKING
    elseif Input:down("down") then
        MOVE_DIRECTION = BUTTONS.DOWN
        MAIN_ACTION = ACTIONS.WALKING
    elseif Input:down("right") then
        MOVE_DIRECTION = BUTTONS.RIGHT
        MAIN_ACTION = ACTIONS.WALKING
    else
        MAIN_ACTION = ACTIONS.STANDING
    end
end

local function getTool()
    local toolBoundingBox = TOOL_BOUNDING_BOX[SELECTED_OBJECT]
    return toolBoundingBox, toolBoundingBox[MOVE_DIRECTION]
end

function Player.update(dt, Input)
    Player.updateInput(Input)
    Player.animation:update(dt)
    Player.isMoving = MAIN_ACTION == ACTIONS.WALKING
    Player.selected_object = SELECTED_OBJECT

    if SELECTED_OBJECT then
        local toolBox, toolDirection = getTool()
        Player.tool.x = Player.x + 16 + toolDirection[1]
        Player.tool.y = Player.y + 16 + toolDirection[2]
        Player.tool.h = toolBox.SIZE[1]
        Player.tool.w = toolBox.SIZE[2]

        if SELECTED_OBJECT == OBJECTS.AXE or SELECTED_OBJECT == OBJECTS.SHOVEL then
            Player.tool.canModifyTerrain = true
        end
    else
        Player.tool.x = nil
        Player.tool.y = nil
        Player.tool.canModifyTerrain = false
    end

    -- Debugging
    Debugger.addMessage(2, "MAIN_ACTION", MAIN_ACTION)
    Debugger.addMessage(3, "MOVE_DIRECTION", MOVE_DIRECTION)
    Debugger.addMessage(4, "SELECTED_TOOL", SELECTED_OBJECT)
end

function Player.move(dt)
    if MAIN_ACTION == ACTIONS.WALKING then
        -- Set the animation
        Player.animation = FRAMES[MOVE_DIRECTION]
    elseif MAIN_ACTION == ACTIONS.STANDING then
        Player.animation:gotoFrame(1)
        Player.animation = FRAMES[MOVE_DIRECTION]
    elseif MAIN_ACTION == ACTIONS.USE then
        if SELECTED_OBJECT == OBJECTS.AXE or SELECTED_OBJECT == OBJECTS.HAND or SELECTED_OBJECT == OBJECTS.SHOVEL or
            SELECTED_OBJECT == OBJECTS.SWORD then
            Player.animation = FRAMES[SELECTED_OBJECT .. "_" .. MOVE_DIRECTION]
            Grid.placeObject("HOLE")
        end
    else
        Player.animation = FRAMES[MOVE_DIRECTION]
        Player.animation:gotoFrame(1)
    end

    if Player.isMoving then
        if MOVE_DIRECTION == BUTTONS.DOWN then
            Player.y = Player.y + Player.speed * dt
        elseif MOVE_DIRECTION == BUTTONS.UP then
            Player.y = Player.y - Player.speed * dt
        elseif MOVE_DIRECTION == BUTTONS.RIGHT then
            Player.x = Player.x + Player.speed * dt
        elseif MOVE_DIRECTION == BUTTONS.LEFT then
            Player.x = Player.x - Player.speed * dt
        end
    end
end

function Player.draw()
    love.graphics.setColor(255, 255, 255)
    Player.animation:draw(Player.image, Player.x, Player.y)

    -- Draw item collision
    if Player.tool.x and Player.tool.y then
        local toolCollision = getTool()
        love.graphics.setColor(0, 255, 60, 0.5)
        love.graphics.rectangle("fill", Player.tool.x, Player.tool.y, Player.tool.h, Player.tool.w)
    end
end

return Player
