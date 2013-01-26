require "Utility"
require "AssetManager"
require "SceneManager"
require "MouseManager"
require "KeyboardManager"
require "PhysicsData"
require "Colors"
require "GameObject"
require "PhysicsGameObject"
require "Character"
require "Player"
require "Rope"
require "BlobAsset"

camera = MOAICamera2D.new ()

SceneManager:new():init(1024, 768, camera)

SceneManager.i:addLayer("parallax1")
SceneManager.i:getLayer("parallax1"):setParallax(0.5, 0.5)

SceneManager.i:addLayer("main", {default = true})

local testObject = Player:new():init(TextureAsset.get("player.png"));
testObject:setColor(Colors.cornflower_blue)

camera:setParent(testObject.prop)

local testObject2 = PhysicsGameObject:new():init(TextureAsset.get("moai2.png"));
testObject2.handle:setPos(200, 200)

local testObject3 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {static=true});
testObject3.handle:setPos(-200, 0)
testObject3:setColor(Colors.patriarch)

local testObject4 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {static=true,isSensor=true});
testObject4.handle:setPos(-200, -200)
testObject4:setColor(Colors.rhythm)

local rope = Rope:new():init(-200, -200, 5);
rope:setStartBody(testObject4);

-- Create new circle: ( centerX, centerY, radius, colorHex )
local blobagon = GameObject:new():init(BlobAsset.get('blob1', {color="#FF00CC"}), {layer="parallax1"})

