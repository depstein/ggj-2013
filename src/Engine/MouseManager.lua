MouseManager = {}
MouseManager.Buttons = {
	left = 0,
	right = 1
}
MouseManager.Clicked = {}
MouseManager.Callbacks = {}

MouseManager.setCallback = function(button, name, callback)
	MouseManager.Callbacks[button] = MouseManager.Callbacks[button] or {}

	MouseManager.Callbacks[button][name] = callback
end

MouseManager.removeCallback = function(button, name)
	if (MouseManager.Callbacks[button] == nil) then return end

	MouseManager.Callbacks[button][name] = nil
end

MouseManager.onMouseEvent = function(x, y, button, down)
	if (MouseManager.Clicked[button] ~= down) then
		if (MouseManager.Callbacks[button] ~= nil) then
			for k, v in pairs(MouseManager.Callbacks[button]) do 
				v(x, y, down)
			end
		end
	end
	MouseManager.Clicked[button] = down
end

MouseManager.onLeftMouseEvent = function(x, y, down)
	MouseManager.onMouseEvent(x, y, MouseManager.Buttons.left,down)
end

MouseManager.onRightMouseEvent = function(x, y, down)
	MouseManager.onMouseEvent(x, y, MouseManager.Buttons.right,down)
end

MOAIInputMgr.device.mouseLeft:setCallback ( 
	function(down)
		mX, mY = MOAIInputMgr.device.pointer:getLoc()
		MouseManager.onLeftMouseEvent(mX, mY, down)
		end )
MOAIInputMgr.device.mouseRight:setCallback ( 
	function(down)
		mX, mY = MOAIInputMgr.device.pointer:getLoc()
		MouseManager.onRightMouseEvent(mX, mY, down)
		end )

