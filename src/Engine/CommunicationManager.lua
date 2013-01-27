require "Utility"
require "Communication"

CommunicationManager = Class:new()
CommunicationManager.type = "CommunicationManager"

CommunicationManager.MSG_PLAYER_LOCATION = 1
CommunicationManager.MSG_ENEMY_LOCATIONS = 2

function CommunicationManager:init(isServer)
    self.isServer = isServer

    if (self.isServer) then
        self.outgoing, self.incoming, self.info = Communication.createServer()
    else
        self.outgoing, self.incoming, self.info = Communication.createClient()
    end

    corout(function() self:messageHandler() end)

    return self;
end

local messageHandlers = {}

messageHandlers[CommunicationManager.MSG_PLAYER_LOCATION] = function(message)
    Game.players[2].handle:setPos(message.x, message.y)
    Game.players[2].handle:setVel(message.vx, message.vy)
end

messageHandlers[CommunicationManager.MSG_ENEMY_LOCATIONS] = function(message)
    for k, v in pairs(message.enemies) do
        local enemy = Game.enemyManager.enemies[v.k]
        if(not enemy) then
            enemy = Enemy:new():init(TextureAsset.get("enemy.png"), {color=Game.colors.papaya_whip, ignoreGravity=true})
            Game.enemyManager.enemies[v.k] = enemy
        end
        enemy.handle:setPos(v.x, v.y)
        enemy.handle:setVel(v.vx, v.vy)
    end
end

function CommunicationManager:messageHandler() 
    local updateEnemies = 5;
    while (true) do
        local x, y = Game.players[1].handle:getPos()
        local vx, vy = Game.players[1].handle:getVel()
        table.insert(self.outgoing, msgpack.pack({type = CommunicationManager.MSG_PLAYER_LOCATION, x = x, y = y, vx = vx, vy = vy}))

        updateEnemies = updateEnemies - 1
        if(self.isServer and updateEnemies == 0) then
            updateEnemies = 5
            local e = {type = CommunicationManager.MSG_ENEMY_LOCATIONS, enemies = {}};
            for k, v in pairs(Game.enemyManager.enemies) do
                local x, y = v.handle:getPos()
                local vx, vy = v.handle:getVel()
                table.insert(e.enemies, {k = k, x = x, y = y, vx = vx, vy = vy})
            end
            table.insert(self.outgoing, msgpack.pack(e))
        end

        while(table.getn(self.incoming) > 0) do
            local message = msgpack.unpack(table.remove(self.incoming))
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