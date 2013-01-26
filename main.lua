require "AssetManager"
require "SceneManager"
require "GameObject"
require "PhysicsData"
require "Utility"
require "colors"

SceneManager:new():init(1024, 768)
SceneManager.i:addLayer("main", {default = true})

local testObject = GameObject:new():init(TextureAsset.get("moai.png"), {noadd= false});

testObject:setColor(Colors["cornflower_blue"])