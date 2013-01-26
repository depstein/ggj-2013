Player = Character:new()
Player.type = "Player"

function Player:init(asset, options) 
	options = options or {}
	Character.init(self, asset, options)

	self.speed = 2000
	self:initControls()

	corout(function()
		while true do
			self.handle:setAngle(0)
			coroutine.yield()
		end
	end)

	return self
end

function Player:attemptMove(x, y)
	self:moveInDirection(x, y)
end

function Player:initControls()
	KeyboardManager.setCallback(KeyboardManager.Keys.w, "moveForward", function(down)
		if (down) then
			self:attemptMove(0, -1)
		else
			self:attemptMove(0, 1)
		end
	end)

	KeyboardManager.setCallback(KeyboardManager.Keys.s, "moveBackwards", function(down)
		if (down) then
			self:attemptMove(0, 1)
		else
			self:attemptMove(0, -1)
		end
	end)

	KeyboardManager.setCallback(KeyboardManager.Keys.a, "moveLeft", function(down)
		if (down) then
			self:attemptMove(-1, 0)
		else
			self:attemptMove(1, 0)
		end
	end)

	KeyboardManager.setCallback(KeyboardManager.Keys.d, "moveRight", function(down)
		if (down) then
			self:attemptMove(1, 0)
		else
			self:attemptMove(-1, 0)
		end
	end)
end