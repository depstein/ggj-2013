local deathBlossom = MOAIParticlePexPlugin.load( 'Assets/particles/deathBlossomCharge.pex' )
local engine = MOAIParticlePexPlugin.load( 'Assets/particles/engine.pex' )

require "GameManager"
require "Shaders"
require "Light"
Meshes2D = require "Meshes2D"

Game = GameManager:new()

Game:init():start()

Game.particleManager:addPlugin('deathBlossomCharge.pex', deathBlossom)
Game.particleManager:addPlugin('engine.pex', engine)