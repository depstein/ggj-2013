PhysicsGameObject = GameObject:new()
PhysicsGameObject.type = "PhysicsGameObject"

function PhysicsGameObject:init(asset, options)
	options = options or {}
	GameObject.init(self, asset, options)
	self:createPhysicsObject(options)

	self:setType(tableaddr(PhysicsGameObject))

	return self
end

function PhysicsGameObject:moveInDirection(x, y)
	if (not self.physics) then return end

	self.body:applyForce(x * self.speed, y * self.speed)
end

function PhysicsGameObject:destroy()
	SceneManager.i:getDefaultLayer():removeProp(self.prop)
	SceneManager.i:getCpSpace():removePrim(self.body)
	for i = 1,#self.shapes do
		SceneManager.i:getCpSpace():removePrim(self.shapes[i])
	end
end

function PhysicsGameObject:createPhysicsObject(options)
	options = options or {}

	if (not options.sprite) then
		options.sprite = self.asset.filename
	end	

	self.body, self.shapes = PhysicsData.fromSprite(options)

	self.body.gameObject = self

	SceneManager.i:getCpSpace():insertPrim(self.body)

	for i = 1,#self.shapes do
		if (not options.group) then
			self.shapes[i]:setGroup(tableaddr(self))
		end
		SceneManager.i:getCpSpace():insertPrim(self.shapes[i])
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
end

function PhysicsGameObject:getPos()
	return self.handle:getPos()
end

function PhysicsGameObject:setRot(angle)
	self.handle:setAngle(45)
end

function PhysicsGameObject:getRot()
	self.handle:getRot()
end