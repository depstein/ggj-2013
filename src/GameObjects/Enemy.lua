require "Character"

Enemy = Character:new()
Enemy.type = "Enemy"

function Enemy:init(id, asset, options) 
	options = options or {}
	Character.init(self, asset, options)

    self.id = id
	self.basespeed = 500
	self.health = 1
	self.dashChance = .04
	self:setType(SceneManager.OBJECT_TYPES.ENEMY)

	local previousSpawn = MOAISim.getDeviceTime()
	corout(function()
		while true do
            local currentTime = MOAISim.getDeviceTime()
        	local time = currentTime - previousSpawn
            if time > .05 then
            	local angle = 0
            	local player;
            	d = self:canSee(Game.players[1])
            	mX,mY = self.handle:getPos()

            	if d then
            		eX,eY = Game.players[1].handle:getPos()
            		angle = math.atan2(eY-mY,eX-mX)
            	else
            		angle = math.random() * 2*math.pi
            	end


            	previousSpawn = MOAISim.getDeviceTime()
            	local x = math.cos(angle)
            	local y = math.sin(angle)

            	if d then
            		self.speed = self.basespeed
					self.handle:setForce(self.speed * x, self.speed * y)
            	else
            		self.speed = 50
            		self:moveInDirection(x, y)
            	end

            	if math.random() < self.dashChance then
            		self.speed = self.basespeed*10
            		self.handle:applyForce(x*self.speed, y*self.speed,0,0)
            	end

        	else	
        		coroutine:yield()
        	end
         end
    end)
	return self
end

function pack(...)
	return arg
end

function Enemy:canSee(player)
	return true
	--Retrieves a list of shaps that overlap the segment specified, that exists on the specified layer 
	--(or any layer if nil) and is part of the specified group (or any group if nil).

	--function shapeListForSegment ( MOAICpSpace self, number x1, number y1, number x2, number y2 [, number layers, number group ] )
	--[[mX,mY = self.handle:getPos()
	eX,eY = player.handle:getPos()
	shapeList = Game.sceneManager.space:shapeListForSegment(mX,mY,eX,eY,nil,SceneManager.OBJECT_TYPES.SEE_OVER)


	if shapeList then
		num=0
		for k,v in pairs(pack(shapeList)) do
			if(type(v) == "userdata") and v:getBody() then
				local go = v:getBody().gameObject

				if go.type then
					if go.type == "PhysicsGameObject" then
						return false
					end
				end
			end
			num = num+1

		end
	end
	return true--]]
end