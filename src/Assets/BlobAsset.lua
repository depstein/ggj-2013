require "PhysicsData"
require "Asset"

BlobAsset = Asset:new()
BlobAsset.type = "BlobAsset"

function BlobAsset:init(file, options)
	self.polydata = PhysicsData.blobPolygon(file)
	options = options or {color="FFFFFF"}
	self.color = '#' .. options.color
	self.filename = file .. '.png'

	return self
end

function BlobAsset.getKey(file)
	return 'BLOB_' .. file
end

function BlobAsset:make()
	return Meshes2D.createPolygon( self.polydata, self.color)
end

function BlobAsset.get(...)
	return BlobAsset:init(...)
end