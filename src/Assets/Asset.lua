require "TextureAsset"

Asset = {}
Asset.type = "Asset"

function Asset:new(o)
	o = o or {}
	setmetatable(o, {__index = self})
	return o
end

function Asset.get(type, file, options)
	local key = type.getKey(file)
	local asset = AssetManager.loadedAssets[key]
	if (asset == nil) then
		asset = type:new():init(file, options)
		AssetManager.loadedAssets[key] = asset
	end
	return asset
end

function Asset:make() 

end

function Asset.getKey(file)
	return file
end