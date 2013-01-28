require "Utility"
require "LevelData"

WaveManager = Class:new()
WaveManager.type = "WaveManager"

function WaveManager:init()
	self.spawnLocs = {}
	self.waveNumber = 0
	table.insert(self.spawnLocs, {5065 - LevelData.XOFF, 5701 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5018 - LevelData.XOFF, 6274 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5983 - LevelData.XOFF, 6076 - LevelData.YOFF})
	table.insert(self.spawnLocs, {6370 - LevelData.XOFF, 5956 - LevelData.YOFF})
	table.insert(self.spawnLocs, {6079 - LevelData.XOFF, 5281 - LevelData.YOFF})
	table.insert(self.spawnLocs, {6547 - LevelData.XOFF, 5434 - LevelData.YOFF})
	table.insert(self.spawnLocs, {6208 - LevelData.XOFF, 4832 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5809 - LevelData.XOFF, 4790 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5101 - LevelData.XOFF, 4946 - LevelData.YOFF})
	table.insert(self.spawnLocs, {4703 - LevelData.XOFF, 5140 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5029 - LevelData.XOFF, 4844 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5554 - LevelData.XOFF, 4817 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5863 - LevelData.XOFF, 4787 - LevelData.YOFF})
	table.insert(self.spawnLocs, {6259 - LevelData.XOFF, 4910 - LevelData.YOFF})
	table.insert(self.spawnLocs, {6478 - LevelData.XOFF, 5269 - LevelData.YOFF})
	table.insert(self.spawnLocs, {5443 - LevelData.XOFF, 5863 - LevelData.YOFF})
	table.insert(self.spawnLocs, {4562 - LevelData.XOFF, 5422 - LevelData.YOFF})
	table.insert(self.spawnLocs, {4922 - LevelData.XOFF, 4814 - LevelData.YOFF})


	self.dropLocs = {
		{ x = 4578, y = 5685, rot = 111},
		{ x = 4810, y = 5956, rot = 20},
		{ x = 5000, y = 5201, rot = -135},
	}

    return self;
end

function WaveManager:getRandomLoc()
	return self.spawnLocs[math.random(#self.spawnLocs)]
end

function WaveManager:getRandomReceptacle() 
	local receptacle = self.dropLocs[math.random(#self.dropLocs)]

	return { x = receptacle.x - LevelData.XOFF, y = receptacle.y - LevelData.YOFF, rot = receptacle.rot}
end

function WaveManager:spawnWave()
	self.waveNumber = self.waveNumber + 1

	if self.waveNumber > 1 then
		rand = math.random()
		if rand < .25 then
			print("More damage!")
			Game.players[1].damage  = Game.players[1].damage + 1
		elseif rand < .5 then
			print("More speed!")
			Game.players[1].speed = Game.players[1].speed + 500
		else --if rand < .75  then
			print("More hps!")
			Game.players[1].health  = Game.players[1].health + 2
		end
	end

	--Spawn the rope and get the loc
	local ropeLoc = self:spawnRope()
	--don't repeat locations
	local dropLoc = self:getRandomReceptacle()
	local ballLoc = self:getRandomLoc()
	while ballLoc == dropLoc or ballLoc == dropLoc do
		ballLoc = self:getRandomLoc()
	end

    local dropLocation = DropLocation:new():init(TextureAsset.get("receptacle.png"))
    dropLocation:setColor({r = 191, g = 17, b = 8})
    dropLocation:setPos(dropLoc.x, dropLoc.y)
    dropLocation.handle:setAngle(math.rad(dropLoc.rot))
    print("Spawned drop at " .. dropLoc.x .. ", " .. dropLoc.y)
    
    local ball = BallObject:new():init(TextureAsset.get("whitebloodcell.png"))
    ball:setPos(ballLoc[1], ballLoc[2])
    print("Spawned ball at " .. ballLoc[1] .. ", " .. ballLoc[2])
end

function WaveManager:spawnRope()
	local ropeLoc = self:getRandomLoc()
	local numRopesegments = math.floor(self.waveNumber/2)+1
	print(numRopesegments)
	local rope = Rope:new():init(ropeLoc[1], ropeLoc[2], numRopesegments)
	print("Spawned rope at " .. ropeLoc[1] .. ", " .. ropeLoc[2])
	return ropeLoc
end