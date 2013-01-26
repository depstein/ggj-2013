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