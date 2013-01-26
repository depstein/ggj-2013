KeyboardManager = {}
KeyboardManager.Keys = {
	w = 119,
	a = 97,
	s = 115,
	d = 100
}
KeyboardManager.Down = {}
KeyboardManager.Callbacks = {}

KeyboardManager.setCallback = function(key, name, callback)
	KeyboardManager.Callbacks[key] = KeyboardManager.Callbacks[key] or {}

	KeyboardManager.Callbacks[key][name] = callback
end

KeyboardManager.removeCallback = function(key, name)
	if (KeyboardManager.Callbacks[key] == nil) then return end

	KeyboardManager.Callbacks[key][name] = nil
end

KeyboardManager.onKeyboardEvent = function(key, down)
	if (KeyboardManager.Down[key] ~= down) then
		if (KeyboardManager.Callbacks[key] ~= nil) then
			for k, v in pairs(KeyboardManager.Callbacks[key]) do 
				v(down)
			end
		end
	end
	KeyboardManager.Down[key] = down
end

MOAIInputMgr.device.keyboard:setCallback ( KeyboardManager.onKeyboardEvent )

