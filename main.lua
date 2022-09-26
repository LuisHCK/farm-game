function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    stalkerX = require 'lib.Camera'
    camera = stalkerX()
    Player = require 'engine.player'
    backgroundController = require 'engine.background'
    Baton = require 'lib.baton'
    Debugger = require 'lib.debugger'
    Grid = require('engine.gridsys')

    Player.load()

    backgroundImg, backgroundQuad = backgroundController.load()

    Input = Baton.new {
        controls = {
            left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
            action = {'key:x', 'button:a', 'mouse:1'}
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
    Debugger.addMessage(1, "FPS", love.timer.getFPS())
end

function love.draw()
    camera:attach()
    -- Draw your game here
    backgroundController.fill(backgroundImg, backgroundQuad)
    Grid.draw(Player)
    Player.draw()
    camera:draw()

    camera:detach()

    Debugger.drawMessages()
end
