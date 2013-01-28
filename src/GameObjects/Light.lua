Light = PhysicsGameObject:new()
Light.type = "Light"

function Light:init(radius, options) 
	options = options or {}
    radius = radius *.75
    self.origRadius = radius
    self.radiusDir = 1
    self.pulseSpeed = 20 + math.random() * 5
    self.pulseVariance = 25 + math.random() * 5
    self.radius = radius + (math.random() - .5) * self.pulseVariance * 2

	local prop = Meshes2D.newRect(0, 0, self.radius + 450, self.radius + 450, "#ffffff")
    local shader = Shaders.Lighting()
    shader:setRadius(radius)
    local color = options.color or MOAIColor.new()
    if (not options.color) then
        color:setColor(1, .25, .25, 1)
    end
    shader:setColorLink(color)
    prop:setShader(shader)
    prop:setBlendMode(MOAIProp.BLEND_ADD)

    Game.sceneManager:getLayer("lighting"):insertProp(prop)

    self.prop = prop
    self.shader = shader
    self.color = color
    self.handle = prop

    timedCorout(function(dt)
        while (true) do
            if (math.abs(self.radius - self.origRadius) < self.pulseVariance) then
                self.radius = self.radius + self.radiusDir * dt * self.pulseSpeed
            else
                self.radiusDir = -self.radiusDir
                while ((math.abs(self.radius - self.origRadius) > self.pulseVariance)) do
                    self.radius = self.radius + self.radiusDir * dt * self.pulseSpeed
                end
            end

            self.shader:setRadius(self.radius)
            self.prop:scheduleUpdate()

            coyield()
        end
    end)

	return self
end