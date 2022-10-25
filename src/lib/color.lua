Color = {
    black = {0, 0, 0},
    white = {255, 255, 255},
    gray = {224, 224, 224},
    green = {48, 129, 54},
	yellow = {251, 192, 45}
}

function Color:get(name)
    return love.math.colorFromBytes(Color[name])
end

return Color
