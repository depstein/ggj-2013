require "Utility"

MouseManager = Class:new()
MouseManager.type = "MouseManager"

MouseManager.BUTTONS = {
	LEFT = 0,
	RIGHT = 1
}

function MouseManager:init()
    self.clicked = {}
    self.callbacks = {}

    MOAIInputMgr.device.mouseLeft:setCallback( 
    	function(down)
    		mX, mY = MOAIInputMgr.device.pointer:getLoc()
    		self:onLeftMouseEvent(mX, mY, down)
    	end
    )

    MOAIInputMgr.device.mouseRight:setCallback( 
    	function(down)
    		mX, mY = MOAIInputMgr.device.pointer:getLoc()
    		self:onRightMouseEvent(mX, mY, down)
    	end
    )

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
	self:onMouseEvent(x, y, self.BUTTONS.LEFT, down)
end

function MouseManager:onRightMouseEvent(x, y, down)
	self:onMouseEvent(x, y, self.BUTTONS.RIGHT, down)
end



