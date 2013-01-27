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
require "Communication"
require "BlobAsset"
require "EnemyManager"

io.write("Do you wish to host the game?");
local input = "";
while (input ~= "y" and input ~= "n") do
	io.write("[y/n]: ");
	input = io.read()
end

local outgoing, incoming, sockinfo

if (input == "y") then
    isServer = true
    outgoing, incoming, sockinfo = Communication.createServer()
else
    isServer = false
    outgoing, incoming, sockinfo = Communication.createClient()
end

camera = MOAICamera2D.new ()

SceneManager:new():init(1024, 768, camera)

SceneManager.i:addLayer("parallax1")
SceneManager.i:getLayer("parallax1"):setParallax(0.5, 0.5)

SceneManager.i:addLayer("main", {default = true})

local p1 = Player:new():init(TextureAsset.get("playerthingy.png"));
p1:setColor(Colors.cornflower_blue)

local p2 = Player:new():init(TextureAsset.get("playerthingy.png"), { disableControls = true });
p2:setColor(Colors.international_orange_golden_gate_bridge)

local MSG_PLAYER_LOCATION = 1
local MSG_ENEMY_LOCATIONS = 2

local messageHandlers = {}

messageHandlers[MSG_PLAYER_LOCATION] = function(message)
    p2.handle:setPos(message.x, message.y)
    p2.handle:setVel(message.vx, message.vy)
end

messageHandlers[MSG_ENEMY_LOCATIONS] = function(message)
    for k, v in pairs(message.enemies) do
        local enemy = Enemies[v.k]
        if(not enemy) then
            enemy = Enemy:new():init(TextureAsset.get("enemy.png"), {color=Colors.papaya_whip, ignoreGravity=true})
            --print("Creating Enemy " .. v.k);
            Enemies[v.k] = enemy
        end
        --print("Setting Enemy to {" .. v.x .. ", " .. v.y .. "} going {" .. v.vx .. ", " .. v.vy .. "}");
        enemy.handle:setPos(v.x, v.y)
        enemy.handle:setVel(v.vx, v.vy)
    end
end

function messageHandler(p1, p2, outgoing, incoming) 
    local updateEnemies = 5;
    while (true) do
        local x, y = p1.handle:getPos()
        local vx, vy = p1.handle:getVel()
        table.insert(outgoing, msgpack.pack({type=MSG_PLAYER_LOCATION, x=x, y=y, vx=vx, vy=vy}))

        updateEnemies = updateEnemies - 1
        if(isServer and updateEnemies == 0) then
            updateEnemies = 5
            local e = {type=MSG_ENEMY_LOCATIONS, enemies={}};
            for k, v in pairs(Enemies) do
                local x, y = v.handle:getPos()
                local vx, vy = v.handle:getVel()
                table.insert(e.enemies, {k=k, x=x, y=y, vx=vx, vy=vy})
            end
            table.insert(outgoing, msgpack.pack(e))
        end

        while(table.getn(incoming) > 0) do
            local message = msgpack.unpack(table.remove(incoming))
            local handler = messageHandlers[message.type]
            if(handler) then
                handler(message)
            else
                print("Unknown Message Received: " .. message.type)
            end
        end
        coroutine.yield()
    end
end

corout(messageHandler, p1, p2, outgoing, incoming)

camera:setAttrLink(MOAITransform.INHERIT_LOC, p1.handle, MOAITransform.TRANSFORM_TRAIT)


local testObject2 = PhysicsGameObject:new():init(TextureAsset.get("moai2.png"));
testObject2:setPos(200, 200)

local testObject3 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {static=true});
testObject3:setPos(-200, 0)
testObject3:setColor(Colors.patriarch)

local testObject4 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {static=true,isSensor=true});
testObject4:setPos(-200, -200)
testObject4:setColor(Colors.rhythm)

local rope = Rope:new():init(-200, -200, 5);
rope:setStartBody(testObject4);

local allBlobs = dofile("src/Engine/LevelData.lua")


if(isServer) then
    print("Starting up EnemyManager")
    corout(EnemyManager.Update)
end
-- Create new circle: ( centerX, centerY, radius, colorHex )
--[[local blobagon = GameObject:new():init(BlobAsset.get('blob1', {color=Colors.cornflower_blue}), {layer="parallax1"})
local blobagon = GameObject:new():init(BlobAsset.get('blob1', {color=Colors.cornflower_blue}), {layer="parallax1"})
blobagon:setPos(45)
blobagon:setRot(45)
]]
