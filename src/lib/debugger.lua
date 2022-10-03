local Debugger = {}
Debugger.messages = {}

local startPoint = 0

function Debugger.addMessage(slot, name, value)
	Debugger.messages[slot] = tostring(name) .. ": " .. tostring(value)
end

function Debugger.drawMessages()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(table.concat(Debugger.messages, "\n"), 16, 16)
end

return Debugger
