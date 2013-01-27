BlurLayer = Class:new()
BlurLayer.type = "BlurLayer"

function BlurLayer:init()
    local scene = Game.sceneManager
    local parallax1 = self:createFrameBuffer("parallax1")
    local parallax2 = self:createFrameBuffer("parallax2")
    local parallaxblurred1 = self:createFrameBuffer("parallaxblurred-1");
    local parallaxblurred2 = self:createFrameBuffer("parallaxblurred-2");

    parallaxblurred1:setShader(Shaders.Gaussian.getShader(false, 5))
    parallaxblurred2:setShader(Shaders.Gaussian.getShader(true, 5))

    scene:getLayer("parallaxblurred-1"):insertProp(parallax2)
    scene:getLayer("parallaxblurred-1"):insertProp(parallax1)

    scene:getLayer("parallaxblurred-2"):insertProp(parallaxblurred1)

    scene:getLayer("main"):insertProp(parallaxblurred2)
end

function BlurLayer:createFrameBuffer(layerName) 
    local scene = Game.sceneManager
    local w, h = scene.width, scene.height
    local frameBuffer = MOAIFrameBuffer.new()
    frameBuffer:init(scene.width, scene.height)
    frameBuffer:setClearColor(0, 0, 0, 0)

    local layer = scene:getLayer(layerName)
    layer:setFrameBuffer(frameBuffer)

    local gfxQuad = MOAIGfxQuad2D.new()
    gfxQuad:setTexture(frameBuffer)
    gfxQuad:setRect(-w / 2, -h / 2, w / 2, h / 2)
    gfxQuad:setUVRect(0, 0, 1, 1)

    local prop = MOAIProp2D.new()
    prop:setDeck(gfxQuad)
    prop:setLoc(0, 0)
    prop:setScl(1, -1)
    prop:setParent(scene.camera)

    return prop
end