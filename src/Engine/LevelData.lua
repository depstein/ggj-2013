levelData = {}
levelData.XOFF, levelData.YOFF = 5545, 5383
local data = dofile("assets/levels/LevelDefinition.lua")


addBlob = function(obj)
	--print(obj .. "")
	blob = PhysicsGameObject:new():init(BlobAsset.get(obj.blob, {color=obj.color}), {layer=obj.layer, static = true })
	--blob.handle:setScl(obj.scale,obj.scale)
	blob.handle:setPos(obj.posX - levelData.XOFF, obj.posY - levelData.YOFF)
	print(blob.handle:getPos())
	blob.handle:setAngle(math.rad(obj.rotation))
	table.insert(levelData,blob)
end

for k,v in pairs(data) do 
	--print(k .. " " .. v)
	addBlob(v) 
end



return levelData