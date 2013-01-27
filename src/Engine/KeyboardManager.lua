require "Utility"

KeyboardManager = Class:new()
KeyboardManager.type = "KeyboardManager"

KeyboardManager.KEYS = {
	w = 119,
	a = 97,
	s = 115,
	d = 100
}

function KeyboardManager:init()
    self.down = {}
    self.callbacks = {}

    MOAIInputMgr.device.keyboard:setCallback (
    	function(key, down)
    		self:onKeyboardEvent(key, down)
    	end
    )

    return self;
end

function KeyboardManager:addCallback(key, name, callback)
	self.callbacks[key] = self.callbacks[key] or {}
	self.callbacks[key][name] = callback
end

function KeyboardManager:removeCallback(key, name)
	if (self.callbacks[key] == nil) then return end

	self.callbacks[key][name] = nil
end

function KeyboardManager:onKeyboardEvent(key, down)
	if (self.down[key] ~= down) then
		if (self.callbacks[key] ~= nil) then
			for k, v in pairs(self.callbacks[key]) do 
				v(down)
			end
		end
	end
	self.down[key] = down
end

