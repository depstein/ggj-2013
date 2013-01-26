Character = PhysicsGameObject:new()
Character.type = "Character"

function Character:init(asset, options) 
	options = options or {}
	PhysicsGameObject.init(self, asset, options)

	self.speed = 1000
end