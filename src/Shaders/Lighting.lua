Shaders.Lighting = function() 
	local shader = MOAIShader.new()

	local file = assert(io.open('src/Shaders/lighting.vsh', mode))
	local vsh = file:read('*all')
	file:close()

	file = assert(io.open ('src/Shaders/lighting.fsh', mode))
	local fsh = file:read('*all')
	file:close()

	shader:reserveUniforms ( 3 )
	shader:declareUniform(1, 'transform', MOAIShader.UNIFORM_WORLD_VIEW_PROJ)
	shader:declareUniform(2, 'lightr', MOAIShader.UNIFORM_FLOAT)
	shader:declareUniform(3, 'color', MOAIShader.UNIFORM_COLOR)

	shader:setVertexAttribute(1, 'position')

	shader:load(vsh, fsh)
	shader:setAttr(2, 0)

	shader.setRadius = function(self, radius)
		self:setAttr(2, radius)
	end
	shader.setColorLink = function(self, color)
		self:setAttrLink(3, color, MOAIColor.COLOR_TRAIT)
	end

	return shader
end
