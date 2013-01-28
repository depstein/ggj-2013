require "Utility"

SceneManager = Class:new()
SceneManager.type = "SceneManager"
SceneManager.GRAVITY = 0
SceneManager.OBJECT_TYPES = { BULLET = 1, PHYSICS_BLOB = 2, PLAYER = 3, ENEMY = 4, SEE_OVER = 5,  ROPE_SEGMENT = 6, PHYSICS_GAME_OBJECT=7}

local myPrivateField = nil


function SceneManager:init(width, height, camera, options)
	options = options or {}

	self.width = width
	self.height = height

	self.viewport = MOAIViewport.new()
	self.viewport:setSize (width, height)
	self.viewport:setScale (width, -height)

    self.removables = {}

	self.camera = camera

	self.space = MOAICpSpace.new()
	self.space:setGravity(0, 0)
	self.space:setIterations(10)
	--self.space:setDamping(.05)
	self.space:start()

	self.layers = {}

	MOAISim.openWindow ( "Global Game Jam 2013", width, height )

	return self
end


function SceneManager:addLayer(key, options)
	options = options or {}

	local layer = MOAILayer2D.new()
	layer:setViewport(self.viewport)

	if not options.ignoreCamera then
		layer:setCamera(self.camera)
	end
	MOAISim.pushRenderPass(layer)

	self.layers[key] = layer

	if (options.default) then
		self:setDefaultLayer(key)
		--layer:setCpSpace(self.space)
	end
end

function SceneManager:getLayer(key)
	return self.layers[key]
end

function SceneManager:getDefaultLayer()
	return self:getLayer(self.defaultLayer)
end

function SceneManager:setDefaultLayer(key)
	self.defaultLayer = key
end

function SceneManager:getCpSpace()
	return self.space
end
