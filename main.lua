require "AssetManager"

MOAISim.openWindow ( "test", 1024, 768 )

viewport = MOAIViewport.new ()
viewport:setSize ( 1024, 768 )
viewport:setScale ( 1024, -768 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

local textureAsset = TextureAsset.get('moai2.png')
local prop = textureAsset:make()

layer:insertProp ( prop )

prop:moveRot ( 360, 1.5 )