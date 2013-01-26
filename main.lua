require "Utility"
require "AssetManager"
require "SceneManager"
require "KeyboardManager"
require "PhysicsData"
require "GameObject"
require "PhysicsGameObject"
require "Character"
require "Player"

SceneManager:new():init(1024, 768)
SceneManager.i:addLayer("main", {default = true})

local testObject = Player:new():init(TextureAsset.get("moai.png"));