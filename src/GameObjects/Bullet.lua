require "PhysicsGameObject"

Bullet = PhysicsGameObject:new()
Bullet.type = "Bullet"
Bullet.INITIAL_SPEED = 1500

function Bullet:init(id, asset, options) 
	options = options or {}

	PhysicsGameObject.init(self, asset, options)


    self.id = id
	self.speed = Bullet.INITIAL_SPEED

	self:setType(SceneManager.OBJECT_TYPES.BULLET)

	return self
end