require "PhysicsData"
require "Asset"
local Meshes2D = require "Meshes2D"

BlobAsset = Asset:new()
BlobAsset.type = "BlobAsset"

function BlobAsset:init(file, options)
	self.polydata = PhysicsData.blobPolygon(file)
	options = options or {color="FFFFFF"}
	self.color = options.color
	return self
end

function BlobAsset.getKey(file)
	return 'BLOB_' .. file
end

function BlobAsset:make()
	print(self.color)
	return Meshes2D.createPolygon( self.polydata, self.color)
end

function BlobAsset.get(file, options)
	return Asset.get(BlobAsset, file, options)
end