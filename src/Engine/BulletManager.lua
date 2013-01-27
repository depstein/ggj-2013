BulletManager = {previousSpawn=0}
Bullets = {}

function BulletManager.SpawnBullet(currentTime, x, y, destX, destY)
	time = currentTime - BulletManager.previousSpawn
	if time > 0.25 then
		local bullet = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {color=Colors.cosmic_latte, ignoreGravity=true})
		angle = math.atan2(destY-y, destX-x)
		xAngle = math.cos(angle)
		yAngle = math.sin(angle)

		bullet:setPos(x+xAngle*50, y+yAngle*50)
		bullet.speed = 1000
		bullet.handle:setVel(bullet.speed*xAngle, bullet.speed*yAngle)
		table.insert(Bullets, bullet)
		BulletManager.previousSpawn = currentTime
	end
end