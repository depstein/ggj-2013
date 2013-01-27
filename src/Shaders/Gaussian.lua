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

	if (shader.initGaussianBlur) then
		if (vertical) then
			shader:initGaussianBlur(0, 1, amount)
		else
			shader:initGaussianBlur(1, 0, amount)
		end
	else
		return nil
	end

	shader:setVertexAttribute ( 1, 'position' )
	shader:setVertexAttribute ( 2, 'uv' )
	shader:setVertexAttribute ( 3, 'color' )

	shader:load(vsh, fsh)

	return shader
end