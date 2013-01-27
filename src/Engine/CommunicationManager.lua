require "Utility"
require "Communication"

CommunicationManager = Class:new()
CommunicationManager.type = "CommunicationManager"

CommunicationManager.MSG_PLAYER_LOCATION = 1
CommunicationManager.MSG_PLAYER_FIRE = 2
CommunicationManager.MSG_GAME_STATE = 3

function CommunicationManager:init(isServer, ip)
    self.isServer = isServer

    if (self.isServer) then
        self.renemies = {}
        self.rbullet = {}

        self.outgoing, self.incoming, self.info = Communication.createServer()
        Game.enemyManager.onEnemyDie = function(id, enemy)
            table.insert(self.renemies, id)
        end
    
        Game.bulletManager.onBulletDie = function(id, bullet)
            table.insert(self.rbullet, id)
        end
    else
        self.cbullet = {}

        self.outgoing, self.incoming, self.info = Communication.createClient(ip)
    end

    corout(function() self:messageHandler() end)

    return self;
end

function CommunicationManager:Fired(bullet)
    if(self.isServer) then return end
    table.insert(self.cbullet, bullet)
end

local messageHandlers = {}

messageHandlers[CommunicationManager.MSG_PLAYER_LOCATION] = function(self, message)
    Game.players[2].handle:setPos(message.x, message.y)
    Game.players[2].handle:setVel(message.vx, message.vy)
end

messageHandlers[CommunicationManager.MSG_PLAYER_FIRE] = function(self, message)
    for k, v in pairs(message.bullets) do
        bullet = Game.bulletManager:Create()
        bullet.handle:setPos(v.x, v.y)
        bullet.handle:setVel(v.vx, v.vy)
    end
end

messageHandlers[CommunicationManager.MSG_GAME_STATE] = function(self, message)
    for k, v in pairs(message.enemies) do
        local enemy = Game.enemyManager.enemies[v.k]
        if(not enemy) then
            enemy = Game.enemyManager:Create()
            Game.enemyManager.enemies[v.k] = enemy
        end
        enemy.handle:setPos(v.x, v.y)
        enemy.handle:setVel(v.vx, v.vy)
    end
    for k, v in pairs(message.bullets) do
        local bullet = Game.bulletManager.bullets[v.k]
        if(not bullet) then
            bullet = Game.bulletManager:Create()
            Game.bulletManager.bullets[v.k] = bullet
        end
        bullet.handle:setPos(v.x, v.y)
        bullet.handle:setVel(v.vx, v.vy)
    end
    
    for k, v in pairs(message.renemies) do
        if(Game.enemyManager.enemies[v]) then 
            Game.enemyManager:Destroy(v)
        end
    end
    
    for k, v in pairs(message.rbullets) do
        if(Game.bulletManager.bullets[v]) then 
            Game.bulletManager:Destroy(v)
        end
    end
    
end

function CommunicationManager:messageHandler() 
    local updateEnemies = 5;
    while (true) do
        local x, y = Game.players[1].handle:getPos()
        local vx, vy = Game.players[1].handle:getVel()
        table.insert(self.outgoing, msgpack.pack({type = CommunicationManager.MSG_PLAYER_LOCATION, x = x, y = y, vx = vx, vy = vy}))

        if(self.isServer) then
            updateEnemies = updateEnemies - 1
            if(updateEnemies == 0) then
                updateEnemies = 5
                local e = {type = CommunicationManager.MSG_GAME_STATE, enemies = {}, renemies = self.renemies, bullets = {}, rbullets = self.rbullet};
                for k, v in pairs(Game.enemyManager.enemies) do
                    local x, y = v.handle:getPos()
                    local vx, vy = v.handle:getVel()
                    table.insert(e.enemies, {k = k, x = x, y = y, vx = vx, vy = vy})
                end
                for k, v in pairs(Game.bulletManager.bullets) do
                    local x, y = v.handle:getPos()
                    local vx, vy = v.handle:getVel()
                    table.insert(e.bullets, {k = k, x = x, y = y, vx = vx, vy = vy})
                end
                table.insert(self.outgoing, msgpack.pack(e))
    
                self.renemies = {}
                self.rbullets = {}
            end
        else
            if(#self.cbullet > 0) then
                local e = {type = CommunicationManager.MSG_PLAYER_FIRE, bullets = self.cbullet}
                table.insert(self.outgoing, msgpack.pack(e))

                self.cbullet = {}
            end
        end

        while(table.getn(self.incoming) > 0) do
            local message = msgpack.unpack(table.remove(self.incoming))
            local handler = messageHandlers[message.type]
            if(handler) then
                handler(self, message)
            else
                print("ERROR: Unknown Message Received: " .. message.type)
            end
        end
        coroutine.yield()
    end
end