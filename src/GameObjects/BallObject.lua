require "PhysicsGameObject"

BallObject = PhysicsGameObject:new()
BallObject.type = "BallObject"

function BallObject:init(asset, options) 
	options = options or {}

	PhysicsGameObject.init(self, asset, options)

	self:setType(tableaddr(BallObject))

	self:setColor(Game.colors.android_green)

	return self
end