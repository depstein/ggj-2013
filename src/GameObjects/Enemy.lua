require "Character"

Enemy = Character:new()
Enemy.type = "Enemy"

function Enemy:init(id, asset, options) 
	options = options or {}
	Character.init(self, asset, options)

    self.id = id
	self.speed = 1000

	self:setType(SceneManager.OBJECT_TYPES.ENEMY)

	return self
end