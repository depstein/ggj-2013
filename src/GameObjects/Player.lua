require "BulletManager"
require "Character"

Player = Character:new()
Player.type = "Player"

function Player:init(asset, options) 
	options = options or {}
	options.ignoreGravity = false
	Character.init(self, asset, options)

	self.speed = 3000
	self.angleFactor = 10
	self.curAngle = 0
    self.angleChange = 0
    self.keysPressed = {}
    self.health = 5

    if(not options.disableControls) then
	    self:initControls()
    end

    local cpSpace = Game.sceneManager:getCpSpace()
	ropeBody = MOAICpBody.new(MOAICp.INFINITY, MOAICp.INFINITY)
	local ropeShape = ropeBody:addCircle(5, 0, 0)
	ropeShape:setIsSensor(true)

	cpSpace:insertPrim(ropeBody)
	cpSpace:insertPrim(ropeShape)

	self.ropeBody = ropeBody
	self.ropeShape = ropeShape

	local particleTimer = 0

	corout(function()
		self.system, self.emitter = Game.particleManager:addParticle('engine.pex', 0, 0, -1)
		self.emitter:setEmission(0)
	end)

	timedCorout(function(time)
		while true do
			local x, y = self.handle:getVel()
            local desiredAngle = math.atan2(y, x) + math.pi / 2
            local diff = desiredAngle - self.curAngle

            while(math.abs(diff) > math.pi) do 
                self.curAngle = self.curAngle + math.sign(diff) * 2 * math.pi 
                diff = desiredAngle - self.curAngle
            end

            local change = time * math.sign(desiredAngle - self.curAngle) * self.angleFactor
            if(math.abs(diff) < math.abs(change)) then change = diff end
    
			self.curAngle = self.curAngle + change

			self.handle:setAngle(self.curAngle)

			local angle = self.curAngle + math.pi / 2
			local handleposx, handleposy = self.handle:getPos()
			handleposx = handleposx + math.cos(angle) * 40
			handleposy = handleposy + math.sin(angle) * 40
			self.ropeBody:setPos(handleposx, handleposy)

			self.emitter:setLoc(handleposx, handleposy)

			coroutine.yield()
		end
	end)

	self:setType(SceneManager.OBJECT_TYPES.PLAYER)
	return self
end

function Player:getSpeed()
	local speed = self.speed
	if (self.carryingRope) then
		speed = self.speed * .75
	end
	return speed
end

function Player:attemptMove(x, y)
	self:moveInDirection(x, y)
end

function Player:startShooting()
    local previousSpawn = -1
	self.shooting = true
	corout(function()
		while self.shooting and not self.carryingRope do
            local currentTime = MOAISim.getDeviceTime()
        	local time = currentTime - previousSpawn
            if time > 0.25 then
    			local playerX, playerY = self:getPos()
    			local pointerX, pointerY = MOAIInputMgr.device.pointer:getLoc()
    			local destX, destY = Game.sceneManager:getDefaultLayer():wndToWorld(pointerX, pointerY)
                local angle = math.atan2(destY - playerY, destX - playerX)
            	local xAngle, yAngle = math.cos(angle), math.sin(angle)
                local posX, posY = playerX + xAngle * 50, playerY + yAngle * 50
                local velX, velY = Bullet.INITIAL_SPEED * xAngle, Bullet.INITIAL_SPEED * yAngle


                if(Game.communicationManager.isServer) then
        			local bullet = Game.bulletManager:Create()
                	bullet:setPos(posX, posY)
                	bullet.handle:setVel(velX, velY)
                else
        			local bullet = Game.bulletManager:CreateTemp()
                	bullet:setPos(posX, posY)
                	bullet.handle:setVel(velX, velY)

                    Game.communicationManager:Fired({tmpid = bullet.tmpid, x = posX, y = posY, vx = velX, vy = velY})
                end

                previousSpawn = currentTime;
    		end
            coroutine.yield()
    	end
	end)
end

function Player:endShooting()
	self.shooting = false
end

function Player:dropRope()
	self.carryingRope = false
	for k, v in pairs(self.joints) do
		self:removeJoint(k)
	end
end

function Player:isEmittingParticles()
	return next(self.keysPressed) ~= nil
end

function Player:startEmittingParticles(key)
	self.keysPressed[key] = true
	if (self:isEmittingParticles()) then
		self.emitter:setEmission(20)
	end
end

function Player:endEmittingParticles(key)
	self.keysPressed[key] = nil
	if (not self:isEmittingParticles()) then
		self.emitter:setEmission(0)
	end
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
			self:startEmittingParticles(Game.keyboardManager.KEYS.w)
			self:attemptMove(0, -1)
		else
			self:endEmittingParticles(Game.keyboardManager.KEYS.w)
			self:attemptMove(0, 1)
		end
	end)

	Game.keyboardManager:addCallback(Game.keyboardManager.KEYS.s, "moveBackwards", function(down)
		if (down) then
			self:startEmittingParticles(Game.keyboardManager.KEYS.a)
			self:attemptMove(0, 1)
		else
			self:endEmittingParticles(Game.keyboardManager.KEYS.a)
			self:attemptMove(0, -1)
		end
	end)

	Game.keyboardManager:addCallback(Game.keyboardManager.KEYS.a, "moveLeft", function(down)
		if (down) then
			self:startEmittingParticles(Game.keyboardManager.KEYS.s)
			self:attemptMove(-1, 0)
		else
			self:endEmittingParticles(Game.keyboardManager.KEYS.s)
			self:attemptMove(1, 0)
		end
	end)

	Game.keyboardManager:addCallback(Game.keyboardManager.KEYS.d, "moveRight", function(down)
		if (down) then
			self:startEmittingParticles(Game.keyboardManager.KEYS.d)
			self:attemptMove(1, 0)
		else
			self:endEmittingParticles(Game.keyboardManager.KEYS.d)
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

	Game.mouseManager:addCallback(Game.mouseManager.BUTTONS.RIGHT, "dropRope", function(x, y, down)
		if (down) then
			self:dropRope()
		end
	end)
end