SceneManager = {}
SceneManager.type = "SceneManager"
SceneManager.GRAVITY = 100
SceneManager.objectTypes = {bullet=1, box=2, player=3}
SceneManager.removables = {}

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

	self.space:setCollisionHandler(SceneManager.objectTypes.bullet, tableaddr(Enemy),MOAICpSpace.BEGIN, collisionDetect)



--function setCollisionHandler ( MOAICpSpace self, number collisionTypeA, number collisionTypeB, number mask, function handler )
	--number mask, cpshape a, cpshape b, cparbiter 



	self.layers = {}

	MOAISim.openWindow ( "Scene", width, height )

	SceneManager.i = self

	return self
end


function collisionDetect(numType, a, b, cparbiter) 
    -- use this macro to declare two shapes and call cpArbiterGetShapes which uses the cpArbiter
    -- which contains info on the collision such as the shapes involved, contacts, normals, etc.
    -- use the data property of the cpShape to pull out your custom data object
    SceneManager.removables = {a, b}
    corout(removeObjects)
end

function removeObjects()
	for k, v in pairs(SceneManager.removables) do
		body = v:getBody()
		go = body.gameObject
		go:destroy()
		--SceneManager.i:getCpSpace():removePrim(v:getBody())
	end
	SceneManager.removables = {}
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
