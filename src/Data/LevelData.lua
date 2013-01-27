LevelData = {}
LevelData.XOFF = 5545
LevelData.YOFF = 5383

local function addBlob(obj)
	local blob = PhysicsGameObject:new():init(BlobAsset.get(obj.blob, {color=obj.color}), {layer=obj.layer, static = true})
	blob.handle:setPos(obj.posX - LevelData.XOFF,obj.posY - LevelData.YOFF)
	blob.handle:setAngle(math.rad(obj.rotation))
    return blob;
end

function LevelData.Load(file)
    local data = dofile(file)
    local result = {}
    for k,v in pairs(data) do 
    	table.insert(result, addBlob(v))
    end
	return result
end
