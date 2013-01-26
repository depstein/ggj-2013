PhysicsGameObject = GameObject:new()
PhysicsGameObject.type = "PhysicsGameObject"

function PhysicsGameObject:init(asset, options)
	options = options or {}
	GameObject.init(self, asset, options)
	self:createPhysicsObject()

	return self
end

function PhysicsGameObject:moveInDirection(x, y)
	if (not self.physics) then return end

	self.body:applyForce(x * self.speed, y * self.speed)
end

function PhysicsGameObject:createPhysicsObject(options)
	options = options or {}

	if (not options.sprite) then
		options.sprite = self.asset.filename
	end	

	self.body, self.shapes = PhysicsData.fromSprite(options)

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

	self.handle = self.body
	self.physics = true
end