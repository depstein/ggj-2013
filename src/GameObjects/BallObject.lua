require "PhysicsGameObject"

BallObject = PhysicsGameObject:new()
BallObject.type = "BallObject"

function BallObject:init(asset, options) 
	options = options or {}

	PhysicsGameObject.init(self, asset, options)

	self:setType(tableaddr(BallObject))

	return self
end