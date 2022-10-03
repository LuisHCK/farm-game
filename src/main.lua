function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    stalkerX = require 'lib.Camera'
    camera = stalkerX()
    Player = require 'engine.player'
    backgroundController = require 'engine.background'
    Baton = require 'lib.baton'
    Debugger = require 'lib.debugger'
    Grid = require('engine.gridsys')
    Objects = require('engine.objects')

    Player.load()

    backgroundImg, backgroundQuad = backgroundController.load()

    Input = Baton.new {
        controls = {
            left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
            action = {'key:x', 'button:a', 'mouse:1'},
            next = {'key:1'},
            prev = {'key:2'}
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1]
    }

end

function love.update(dt)
    Input:update()
    camera:update(dt)
    Player.update(dt, Input)
    Player.move(dt)
    -- Grid system
    local playerTool = Player.tool
    Grid.update(playerTool.x, playerTool.y, playerTool.h, playerTool.w)

    Debugger.addMessage(1, "FPS", love.timer.getFPS())
end

function love.draw()
    -- camera:attach()

    -- Draw your game here
    backgroundController.fill(backgroundImg, backgroundQuad)

    -- Draw grid
    Grid.draw()

    -- Player draw
    Player.draw()

    -- Objects
    Objects.draw()

    -- Camera stuff
    -- camera:draw()
    -- camera:detach()

    Debugger.drawMessages()
end