Color = require('lib.color')

World = {}

function World:load()
	World.backgroundColor = Color:get("green") 
end

function World:update(dt)

end


function World:draw()
	love.graphics.setBackgroundColor(Color:get('green'))
end

return World
