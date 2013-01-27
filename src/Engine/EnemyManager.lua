require "Enemy"

EnemyManager = Class:new()
EnemyManager.type = "AssetManager"

function EnemyManager:init()
    self.enemies = {}

    return self;
end

local previousSpawn = MOAISim.getDeviceTime()

function EnemyManager:Update()
	while true do
		local currentTime = MOAISim.getDeviceTime()
		self:SpawnEnemy(currentTime)
		coroutine.yield()
	end
end

function EnemyManager:SpawnEnemy(currentTime)
	local time = currentTime - previousSpawn
	if time > 1 then
		local enemy = Enemy:new():init(TextureAsset.get("enemy.png"), {color=Colors.papaya_whip, ignoreGravity=true})
		enemy:setPos(50, 50)

		table.insert(self.enemies, enemy)
		previousSpawn = currentTime
	end
end