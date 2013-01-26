Enemy = Character:new()
Enemy.type = "Enemy"

function Enemy:init(asset, options) 
	options = options or {}
	Character.init(self, asset, options)

	self.speed = 1000

	return self
end