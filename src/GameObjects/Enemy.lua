require "Character"

Enemy = Character:new()
Enemy.type = "Enemy"

function Enemy:init(id, asset, options) 
	options = options or {}
	Character.init(self, asset, options)

    self.id = id
	self.speed = 500

	self:setType(SceneManager.OBJECT_TYPES.ENEMY)

	self.previousSpawn = MOAISim.getDeviceTime()
	corout(function()
		while true do
            local currentTime = MOAISim.getDeviceTime()
        	local time = currentTime - self.previousSpawn
            if time > .05 then

            	--for k,v in pairs(Game.players) do
            	local angle = 0
            	local player;
            	d = self:canSee(Game.players[1])
            	mX,mY = self.handle:getPos()
            	--end
            	if d then

            		eX,eY = Game.players[1].handle:getPos()
            		--print(eX .. " " .. eY)
            		angle = math.atan2(eY-mY,eX-mX)
            		--print(angle)
            	else
            		angle = math.random() * 2*math.pi
            	end


            	self.previousSpawn = MOAISim.getDeviceTime()
            	local x = math.cos(angle)
            	local y = math.sin(angle)

            	if d then
					self.handle:setForce(self.speed * x, self.speed * y)
            	else
            		self.speed = 50
            		self:moveInDirection(x, y)
            	end
        	else	
        		coroutine.yield()
        	end
         end
    end)
	return self
end

function pack(...)
	return arg
end

function Enemy:canSee(player)
	--Retrieves a list of shaps that overlap the segment specified, that exists on the specified layer 
	--(or any layer if nil) and is part of the specified group (or any group if nil).

	--function shapeListForSegment ( MOAICpSpace self, number x1, number y1, number x2, number y2 [, number layers, number group ] )
	mX,mY = self.handle:getPos()
	eX,eY = player.handle:getPos()
	local shapeList = Game.sceneManager.space:shapeListForSegment(mX,mY,eX,eY,nil,SceneManager.OBJECT_TYPES.SEE_OVER)


	if shapeList then
		num=0
		for k,v in pairs(pack(shapeList)) do
			if(type(v) == "userdata") then
				local go = v:getBody().gameObject

				if go and go.type then
					if go.type == "PhysicsGameObject" then
						return false
					end
				end
			end
			num = num+1

		end
	end
	return true
end