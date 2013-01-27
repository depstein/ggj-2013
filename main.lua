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

io.write("Do you wish to host the game?");
local input = "";
while (input ~= "y" and input ~= "n") do
	io.write("[y/n]: ");
	input = io.read()
end

local outgoing, incoming, sockinfo

if (input == "y") then
    outgoing, incoming, sockinfo = Communication.createServer()
else
    outgoing, incoming, sockinfo = Communication.createClient()
end

SceneManager:new():init(1024, 768)
SceneManager.i:addLayer("main", {default = true})

local p2 = Player:new():init(TextureAsset.get("playerthingy.png"));
p2:setColor(Colors.international_orange_golden_gate_bridge)

local p1 = Player:new():init(TextureAsset.get("playerthingy.png"));
p1:setColor(Colors.cornflower_blue)

local MSG_FIRST = 1
local MSG_LOCATION = 1
local MSG_LAST = 1;

function messageHandler(p1, p2, outgoing, incoming) 
    while (true) do
        local x, y = p1.handle:getPos()
        local vx, vy = p1.handle:getVel()
        table.insert(outgoing, msgpack.pack({type=MSG_LOCATION, x=x, y=y, vx=vx, vy=vy}))
        --print("Message Count: " .. table.getn(incoming))
        while(table.getn(incoming) > 0) do
            local message = msgpack.unpack(table.remove(incoming))
            if(message.type == MSG_LOCATION) then
                p2.handle:setPos(message.x, message.y)
                p2.handle:setVel(message.vx, message.vy)
                --print("Received Location: " .. message.x .. message.y .. "")
            else
                print("Unknown Message Received: " .. message.type)
            end
        end
        coroutine.yield()
    end
end

corout(messageHandler, p1, p2, outgoing, incoming)


--[[
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
]]--