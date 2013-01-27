require "BulletManager"
require "Character"

Player = Character:new()
Player.type = "Player"

function Player:init(asset, options) 
	options = options or {}
	options.ignoreGravity = true
	Character.init(self, asset, options)

	self.speed = 3000
	self.angleFactor = 10
	self.curAngle = 0
    self.angleChange = 0

    if(not options.disableControls) then
	    self:initControls()
    end

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
			coroutine.yield()
		end
	end)

	self:setType(SceneManager.OBJECT_TYPES.PLAYER)
	return self
end

function Player:attemptMove(x, y)
	self:moveInDirection(x, y)
end

function Player:startShooting()
    local previousSpawn = -1
	self.shooting = true
	corout(function()
		while self.shooting do
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
                
                print(posX .. " , " .. posY)

                if(Game.communicationManager.isServer) then
        			local bullet = Game.bulletManager:Create()
                	bullet:setPos(posX, posY)
                	bullet.handle:setVel(velX, velY)
                else
                    Game.communicationManager:Fired({x = posX, y = posY, vx = velX, vy = velY})
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