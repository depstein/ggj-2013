local deathBlossom = MOAIParticlePexPlugin.load( 'Assets/particles/deathBlossomCharge.pex' )
local engine = MOAIParticlePexPlugin.load( 'Assets/particles/engine.pex' )
local hit = MOAIParticlePexPlugin.load( 'Assets/particles/hit.pex' )
local hitWall = MOAIParticlePexPlugin.load( 'Assets/particles/hitWall.pex' )
local enemyDeath = MOAIParticlePexPlugin.load( 'Assets/particles/enemyDeath.pex' )

require "GameManager"
require "Shaders"
require "Light"
Meshes2D = require "Meshes2D"

Game = GameManager:new()

Game:init():start()

Game.particleManager:addPlugin('deathBlossomCharge.pex', deathBlossom)
Game.particleManager:addPlugin('engine.pex', engine)
Game.particleManager:addPlugin('hit.pex', hit)
Game.particleManager:addPlugin('hitWall.pex', hitWall)
Game.particleManager:addPlugin('enemyDeath.pex', enemyDeath)