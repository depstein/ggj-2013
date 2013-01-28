require "Utility"
require "KeyboardManager"
require "MouseManager"
require "CommunicationManager"
require "AssetManager"
require "TextureAsset"
require "LevelData"
require "SceneManager"
require "Player"
require "EnemyManager"
require "Rope"
require "DropLocation"
require "ParticleManager"
require "LightLayer"
require "BlurLayer"
require "BallObject"
require "WaveManager"

GameManager = Class:new()
GameManager.type = "GameManager"


function GameManager:init()
    math.randomseed( os.time() )
    math.random()
    math.random()
    math.random()

    self.keyboardManager = KeyboardManager:new():init();
    self.mouseManager = MouseManager:new():init();
    self.assetManager = AssetManager:new():init();
    self.particleManager = ParticleManager:new():init();
    self.waveManager = WaveManager:new():init();
    self.communicationManager = nil;
    self.sceneManager = nil
    self.enemyManager = nil
    self.lightLayer = nil

    self.colors = dofile("assets/Colors.lua")

    self.communication = {
        outgoing = {},
        incoming = {},
        info = {},
    }

    self.players = {}

    return self;
end

function GameManager:start()

    io.write("Do you wish to host the game?");
    local input = "";
    while (input ~= "y" and input ~= "n") do
    	io.write("[y/n]: ");
    	input = io.read()
    end

    local isServer = input == "y"
    local ip = ""

    if(not isServer) then
        io.write("IP Address to Connect To:");
        ip = io.read()
    end
    
    self.sceneManager = SceneManager:new():init(1024, 768, MOAICamera2D.new())
    self.sceneManager:addLayer("lighting")
    self.sceneManager:addLayer("bg")
    self.sceneManager:getLayer("bg"):setParallax(0, 0)
    self.sceneManager:addLayer("parallax2")
    self.sceneManager:getLayer("parallax2"):setParallax(0.25, 0.25)
    self.sceneManager:addLayer("parallax1")
    self.sceneManager:getLayer("parallax1"):setParallax(0.5, 0.5)
    self.sceneManager:addLayer("parallaxblurred-1")
    self.sceneManager:addLayer("parallaxblurred-2")
    self.sceneManager:addLayer("main", {default = true})
    self.sceneManager:addLayer("particles")

    self.blurLayer = BlurLayer:new():init();

    self.enemyManager = EnemyManager:new():init()
    LevelData.Load("assets/levels/LevelDefinition.lua")
    
    self.bg = GameObject:new():init(TextureAsset.get("bg.png"), { layer = "bg"})

    self.players[1] = Player:new():init(TextureAsset.get("player.png"));
    self.players[1]:setColor(self.colors.cornflower_blue)
    
    self.players[2] = Player:new():init(TextureAsset.get("player.png"), { disableControls = true });
    self.players[2]:setColor(self.colors.international_orange_golden_gate_bridge)
    self.players[2]:setPos(0, -50)
    
    self.sceneManager.camera:setAttrLink(MOAITransform.INHERIT_LOC, Game.players[1].handle, MOAITransform.TRANSFORM_TRAIT)
    
    self.bulletManager = BulletManager:new():init()

    self.communicationManager = CommunicationManager:new():init(isServer, ip)
    
    self.waveManager:spawnWave();

    self.envLightLayer = LightLayer:new():init({layers = {"main"}, includeEnvLights = true, includePlayers = true});


    if(self.communicationManager.isServer) then
        self.sceneManager.space:setCollisionHandler(
            SceneManager.OBJECT_TYPES.BULLET, 
            SceneManager.OBJECT_TYPES.PHYSICS_BLOB, 
            MOAICpSpace.BEGIN, 
            function(numType, bulletBody, physicsBlob, cparbiter)
                corout(function() 
                    Game.bulletManager:hitWall(bulletBody:getBody().gameObject:getPos())--cparbiter:getContactPoint(1))
                    Game.bulletManager:Destroy(bulletBody:getBody().gameObject.id)
                end)
            end
        )

    	self.sceneManager.space:setCollisionHandler(
            SceneManager.OBJECT_TYPES.BULLET, 
            SceneManager.OBJECT_TYPES.ENEMY, 
            MOAICpSpace.BEGIN, 
            function(numType, bulletBody, enemyBody, cparbiter)
                corout(function() 
                    Game.bulletManager:markImpact(bulletBody:getBody().gameObject:getPos())--cparbiter:getContactPoint(1))
                    Game.enemyManager:DamageEnemy(enemyBody:getBody().gameObject.id, bulletBody:getBody().gameObject.damage)
                    Game.bulletManager:Destroy(bulletBody:getBody().gameObject.id)
                end)
            end
        )

        self.sceneManager.space:setCollisionHandler(
            SceneManager.OBJECT_TYPES.PLAYER, 
            SceneManager.OBJECT_TYPES.ENEMY, 
            MOAICpSpace.BEGIN, 
            function(numType, playerBody, enemyBody, cparbiter)
                corout(function() 
                    Game.bulletManager:markImpact(enemyBody:getBody().gameObject:getPos())--cparbiter:getContactPoint(1))
                    playerBody:getBody().gameObject.health = playerBody:getBody().gameObject.health - 1
                    Game.enemyManager:Destroy(enemyBody:getBody().gameObject.id)
                end)
            end
        )

        corout(
            function() 
                Game.enemyManager:Update()
            end
        )
    end
end