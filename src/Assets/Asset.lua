require("Utility")

Asset = Class:new()
Asset.type = "Asset"

function Asset.get(type, file, options)
	local key = type.getKey(file)
	local asset = Game.assetManager.loadedAssets[key]
	if (asset == nil) then
		asset = type:new():init(file, options)
		Game.assetManager.loadedAssets[key] = asset
	end
	return asset
end

function Asset:make() 

end

function Asset.getKey(file)
	return file
end