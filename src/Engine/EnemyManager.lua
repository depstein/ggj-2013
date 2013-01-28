require "Enemy"

EnemyManager = Class:new()
EnemyManager.type = "AssetManager"

function EnemyManager:init()
    -- PUBLIC
    self.enemies = {}
    self.onEnemyDie = nil
    self.spawnPoints = {}
    self.creationTime = MOAISim.getDeviceTime()
    self.currentTime = MOAISim.getDeviceTime()
    self.timeExisted = 0
    self.spawnCount = {}
    self.validSpawns = {}
    self.maxSpawn = 4
    -- PRIVATE
    self._enemyIndex = 1
    self._previousSpawn = MOAISim.getDeviceTime()

    return self;
end

function EnemyManager:Create()
    local id = self._enemyIndex
    self._enemyIndex = self._enemyIndex + 1
	local enemy = Enemy:new():init(id, TextureAsset.get("enemy.png"), {color = Game.colors.papaya_whip, ignoreGravity = true})

    local maxHp = .6 + self.timeExisted/60
    enemy.health = math.ceil(maxHp / (1+math.exp(-math.random())))

    --print("Max " .. maxHp .. " HP " .. enemy.health)

    enemy.basespeed = enemy.basespeed + 6.333 * self.timeExisted
    enemy.dashChance = .04 / (1+math.exp(-self.timeExisted/30+6))

	self.enemies[id] = enemy
	enemy:setGroup(SceneManager.OBJECT_TYPES.SEE_OVER)

    return enemy
end 

function EnemyManager:SetSpawnPoints(spawns)
    self.spawnPoints = spawns
    for k, v in pairs(self.spawnPoints) do
        table.insert(self.validSpawns,k)
        self.spawnCount[k] = 0
    end
end

function EnemyManager:Destroy(index)
    if(not self.enemies[index]) then return end
    if(self.onEnemyDie) then
        self.onEnemyDie(index, self.enemies[index])
    end
    local enemyX, enemyY = self.enemies[index]:getPos()
    Game.particleManager:addParticle('enemyDeath.pex', enemyX, enemyY, 10)
    self.enemies[index]:destroy()
    self.enemies[index] = nil
end

function EnemyManager:DamageEnemy(index, amt)
    if(not self.enemies[index]) then return end

    self.enemies[index].health = self.enemies[index].health - amt
    if self.enemies[index].health <= 0 then
        local ind = self.enemies[index].spawnPoint
        self.spawnCount[ind] = self.spawnCount[ind] - 1
        if self.spawnCount[ind] < self.maxSpawn then
            table.insert(self.validSpawns, ind)
        end
        self:Destroy(index)
    end
end 

function EnemyManager:Update()
	while true do
		self.currentTime = MOAISim.getDeviceTime()
    	local time = self.currentTime - self._previousSpawn
        self.timeExisted = self.currentTime - self.creationTime
    	if time > 4 then
            if #self.validSpawns > 0 then
                local validRand = math.random(1,#self.validSpawns)
                local rand = self.validSpawns[validRand]
                if self.spawnCount[rand] < self.maxSpawn then
                    local enemy = self:Create()
        	        enemy:setPos(self.spawnPoints[rand].posX, self.spawnPoints[rand].posY)
                    enemy.spawnPoint = rand
                    self.spawnCount[enemy.spawnPoint] = self.spawnCount[enemy.spawnPoint] + 1
                else
                    table.remove(self.validSpawns, rand)
                end
            end
            self._previousSpawn = self.currentTime
    	end
		coroutine.yield()
	end
end