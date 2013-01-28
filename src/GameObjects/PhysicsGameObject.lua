require "GameObject"

PhysicsGameObject = GameObject:new()
PhysicsGameObject.type = "PhysicsGameObject"
PhysicsGameObject.DAMPING = .05

function PhysicsGameObject:init(asset, options)
	options = options or {}
	if (not options.damp) then
		options.damp = true
	end

	GameObject.init(self, asset, options)
	self:createPhysicsObject(options)

	self:setType(tableaddr(PhysicsGameObject))

	self.movement = { x = 0, y = 0}

	if (options.damp) then
		-- CUSTOM DAMPING
		corout(function()
			while true do
				velx, vely = self.handle:getVel()
				velx = velx * (1.0 - PhysicsGameObject.DAMPING)
				vely = vely * (1.0 - PhysicsGameObject.DAMPING)

				self.handle:setVel(velx, vely)
				coroutine.yield()
			end
		end)
	end

	return self
end

function PhysicsGameObject:getSpeed()
	return self.speed
end

function PhysicsGameObject:moveInDirection(x, y)
	if (not self.physics) then return end

	local speed = self:getSpeed()

	self.movement.x = self.movement.x + x
	self.movement.y = self.movement.y + y

	self.body:setForce(self.movement.x * speed, self.movement.y * speed)
end

function PhysicsGameObject:destroy()
	Game.sceneManager:getDefaultLayer():removeProp(self.prop)
	Game.sceneManager:getCpSpace():removePrim(self.body)
	for i = 1,#self.shapes do
		Game.sceneManager:getCpSpace():removePrim(self.shapes[i])
	end
end

function PhysicsGameObject:createPhysicsObject(options)
	options = options or {}

	if (not options.sprite) then
		options.sprite = self.asset.filename
	end	

	self.body, self.shapes = PhysicsData.fromSprite(options)

	self.body.gameObject = self

	Game.sceneManager:getCpSpace():insertPrim(self.body)

	for i = 1,#self.shapes do
		if (not options.group) then
			self.shapes[i]:setGroup(tableaddr(self))
		end
		if (options.static) then self.shapes[i]:setGroup(PhysicsData.StaticGroup) end

		Game.sceneManager:getCpSpace():insertPrim(self.shapes[i])
	end


	if self.prop then
		self.prop:setParent(self.body)
	end

	if (not options.static and not options.ignoreGravity) then
		self.body:setForce(0, SceneManager.GRAVITY)
	end

	self.handle = self.body
	self.physics = true
end

function PhysicsGameObject:setType(type)
	for k, v in pairs(self.shapes) do 
		v:setType(type)
	end
end

function PhysicsGameObject:setPos(x, y)
	self.handle:setPos(x, y)
    self.body:forceUpdate()
end

function PhysicsGameObject:getPos()
	return self.handle:getPos()
end

function PhysicsGameObject:setRot(angle)
	self.handle:setAngle(angle)
end

function PhysicsGameObject:getRot()
	self.handle:getRot()
end