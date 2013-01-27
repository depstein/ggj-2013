require "Enemy"

EnemyManager = Class:new()
EnemyManager.type = "AssetManager"

function EnemyManager:init()
    -- PUBLIC
    self.enemies = {}
    self.onEnemyDie = nil

    -- PRIVATE
    self._enemyIndex = 1
    self._previousSpawn = MOAISim.getDeviceTime()

    return self;
end

function EnemyManager:Create()
    local id = self._enemyIndex
    self._enemyIndex = self._enemyIndex + 1

	local enemy = Enemy:new():init(id, TextureAsset.get("enemy.png"), {color = Game.colors.papaya_whip, ignoreGravity = true})
	self.enemies[id] = enemy

    return enemy
end 

function EnemyManager:Destroy(index)
    if(not self.enemies[index]) then return end
    if(self.onEnemyDie) then
        self.onEnemyDie(index, self.enemies[index])
    end
    self.enemies[index]:destroy()
    self.enemies[index] = nil
end

function EnemyManager:Update()
	while true do
		local currentTime = MOAISim.getDeviceTime()
    	local time = currentTime - self._previousSpawn
    	if time > 1 then
            local enemy = self:Create()
	        enemy:setPos(50, 50)
    		self._previousSpawn = currentTime
    	end
		coroutine.yield()
	end
end