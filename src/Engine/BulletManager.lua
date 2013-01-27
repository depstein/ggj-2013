require "Utility"
require "PhysicsGameObject"

BulletManager = Class:new()
BulletManager.type = "BulletManager"

function BulletManager:init()
    self.bullets = {}

    return self;
end

local previousSpawn = 0

function BulletManager:SpawnBullet(currentTime, x, y, destX, destY)
	local time = currentTime - previousSpawn
	if time > 0.25 then
		local bullet = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {color = Colors.cosmic_latte, ignoreGravity = true})
		local angle = math.atan2(destY-y, destX-x)
		local xAngle = math.cos(angle)
		local yAngle = math.sin(angle)

		bullet:setPos(x+xAngle*50, y+yAngle*50)
		bullet.speed = 1000
		bullet.handle:setVel(bullet.speed*xAngle, bullet.speed*yAngle)

		table.insert(self.bullets, bullet)
		previousSpawn = currentTime
	end
end