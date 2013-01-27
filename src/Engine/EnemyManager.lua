<<<<<<< HEAD
require "Enemy"
require "Colors"
EnemyManager = {previousSpawn=0}
Enemies = {}

function EnemyManager.Update()
	while true do
		local currentTime = MOAISim.getElapsedTime()
		EnemyManager.SpawnEnemy(currentTime)
		coroutine.yield()
	end
end

function EnemyManager.SpawnEnemy(currentTime)
	local time = currentTime - EnemyManager.previousSpawn
	if time > 1 then
		local enemy = Enemy:new():init(TextureAsset.get("enemy.png"), {color=Colors.papaya_whip, ignoreGravity=true})
		enemy:setPos(200, 0)
		table.insert(Enemies, enemy)
		EnemyManager.previousSpawn = currentTime
	end
=======
require "Enemy"
require "Colors"
EnemyManager = {previousSpawn=MOAISim.getDeviceTime()}
Enemies = {}

function EnemyManager.Update()
	while true do
		local currentTime = MOAISim.getDeviceTime()
		EnemyManager.SpawnEnemy(currentTime)
		coroutine.yield()
	end
end

function EnemyManager.SpawnEnemy(currentTime)
	local time = currentTime - EnemyManager.previousSpawn
	if time > 1 then
		local enemy = Enemy:new():init(TextureAsset.get("enemy.png"), {color=Colors.papaya_whip, ignoreGravity=true})
		enemy:setPos(50, 50)
		table.insert(Enemies, enemy)
		EnemyManager.previousSpawn = currentTime
	end
>>>>>>> e64d2c33ab42e4f59235a8208c1a6b3c69d56c5f
end