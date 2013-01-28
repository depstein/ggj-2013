require "BulletManager"
require "Character"

Player = Character:new()
Player.type = "Player"

function Player:init(asset, options) 
	options = options or {}
	options.ignoreGravity = false
	Character.init(self, asset, options)

	self.speed = 4000
	self.angleFactor = 10
	self.curAngle = 0
    self.angleChange = 0
    self.keysPressed = {}
    self.health = 5
    self.damage = 1
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

			coyield()
		end
	end)

	self:setType(SceneManager.OBJECT_TYPES.PLAYER)
	return self
end

function Player:removeCallbacks()
	Game.keyboardManager:removeCallback(Game.keyboardManager.KEYS.w, "moveForward")
	Game.keyboardManager:removeCallback(Game.keyboardManager.KEYS.s, "moveBackwards")
	Game.keyboardManager:removeCallback(Game.keyboardManager.KEYS.a, "moveLeft")
	Game.keyboardManager:removeCallback(Game.keyboardManager.KEYS.d, "moveRight")
	Game.mouseManager:removeCallback(Game.mouseManager.BUTTONS.LEFT, "shoot")
	Game.mouseManager:removeCallback(Game.mouseManager.BUTTONS.RIGHT, "dropRope")
end

function Player:changeHealth(amt)
	self.health = self.health + amt
	print(self.health .. " hp")
	if self.health == 3 then
		self:setAsset(TextureAsset.get("player-damaged1.png"))
	elseif self.health==1 then
		self:setAsset(TextureAsset.get("player-damaged2.png"))
	end
	if self.health <= 0 and not(self.body:isSleeping()) then
		self.keysPressed = nil
		self:setAsset(TextureAsset.get("player-dead.png"))
		self:dropRope()
		self:endShooting()
		self.body:sleep()
		self:removeCallbacks()
		self.handle:setVel(0, 0)
		self.handle:resetForces()
		self.speed = 0
		self.dead = true
		self.emitter:setEmission(0)
		Game.sceneManager.camera:setAttrLink(MOAITransform.INHERIT_LOC, Game.players[2].handle, MOAITransform.TRANSFORM_TRAIT)
	end
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
    if self.health <= 0 then
    	return
    end
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
        			bullet.damage = self.damage
                	bullet:setPos(posX, posY)
                	bullet.handle:setVel(velX, velY)
                else
        			local bullet = Game.bulletManager:CreateTemp()
                	bullet:setPos(posX, posY)
                	bullet.handle:setVel(velX, velY)

                    Game.communicationManager:Fired({tmpid = bullet.tmpid, d = self.damage, x = posX, y = posY, vx = velX, vy = velY})
                end

                previousSpawn = currentTime;
    		end
            coyield()
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
	if not self.keysPressed then return false end
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

function Player:flashBuff(name)
	local buff = GameObject:new():init(TextureAsset.get("buff-" .. name .. ".png"))
	buff.prop:setLoc(self.handle:getPos())
	buff.prop:seekScl(1.5, 1.5, 2)
	buff.prop:seekColor(0, 0, 0, 0, 2)

	corout(function()
		while true do
			if (buff.prop:getScl() >= 1.5) then
				buff:destroy()
			end
			coroutine.yield()
		end
	end)
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

	if self.health > 0 then
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
	else

	end
end