require "Utility"

ParticleManager = Class:new()
ParticleManager.type = "ParticleManager"

function ParticleManager:init()
	self.plugins = {}
	self.timeLeft = {}

	timedCorout(function(time)
		while true do
			for k,v in pairs(self.timeLeft) do
				self.timeLeft[k] = v - time
				if (self.timeLeft[k] < 0) then
					Game.sceneManager:getLayer("particles"):removeProp(k)
					self.timeLeft[k] = nil
				end
			end
			coroutine.yield()
		end
	end)

    return self;
end

function ParticleManager:addParticle(particleName, x, y, particleDuration)

	local plugin = self.plugins[particleName]


	local maxParticles = plugin:getMaxParticles ()
	local blendsrc, blenddst = plugin:getBlendMode ()
	local minLifespan, maxLifespan = plugin:getLifespan ()
	local duration = plugin:getDuration ()
	local xMin, yMin, xMax, yMax = plugin:getRect ()

	system = MOAIParticleSystem.new ()
	system._duration = duration
	system._lifespan = maxLifespan
	system:reserveParticles ( maxParticles , plugin:getSize() )
	system:reserveSprites ( maxParticles )
	system:reserveStates ( 1 )
	system:setBlendMode ( blendsrc, blenddst )


	local state = MOAIParticleState.new ()
	state:setTerm ( minLifespan, maxLifespan )
	state:setPlugin(  plugin  )
	system:setState ( 1, state )

	emitter = MOAIParticleTimedEmitter.new()
	emitter:setSystem ( system )
	emitter:setEmission ( plugin:getEmission () )
	emitter:setFrequency ( plugin:getFrequency () )
	emitter:setLoc(x, y)
	emitter:setRect ( xMin, yMin, xMax, yMax )

	local deck = MOAIGfxQuad2D.new()
	deck:setTexture( plugin:getTextureName() )
	deck:setRect( -0.5, -0.5, 0.5, 0.5 ) -- HACK: Currently for scaling we need to set the deck's rect to 1x1
	system:setDeck( deck )

	system:start ()
	emitter:start ()

	self.timeLeft[system] = particleDuration
	
	Game.sceneManager:getLayer("particles"):insertProp ( system)
end