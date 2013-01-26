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