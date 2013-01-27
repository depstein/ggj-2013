require "BulletManager"
require "Character"

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
    local previousSpawn = -1
	self.shooting = true
	corout(function()
		while self.shooting do
            local currentTime = MOAISim.getDeviceTime()
        	local time = currentTime - previousSpawn
            if time > 0.25 then
    			local x, y = self:getPos()
    			local pX, pY = MOAIInputMgr.device.pointer:getLoc()
    			local destX, destY = Game.sceneManager:getDefaultLayer():wndToWorld(pX, pY)
    			local bullet = Game.bulletManager:Create()
                local angle = math.atan2(destY - y, destX - x)
            	local xAngle = math.cos(angle)
            	local yAngle = math.sin(angle)
            
            	bullet:setPos(x + xAngle * 50, y + yAngle * 50)
            	bullet.handle:setVel(bullet.speed * xAngle, bullet.speed * yAngle)
    			coroutine.yield()
                previousSpawn = currentTime;
    		end
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