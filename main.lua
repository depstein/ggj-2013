particle = MOAIParticlePexPlugin.load( 'Assets/particles/deathBlossomCharge.pex' )

require "GameManager"
require "Shaders"
require "Light"
Meshes2D = require "Meshes2D"

Game = GameManager:new()

Game:init():start()

Game.particleManager.plugins['deathBlossomCharge.pex'] = particle
