require "PhysicsGameObject"
require "BlobAsset"

LevelData = {}
LevelData.XOFF = 5545
LevelData.YOFF = 5383

LevelData.BORDER_COLORS = {}
LevelData.BORDER_COLORS['bf1108'] = '941009'
LevelData.BORDER_COLORS['4e1d0a'] = '2e1207'
LevelData.BORDER_COLORS['730606'] = '3d0505'

local function addBlob(obj)
    local blob
    if (obj.layer == "main") then
        blob = PhysicsGameObject:new():init(BlobAsset.get(obj.blob, {color=obj.color}), {layer=obj.layer, static = true })
        blob.handle:setPos(obj.posX - LevelData.XOFF, obj.posY - LevelData.YOFF)
        blob.handle:setAngle(math.rad(obj.rotation))
        blob.handle.gameObject = blob
        blob:setType(SceneManager.OBJECT_TYPES.PHYSICS_BLOB)
    else 
        blob = GameObject:new():init(BlobAsset.get(obj.blob, {color=obj.color}), {layer=obj.layer, })
        blob.handle:setLoc(obj.posX - LevelData.XOFF, obj.posY - LevelData.YOFF)
        blob.handle:setRot(obj.rotation)
    end
    return blob;
end

function LevelData.addDoodad(obj)
    local doodad = GameObject:new():init(TextureAsset.get(obj.img .. ".png"))
    doodad.handle:setLoc(obj.x - LevelData.XOFF, obj.y - LevelData.YOFF)
    doodad.handle:setRot(obj.rot)
    doodad:setColor({r = 191, g = 17, b = 8})
end

function LevelData.Load(file)
    local data = dofile(file)
    local result = {}
    for k,v in pairs(data.blobs) do 
    	table.insert(result, addBlob(v))
    end

    for k, v in pairs(data.doodads) do
        LevelData.addDoodad(v)
    end

    Game.enemyManager:SetSpawnPoints(data.spawnPoints)
	return result
end
