require "RectangleAsset"

LightLayer = Class:new()
LightLayer.type = "LightLayer"

function LightLayer:init()
	local scene = Game.sceneManager

    local w, h = scene.width, scene.height
    local frameBuffer = MOAIFrameBuffer.new()
    frameBuffer:init(scene.width, scene.height)
    frameBuffer:setClearColor(0, 0, 0, 0)

    local lighting = scene:getLayer("lighting")
    lighting:setFrameBuffer(frameBuffer)

    local blackCover = GameObject:new():init(RectangleAsset.get(scene.width, scene.height, {color = "#1f1f1f"}), {layer = "lighting"})
    blackCover.prop:setParent(scene.camera)

    local lightData = dofile("src/Data/LightData.lua")
    self.lights = {}

    for i = 1,#lightData do
        local data = lightData[i]
        local light = Light:new():init(data.radius)
        light.handle:setLoc(data.x - LevelData.XOFF, data.y - LevelData.YOFF)
        table.insert(self.lights, light)
    end

    local gfxQuad = MOAIGfxQuad2D.new()
    gfxQuad:setTexture(frameBuffer)
    gfxQuad:setRect(-w / 2, -h / 2, w / 2, h / 2)
    gfxQuad:setUVRect(0, 0, 1, 1)

    local prop = MOAIProp2D.new()
    prop:setDeck(gfxQuad)
    prop:setLoc(0, 0)
    prop:setScl(1, -1)
    prop:setParent(scene.camera)
    prop:setBlendMode(MOAIProp.BLEND_MULTIPLY)

    scene:getLayer("main"):insertProp(prop)
end