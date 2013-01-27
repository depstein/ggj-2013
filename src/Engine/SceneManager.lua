require "Utility"

SceneManager = Class:new()
SceneManager.type = "SceneManager"
SceneManager.GRAVITY = 100
SceneManager.objectTypes = {bullet=1, box=2, player=3}
SceneManager.removables = {}

SceneManager.GRAVITY = 100
SceneManager.OBJECT_TYPES = { BULLET = 1, BOX = 2, PLAYER = 3 }

local myPrivateField = nil


function SceneManager:removeObjects()
	for k, v in pairs(self.removables) do
		body = v:getBody()
		go = body.gameObject
		go:destroy()
		--SceneManager.i:getCpSpace():removePrim(v:getBody())
	end
	self.removables = {}
end

function SceneManager:collisionDetect(numType, a, b, cparbiter) 
    -- use this macro to declare two shapes and call cpArbiterGetShapes which uses the cpArbiter
    -- which contains info on the collision such as the shapes involved, contacts, normals, etc.
    -- use the data property of the cpShape to pull out your custom data object
    self.removables = {a, b}
    corout(function() self:removeObjects() end)
end

function SceneManager:init(width, height, camera, options)
	options = options or {}

	self.viewport = MOAIViewport.new()
	self.viewport:setSize (width, height)
	self.viewport:setScale (width, -height)

    self.removables = {}

	self.camera = camera

	self.space = MOAICpSpace.new()
	self.space:setGravity(0, 0)
	self.space:setIterations(5)
	self.space:setDamping(.02)
	self.space:start()

--function setCollisionHandler ( MOAICpSpace self, number collisionTypeA, number collisionTypeB, number mask, function handler )
	--number mask, cpshape a, cpshape b, cparbiter 
	self.space:setCollisionHandler(SceneManager.OBJECT_TYPES.BULLET, tableaddr(Enemy), MOAICpSpace.BEGIN, 
        function(numType, a, b, cparbiter) 
            self:collisionDetect(numType, a, b, cparbiter) 
        end
    )

	self.layers = {}

	MOAISim.openWindow ( "Scene", width, height )

	return self
end


function SceneManager:addLayer(key, options)
	options = options or {}

	local layer = MOAILayer2D.new()
	layer:setViewport(self.viewport)

	layer:setCamera(self.camera)
	MOAISim.pushRenderPass(layer)

	self.layers[key] = layer

	if (options.default) then
		self:setDefaultLayer(key)
		layer:setCpSpace(self.space)
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
