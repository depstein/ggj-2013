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
		{ x = 4784, y = 4967, rot = 150},
		{ x = 4784, y = 4967, rot = 150},

		{ x = 5040, y = 4692, rot = 167},
		{ x = 5426, y = 5279, rot = -150},
		{ x = 5814, y = 4862, rot = 0},
		{ x = 6240, y = 4987, rot = 34},
		{ x = 6185, y = 4735, rot = 177},
		{ x = 6591, y = 4934, rot = 149},
		{ x = 6021, y = 5348, rot = 83},
		{ x = 6038, y = 5687, rot = 100},
		{ x = 5903, y = 5995, rot = 161},
		{ x = 5100, y = 6359, rot = 11},
		{ x = 5602, y = 6336, rot = 48},
		{ x = 5886, y = 6190, rot = -32},
		{ x = 6212, y = 6107, rot = 2},
		{ x = 6421, y = 5885, rot = -109},


		{ x = 6324, y = 5629, rot = -93},
		{ x = 6489, y = 5486, rot = 26},
		{ x = 6604, y = 5227, rot = -87},
		{ x = 5303, y = 5804, rot = 101},
		{ x = 4784, y = 4967, rot = 150},
		{ x = 4907, y = 5529, rot = -52},
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
		if rand < .2 then
			print("More damage!")
			Game.players[1].damage  = Game.players[1].damage + 1
		elseif rand < .6 then
			print("More speed!")
			Game.players[1].speed = Game.players[1].speed + 500
		else
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