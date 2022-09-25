local Background = {}

function Background.load()
    img = love.graphics.newImage("textures/grass_1.png")
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    img:setWrap('repeat', 'repeat')

    imageWidth = img:getWidth()
    imageHeight = img:getHeight()

    return img, love.graphics.newQuad(0, 0, width, height, imageWidth, imageHeight) 
end

function Background.fill(image, quad)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(image, quad, 0, 0)
end

return Background
