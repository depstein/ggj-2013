require "PhysicsData"
require "Asset"
local Meshes2D = require "Meshes2D"

RectangleAsset = Asset:new()
RectangleAsset.type = "RectangleAsset"

function RectangleAsset:init(width, height)
	self.width = width
	self.height = height
	return self
end

function RectangleAsset:make()
	return Meshes2D.newRect(0, 0, self.width, self.height, "#000000")
end

function RectangleAsset.get(width, height)
	return RectangleAsset:new():init(width, height)
end