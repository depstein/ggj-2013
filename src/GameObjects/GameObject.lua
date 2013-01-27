require("Utility")

GameObject = Class:new()
GameObject.type = "GameObject"

function GameObject:init(asset, options)
	options = options or {}

	self.prop = asset:make()
	self.handle = self.prop
	self.asset = asset
	self.health = 5

	if (not options.noadd and not options.layer) then
		Game.sceneManager:getDefaultLayer():insertProp(self.prop)
	end

	if (options.layer and not options.noadd) then
		Game.sceneManager:getLayer(options.layer):insertProp(self.prop)
	end

	if (not GameObject.vsh or not GameObject.fsh) then
		file = assert ( io.open ( 'src/Shaders/shader.vsh', mode ))
		GameObject.vsh = file:read ( '*all' )
		file:close ()

		file = assert ( io.open ( 'src/Shaders/shader.fsh', mode ))
		GameObject.fsh = file:read ( '*all' )
		file:close ()
	end

	return self
end

function GameObject:setPos(x, y)
	self.prop:setLoc(x, y)
end

function GameObject:getPos()
	return self.prop:getLoc()
end

function GameObject:setRot(angle)
	self.prop:setRot(45)
end

function GameObject:getRot(angle)
	return self.prop:getRot()
end

function GameObject:destroy()
	Game.sceneManager:getDefaultLayer():removeProp(self.prop)
	Game.sceneManager:getCpSpace():removePrim(self.body)
	for i = 1,#self.shapes do
		Game.sceneManager:getCpSpace():removePrim(self.shapes[i])
	end
end

function GameObject:createPhysicsObject(options)
	options = options or {}

	if (not options.sprite) then
		options.sprite = self.asset.filename
	end	

	self.body, self.shapes = PhysicsData.fromSprite(options)

	self.body.gameObject = self

	Game.sceneManager:getCpSpace():insertPrim(self.body)

	for i = 1,#self.shapes do
		if (not options.group) then
			self.shapes[i]:setGroup(tableaddr(self))
		end
		Game.sceneManager:getCpSpace():insertPrim(self.shapes[i])
	end

	if self.prop then
		self.prop:setParent(self.body)
	end

	self.handle = self.body
	self.physics = true
end

function GameObject:setGroup(group)
	for i = 1,#self.shapes do
		self.shapes[i]:setGroup(group)
	end
end

function GameObject:setColor(color)
	shader = MOAIShader.new ()
	shader:reserveUniforms ( 1 )
	shader:declareUniform ( 1, 'maskColor', MOAIShader.UNIFORM_COLOR )

	moaiColor = MOAIColor.new()
	moaiColor:setColor(color.r/255.0, color.g/255.0, color.b/255.0, 1)
	shader:setAttrLink ( 1, moaiColor, MOAIColor.COLOR_TRAIT )

	shader:setVertexAttribute ( 1, 'position' )
	shader:setVertexAttribute ( 2, 'uv' )
	shader:setVertexAttribute ( 3, 'color' )
	shader:load ( GameObject.vsh, GameObject.fsh )

	self.prop:setShader(shader)
end