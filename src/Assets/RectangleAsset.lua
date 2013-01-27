require "PhysicsData"
require "Asset"
local Meshes2D = require "Meshes2D"

RectangleAsset = Asset:new()
RectangleAsset.type = "RectangleAsset"

function RectangleAsset:init(width, height, options)
	options = options or {}

	self.width = width
	self.height = height
	self.color = options.color or "#000000"
	return self
end

function RectangleAsset:make()
	return Meshes2D.newRect(0, 0, self.width, self.height, self.color)
end

function RectangleAsset.get(...)
	return RectangleAsset:new():init(...)
end