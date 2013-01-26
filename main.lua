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
testObject:setColor(Colors.cornflower_blue)
local testObject2 = PhysicsGameObject:new():init(TextureAsset.get("moai2.png"));
testObject2.handle:setPos(200, 200)

local testObject3 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {static=true});
testObject3.handle:setPos(-200, 0)
testObject3:setColor(Colors.patriarch)

local testObject4 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {isSensor=true});
testObject4.handle:setPos(-200, -200)
testObject4:setColor(Colors.rhythm)

local rope1 = PhysicsGameObject:new():init(TextureAsset.get("whiterectangle.png"));
rope1.handle:setPos(-200, -160)
rope1:setColor(Colors.silver)

--[[
local rope2 = PhysicsGameObject:new():init(TextureAsset.get("whiterectangle.png"));
rope2.handle:setPos(-200, -140)
rope2:setColor(Colors.shocking_pink_crayola)

local rope3 = PhysicsGameObject:new():init(TextureAsset.get("whiterectangle.png"));
rope3.handle:setPos(-200, -120)
rope3:setColor(Colors.smokey_topaz)
]]--

mouseJoint = MOAICpConstraint.newPivotJoint (testObject4.body, rope1.body, 0, 0, 0, 0)
mouseJoint:setMaxForce ( 5000 )
mouseJoint:setBiasCoef ( 0.15 )
SceneManager.i:getCpSpace():insertPrim ( mouseJoint )

--[[
mouseJoint2 = MOAICpConstraint.newPivotJoint (rope1.body, rope2.body, 50, 0, -50, 0)
mouseJoint2:setMaxForce ( 5000 )
mouseJoint2:setBiasCoef ( 0.15 )
SceneManager.i:getCpSpace():insertPrim ( mouseJoint2 )

mouseJoint3 = MOAICpConstraint.newPivotJoint (rope2.body, rope3.body, 50, 0, -50, 0)
mouseJoint3:setMaxForce ( 5000 )
mouseJoint3:setBiasCoef ( 0.15 )
SceneManager.i:getCpSpace():insertPrim ( mouseJoint3 )
]]--