require "AssetManager"
require "SceneManager"
require "GameObject"
require "PhysicsData"

SceneManager:new():init(1024, 768)
SceneManager.i:addLayer("main", {default = true})

local testObject = GameObject:new():init(TextureAsset.get("moai.png"));
testObject:createPhysicsObject()
