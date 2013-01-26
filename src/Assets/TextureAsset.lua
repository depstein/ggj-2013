TextureAsset = Asset:new()
TextureAsset.type = "TextureAsset"
TextureAsset.spritePath = "assets/sprites/"
TextureAsset.sheets = {
	"MainSheet.lua",
}
TextureAsset.loadedSheets = {}
TextureAsset.sprites = {}

for k,file in pairs(TextureAsset.sheets) do
	local import = dofile(TextureAsset.spritePath .. file)

	for i, frame in pairs(import.frames) do
		frame.source = import.texture
		TextureAsset.sprites[frame.name] = frame
	end
end

function TextureAsset.get(file, options) 
	return Asset.get(TextureAsset, file, options)
end

function TextureAsset.getKey(file)
	return 'TEXTURE_' .. file
end

function TextureAsset:init(file, options)
	options = options or {}

	local frame = TextureAsset.sprites[file]
	local texture = TextureAsset.loadedSheets[frame.source]
	if (texture == nil) then
		texture = MOAITexture.new()
		texture:load(TextureAsset.spritePath .. frame.source)
		TextureAsset.loadedSheets[frame.source] = texture
	end

	local deck = MOAIGfxQuad2D.new()
	local w, h = frame.spriteColorRect.width, frame.spriteColorRect.height
	deck:setRect(-w / 2, -h / 2, w / 2, h / 2)
	deck:setUVRect(frame.uvRect.u0, frame.uvRect.v0, frame.uvRect.u1, frame.uvRect.v1)
	deck:setTexture(texture)

	self.frame = frame
	self.deck = deck
	self.width = w
	self.height = h
	self.filename = file

	return self
end

function TextureAsset:make() 
	local prop = MOAIProp2D.new()
	prop:setDeck(self.deck)
	return prop
end