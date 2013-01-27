require "Utility"
require "KeyboardManager"

GameManager = Class:new()
GameManager.type = "GameManager"


function GameManager:init()

    self.KeyboardManager = KeyboardManager:new():init();

    MOAIInputMgr.device.keyboard:setCallback ( self.keyboardManager:onKeyboardEvent )

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

    return self;
end
