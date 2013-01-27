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