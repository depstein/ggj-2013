Light = PhysicsGameObject:new()
Light.type = "Light"

function Light:init(radius, options) 
	options = options or {}
	self.radius = radius

	local prop = Meshes2D.newRect(0, 0, self.radius + 450, self.radius + 450, "#ffffff")
    local shader = Shaders.Lighting()
    shader:setRadius(radius)
    local color = MOAIColor.new()
    color:setColor(1, 1, 1, .25)
    shader:setColorLink(color)
    prop:setShader(shader)
    prop:setBlendMode(MOAIProp.BLEND_ADD)

    Game.sceneManager:getLayer("lighting"):insertProp(prop)

    self.prop = prop
    self.shader = shader
    self.color = color
    self.handle = prop

	return self
end