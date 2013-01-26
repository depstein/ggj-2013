require "AssetManager"
require "SceneManager"

SceneManager:new():init(1024, 768)
SceneManager.i:addLayer("main", {default = true})

local textureAsset = TextureAsset.get('moai2.png')
local prop = textureAsset:make()

SceneManager.i:getLayer("main"):insertProp ( prop )

prop:moveRot ( 360, 1.5 )