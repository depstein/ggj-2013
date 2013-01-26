require "Utility"
require "AssetManager"
require "SceneManager"
require "KeyboardManager"
require "PhysicsData"
require "Utility"
require "Colors"
require "GameObject"
require "PhysicsGameObject"
require "Character"
require "Player"

SceneManager:new():init(1024, 768)
SceneManager.i:addLayer("main", {default = true})

local testObject = Player:new():init(TextureAsset.get("playerthingy.png"));
testObject:setColor(Colors["cornflower_blue"])
local testObject2 = PhysicsGameObject:new():init(TextureAsset.get("moai2.png"));
testObject2.handle:setPos(200, 200)
