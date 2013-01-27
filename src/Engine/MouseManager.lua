require "MouseManager"

MouseManager = Class:new()
MouseManager.type = "MouseManager"

MouseManager.BUTTONS = {
	left = 0,
	right = 1
}

function MouseManager:init()
    self.clicked = {}
    self.callbacks = {}

    return self;
end

function MouseManager:addCallback(button, name, callback)
	self.callbacks[button] = self.callbacks[button] or {}

	self.callbacks[button][name] = callback
end

function MouseManager:removeCallback(button, name)
	if (self.callbacks[button] == nil) then return end

	self.callbacks[button][name] = nil
end

function MouseManager:onMouseEvent(x, y, button, down)
	if (self.clicked[button] ~= down) then
		if (self.callbacks[button] ~= nil) then
			for k, v in pairs(self.callbacks[button]) do 
				v(x, y, down)
			end
		end
	end
	self.clicked[button] = down
end

function MouseManager:onLeftMouseEvent(x, y, down)
	MouseManager.onMouseEvent(x, y, MouseManager.Buttons.left, down)
end

function MouseManager:onRightMouseEvent(x, y, down)
	MouseManager.onMouseEvent(x, y, MouseManager.Buttons.right, down)
end



