require "Utility"
require "Bullet"

BulletManager = Class:new()
BulletManager.type = "BulletManager"

function BulletManager:init()
	self.bullets = {}
	self.temporary = {}
	self.onBulletDie = nil

    -- PRIVATE
    self._bulletIndex = 1
    self._tempIndex = 1

    return self;
end

local previousSpawn = 0

function BulletManager:CreateTemp()
	local tmpid = self._tempIndex
	self._tempIndex = self._tempIndex + 1

    local bullet = self:Create()
    bullet.tmpid = tmpid

    self.temporary[tmpid] = bullet.id

    return bullet
end

function BulletManager:DestroyTemp(id)
    self:Destroy(self.temporary[id])
    self.temporary[id] = nil
end

function BulletManager:Create()
	local id = self._bulletIndex
	self._bulletIndex = self._bulletIndex + 1

	local bullet = Bullet:new():init(id, TextureAsset.get("bullet.png"), {color = Game.colors.cosmic_latte, ignoreGravity = true})
	bullet.damage = 1
	self.bullets[id] = bullet

	corout(
		function() 
			while(true) do
				vX, vY = bullet.handle:getVel()
				v = math.sqrt(vX^2 + vY^2)
				if v < 400 then
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

function BulletManager:markImpact(x, y)
	Game.particleManager:addParticle('hit.pex', x, y, 5)
end