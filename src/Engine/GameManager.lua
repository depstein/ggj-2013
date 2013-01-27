require "Utility"
require "KeyboardManager"
require "CommunicationManager"
require "TextureAsset"
require "LevelData"

GameManager = Class:new()
GameManager.type = "GameManager"


function GameManager:init()

    self.keyboardManager = KeyboardManager:new():init();
    self.mouseManager = MouseManager:new():init();
    self.assetManager = AssetManager:new():init();
    self.communicationManager = nil;
    self.sceneManager = nil
    self.enemyManager = nil

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

    self.communicationManager = CommunicationManager:new():init(input == "y")
    
    self.sceneManager = SceneManager:new():init(1024, 768, MOAICamera2D.new())
    self.sceneManager:addLayer("bg")
    self.sceneManager:getLayer("bg"):setParallax(0, 0)
    self.sceneManager:addLayer("parallax1")
    self.sceneManager:getLayer("parallax1"):setParallax(0.5, 0.5)
    self.sceneManager:addLayer("main", {default = true})

    LevelData.Load("assets/levels/LevelDefinition.lua")
    
    self.bg = GameObject:new():init(TextureAsset.get("bg.png"), { layer = "bg"})

    self.players[1] = Player:new():init(TextureAsset.get("player.png"));
    self.players[1]:setColor(self.colors.cornflower_blue)
    
    self.players[2] = Player:new():init(TextureAsset.get("player.png"), { disableControls = true });
    self.players[2]:setColor(self.colors.international_orange_golden_gate_bridge)
    self.players[2]:setPos(0, -50)
    
    self.sceneManager.camera:setAttrLink(MOAITransform.INHERIT_LOC, Game.players[1].handle, MOAITransform.TRANSFORM_TRAIT)
    
    self.enemyManager = EnemyManager:new():init()
    self.bulletManager = BulletManager:new():init()
    
    local rope = Rope:new():init(-200, 200, 5);
    
    if(self.communicationManager.isServer) then
        corout(
            function() 
                Game.enemyManager:Update()
            end
        )
    end
end