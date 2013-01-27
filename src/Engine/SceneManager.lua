SceneManager = {}
SceneManager.type = "SceneManager"
SceneManager.GRAVITY = 100

function SceneManager:new(o)
	o = o or {}
	setmetatable(o, {__index = self})
	return o
end

function SceneManager:init(width, height, camera, options)
	options = options or {}

	self.viewport = MOAIViewport.new()
	self.viewport:setSize (width, height)
	self.viewport:setScale (width, -height)

	self.camera = camera

	self.space = MOAICpSpace.new()
	self.space:setGravity(0, 0)
	self.space:setIterations(5)
	self.space:setDamping(.02)
	self.space:start()

	self.layers = {}

	MOAISim.openWindow ( "Scene", width, height )

	SceneManager.i = self

	return self
end

function SceneManager:addLayer(key, options)
	options = options or {}

	local layer = MOAILayer2D.new()
	layer:setViewport(self.viewport)

	layer:setCamera(camera)
	--layer:setCpSpace(self.space)
	MOAISim.pushRenderPass(layer)

	self.layers[key] = layer

	if (options.default) then
		self:setDefaultLayer(key)
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
