require "Utility"

ParticleManager = Class:new()
ParticleManager.type = "ParticleManager"

function ParticleManager:init()
	self.plugins = {}
	self.textures = {}
	self.activeParticles = {}

	timedCorout(function(time)
		while true do
			local particlesToRemove = {}
			for k,v in pairs(self.activeParticles) do
				v.duration = v.duration - time
				if (v.duration < 0) then
					v.emitter:setEmission(0)
				end
				if (v.duration < -v.origDuration) then
					table.insert(particlesToRemove, { system = v.system, i = k})
				end
			end
			for i, particleInfo in pairs(particlesToRemove) do
				--Game.sceneManager:getLayer("particles"):removeProp(particleInfo.system)
				--self.activeParticles[particleInfo.i] = nil
			end
			coyield()
		end
	end)

    return self;
end

function ParticleManager:addPlugin(particleName, plugin)
	self.plugins[particleName] = plugin
	local deck = MOAIGfxQuad2D.new()
	deck:setTexture( plugin:getTextureName() )
	deck:setRect( -0.5, -0.5, 0.5, 0.5 ) -- HACK: Currently for scaling we need to set the deck's rect to 1x1
	self.textures[particleName] = deck
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

	system:setDeck( self.textures[particleName] )

	system:start ()
	emitter:start ()

	if (particleDuration > 0) then  
		table.insert(self.activeParticles, { duration = particleDuration, system = system, emitter = emitter, origDuration = particleDuration})
	end
	
	Game.sceneManager:getLayer("particles"):insertProp ( system)

	return system, emitter
end