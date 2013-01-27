levelData = {}

local data = dofile("assets/levels/LevelDefinition.lua")


addBlob = function(obj)
	--print(obj .. "")
	blob = GameObject:new():init(BlobAsset.get(obj.blob, {color=obj.color}), {layer=obj.layer})
	blob.handle:setScl(obj.scale,obj.scale)
	blob.handle:setLoc(obj.posX,obj.posY)
	blob.handle:setRot(obj.rotation)
	table.insert(levelData,blob)
end

for k,v in pairs(data) do 
	--print(k .. " " .. v)
	addBlob(v) 
end



return levelData