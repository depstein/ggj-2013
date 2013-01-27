Shaders.Gaussian = {}

GaussianBlur = {}
GaussianBlur.type = "GaussianBlur"
GaussianBlur.DownSample = 1
GaussianBlur.BLURAMOUNT = 5

function GaussianBlur:new(o)
	o = o or {}
	setmetatable(o, {__index = self})
	return o
end

function GaussianBlur:init()
	self:initFrameBuffer1()
	self:initFrameBuffer2()

	return self
end

Shaders.Gaussian.getShader = function(vertical, amount) 
	local shader = MOAIShader.new()

	local file = assert(io.open('src/Shaders/gaussian.vsh', mode))
	local vsh = file:read('*all')
	file:close()

	file = assert(io.open ('src/Shaders/gaussian.fsh', mode))
	local fsh = file:read('*all')
	file:close()

	shader:reserveUniforms ( 3 ) 
	if (vertical) then
		shader:initGaussianBlur(0, 1, amount)
	else
		shader:initGaussianBlur(1, 0, amount)
	end

	shader:setVertexAttribute ( 1, 'position' )
	shader:setVertexAttribute ( 2, 'uv' )
	shader:setVertexAttribute ( 3, 'color' )

	shader:load(vsh, fsh)

	return shader
end

function GaussianBlur:initFrameBuffer1()
	local ds = GaussianBlur.DownSample -- Downsample factor
	local w = 1024
	local h = 768

	local viewport = MOAIViewport.new()
	viewport:setSize(w / ds, h / ds)
	viewport:setScale(w, -h)

	local frameBuffer = MOAIFrameBuffer.new()
	frameBuffer:init(w / ds, h / ds)
	frameBuffer:setClearColor(0, 0, 0, 0)

	local layer = MOAILayer2D.new()
	layer:setViewport(viewport)
	layer:setFrameBuffer(frameBuffer)
	--layer:setCamera(SceneManager.i.camera)
	MOAISim.pushRenderPass(layer)

	local gfxQuad = MOAIGfxQuad2D.new()
	gfxQuad:setTexture(frameBuffer)
	gfxQuad:setRect(-w / (ds * 2), -h / (ds * 2), w / (ds * 2), h / (ds * 2))
	gfxQuad:setUVRect(0, 0, 1, 1)

	local prop = MOAIProp2D.new()
	prop:setDeck(gfxQuad)
	prop:setLoc(0, 0)
	--prop:setShader(Shaders.Gaussian.getShader(false, GaussianBlur.BLURAMOUNT))

	self.viewport = viewport
	self.frameBuffer = frameBuffer
	self.layer = layer
	self.quad = gfxQuad
	self.pass1 = prop
end

function GaussianBlur:initFrameBuffer2()
	local ds = GaussianBlur.DownSample
	local w = 1024
	local h = 768

	local viewport = MOAIViewport.new()
	viewport:setSize(w / ds, h / ds)
	viewport:setScale(w, h)

	local frameBuffer = MOAIFrameBuffer.new()
	frameBuffer:init(w / ds, h / ds)
	frameBuffer:setClearColor(0, 0, 0, 0)

	local layer = MOAILayer2D.new()
	layer:setViewport(viewport)
	--layer:setFrameBuffer(frameBuffer)
	MOAISim.pushRenderPass(layer)

	layer:insertProp(self.pass1)

	local gfxQuad = MOAIGfxQuad2D.new()
	gfxQuad:setTexture(frameBuffer)
	gfxQuad:setRect(-w / 2, -h / 2, w / 2, h / 2)
	gfxQuad:setUVRect(0, 0, 1, 1)

	--local shader = Shaders.Gaussian.getShader(true, GaussianBlur.BLURAMOUNT)

	local prop = MOAIProp2D.new()
	prop:setDeck(gfxQuad)
	prop:setLoc(0, 0)
	--prop:setParent(SceneManager.i.camera)
	--prop:setBlendMode(MOAIProp.BLEND_ADD)
	--prop:setShader(shader)
	prop:setScl(ds, -ds)

	self.viewport2 = viewport
	self.frameBuffer2 = frameBuffer
	self.layer2 = layer
	self.quad2 = gfxQuad
	self.layerprop = prop
end