require "Utility"
require "LevelData"

WaveManager = Class:new()
WaveManager.type = "WaveManager"

function WaveManager:init()
	self.spawnLocs = {}
	table.insert(self.spawnLocs, {5065 + LevelData.XOFF, 5701 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5018 + LevelData.XOFF, 6274 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5983 + LevelData.XOFF, 6076 + LevelData.YOFF})
	table.insert(self.spawnLocs, {6370 + LevelData.XOFF, 5956 + LevelData.YOFF})
	table.insert(self.spawnLocs, {6079 + LevelData.XOFF, 5281 + LevelData.YOFF})
	table.insert(self.spawnLocs, {6547 + LevelData.XOFF, 5434 + LevelData.YOFF})
	table.insert(self.spawnLocs, {6208 + LevelData.XOFF, 4832 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5809 + LevelData.XOFF, 4790 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5101 + LevelData.XOFF, 4946 + LevelData.YOFF})
	table.insert(self.spawnLocs, {4703 + LevelData.XOFF, 5140 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5029 + LevelData.XOFF, 4844 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5554 + LevelData.XOFF, 4817 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5863 + LevelData.XOFF, 4787 + LevelData.YOFF})
	table.insert(self.spawnLocs, {6259 + LevelData.XOFF, 4910 + LevelData.YOFF})
	table.insert(self.spawnLocs, {6478 + LevelData.XOFF, 5269 + LevelData.YOFF})
	table.insert(self.spawnLocs, {5443 + LevelData.XOFF, 5863 + LevelData.YOFF})
	table.insert(self.spawnLocs, {4562 + LevelData.XOFF, 5422 + LevelData.YOFF})
	table.insert(self.spawnLocs, {4922 + LevelData.XOFF, 4814 + LevelData.YOFF})

    return self;
end


function WaveManager:spawnWave()
	local rope = Rope:new():init(-200, 200, 3);

    local dropLocation = DropLocation:new():init(TextureAsset.get("whitesquare.png"))
    dropLocation:setPos(-200, 500)
    
    local ball = BallObject:new():init(TextureAsset.get("whitesquare.png"))
    ball:setPos(-400, -200)
end