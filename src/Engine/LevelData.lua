levelData = {}
levelData.XOFF, levelData.YOFF = 5545, 5383
local data = dofile("assets/levels/LevelDefinition.lua")


addBlob = function(obj)
	--print(obj .. "")
	local blob
	if (obj.layer == "main") then
		blob = PhysicsGameObject:new():init(BlobAsset.get(obj.blob, {color=obj.color}), {layer=obj.layer, static = true })
		blob.handle:setPos(obj.posX - levelData.XOFF, obj.posY - levelData.YOFF)
		blob.handle:setAngle(math.rad(obj.rotation))
		blob.handle:setGroup(SceneManager.OBJECT_TYPES.PHYSICS_BLOB)
		blob.handle.shapes[1]:setGroup(SceneManager.OBJECT_TYPES.PHYSICS_BLOB)
		blob.type = "Physics Blob"
	else 
		blob = GameObject:new():init(BlobAsset.get(obj.blob, {color=obj.color}), {layer=obj.layer })
		blob.handle:setLoc(obj.posX - levelData.XOFF, obj.posY - levelData.YOFF)
		blob.handle:setRot(obj.rotation)
	end

	--blob.handle:setScl(obj.scale,obj.scale)

	table.insert(levelData,blob)
end

for k,v in pairs(data) do 
	--print(k .. " " .. v)
	addBlob(v) 
end



return levelData