require "BulletManager"

Player = Character:new()
Player.type = "Player"

function Player:init(asset, options) 
	options = options or {}
	options.ignoreGravity = true
	Character.init(self, asset, options)

	self.speed = 3000
	self.angleFactor = 50
	self.curAngle = 0
	self.desiredAngle = 0

    if(not options.disableControls) then
	    self:initControls()
    end

	timedCorout(function(time)
		while true do
			local velx, vely = self.handle:getVel()
			if (math.abs(self.curAngle) < math.rad(30) or math.sign(velx) ~= math.sign(self.curAngle)) then
				self.curAngle = self.curAngle + time * velx / self.angleFactor
			end
			self.handle:setAngle(self.curAngle)
			coroutine.yield()
		end
	end)

	self:setType(SceneManager.OBJECT_TYPES.PLAYER)
	return self
end

function Player:attemptMove(x, y)
	self:moveInDirection(x, y)

	local curx = self.handle:getForce()

	if (curx == 0) then
		self.desiredAngle = 0
	end
	if (curx > 0) then
		self.desiredAngle = math.rad(30)
	end
	if (curx < 0) then
		self.desiredAngle = math.rad(-30)
	end
end

function Player:startShooting()
	self.shooting = true
	corout(function()
		while self.shooting do
				posX, posY = self:getPos()
				dstX, dstY = MOAIInputMgr.device.pointer:getLoc()
				dstX, dstY = Game.sceneManager:getDefaultLayer():wndToWorld(dstX, dstY)
				Game.bulletManager:SpawnBullet(MOAISim.getElapsedTime(), posX, posY, dstX, dstY)
			coroutine.yield()
		end
	end)
end

function Player:endShooting()
	self.shooting = false
end

function Player:initControls()
--[[
		Sample code for using MouseManager

	MouseManager.addCallback(Game.mouseManager.BUTTONS.LEFT, "moveForward", function(x,y,down)
		if (down) then
			self:attemptMove(0, -1)
		else
			self:attemptMove(0, 1)
		end
	end)]] 



	Game.keyboardManager:addCallback(Game.keyboardManager.KEYS.w, "moveForward", function(down)
		if (down) then
			self:attemptMove(0, -1)
		else
			self:attemptMove(0, 1)
		end
	end)

	Game.keyboardManager:addCallback(Game.keyboardManager.KEYS.s, "moveBackwards", function(down)
		if (down) then
			self:attemptMove(0, 1)
		else
			self:attemptMove(0, -1)
		end
	end)

	Game.keyboardManager:addCallback(Game.keyboardManager.KEYS.a, "moveLeft", function(down)
		if (down) then
			self:attemptMove(-1, 0)
		else
			self:attemptMove(1, 0)
		end
	end)

	Game.keyboardManager:addCallback(Game.keyboardManager.KEYS.d, "moveRight", function(down)
		if (down) then
			self:attemptMove(1, 0)
		else
			self:attemptMove(-1, 0)
		end
	end)

	Game.mouseManager:addCallback(Game.mouseManager.BUTTONS.LEFT, "shoot", function(x, y, down)
		if (down) then
			self:startShooting()
		else
			self:endShooting()
		end
	end)
end