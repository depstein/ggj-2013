GameObject = {}
GameObject.type = "GameObject"

function GameObject:new(o)
	o = o or {}
	setmetatable(o, {__index = self})
	return o
end

function GameObject:init(asset, options)
	options = options or {}

	self.prop = asset:make()
	self.handle = self.prop
	self.asset = asset

	if (not options.noadd and not options.layer) then
		SceneManager.i:getDefaultLayer():insertProp(self.prop)
	end

	if (options.layer and not options.noadd) then
		options.layer:insertProp(self.prop)
	end

	if (not GameObject.vsh or not GameObject.fsh) then
		file = assert ( io.open ( 'src/Shaders/shader.vsh', mode ))
		GameObject.vsh = file:read ( '*all' )
		file:close ()

		file = assert ( io.open ( 'src/Shaders/shader.fsh', mode ))
		GameObject.fsh = file:read ( '*all' )
		file:close ()
	end

	--self.prop:setBlendMode(MOAIProp.BLEND_MULTIPLY)

	return self
end

function GameObject:destroy()

end

function GameObject:createPhysicsObject(options)
	options = options or {}

	if (not options.sprite) then
		options.sprite = self.asset.filename
	end	

	self.body, self.shapes = PhysicsData.fromSprite(options)

	SceneManager.i:getCpSpace():insertPrim(self.body)

	for i = 1,#self.shapes do
		if (not options.group) then
			self.shapes[i]:setGroup(tableaddr(self))
		end
		SceneManager.i:getCpSpace():insertPrim(self.shapes[i])
	end

	if self.prop then
		self.prop:setParent(self.body)
	end

	self.handle = self.body
	self.physics = true
end

function GameObject:setColor(color)
	shader = MOAIShader.new ()
	shader:reserveUniforms ( 1 )
	shader:declareUniform ( 1, 'maskColor', MOAIShader.UNIFORM_COLOR )

	moaiColor = MOAIColor.new()
	moaiColor:setColor(color["r"]/255.0, color["g"]/255.0, color["b"]/255.0, 0)
	shader:setAttrLink ( 1, moaiColor, MOAIColor.COLOR_TRAIT )

	shader:setVertexAttribute ( 1, 'position' )
	shader:setVertexAttribute ( 2, 'uv' )
	shader:setVertexAttribute ( 3, 'color' )
	shader:load ( GameObject.vsh, GameObject.fsh )

	self.prop:setShader(shader)
end