require "Utility"
require "Bullet"

BulletManager = Class:new()
BulletManager.type = "BulletManager"

function BulletManager:init()
	self.bullets = {}
	self.onBulletDie = nil

    -- PRIVATE
    self._bulletIndex = 1

    return self;
end

local previousSpawn = 0

function BulletManager:Create()
	local id = self._bulletIndex
	self._bulletIndex = self._bulletIndex + 1

	local bullet = Bullet:new():init(id, TextureAsset.get("bullet.png"), {color = Game.colors.cosmic_latte, ignoreGravity = true})
	
	self.bullets[id] = bullet

	corout(
		function() 
			while(true) do
				vX, vY = bullet.handle:getVel()
				v = math.sqrt(vX^2 + vY^2)
				if v < 20 then
					self:Destroy(bullet.id)
					break
				else
					coroutine:yield()
				end
			end
		end)
	return bullet
end

function BulletManager:Destroy(index)
	if(not self.bullets[index]) then return end
	if(self.onBulletDie) then
		self.onBulletDie(index, self.bullets[index])
	end
	self.bullets[index]:destroy()
	self.bullets[index] = nil
end