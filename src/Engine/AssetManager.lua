require "Utility"

AssetManager = Class:new()
AssetManager.type = "AssetManager"

function AssetManager:init()
    self.loadedAssets = {}

    return self;
end