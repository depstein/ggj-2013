PhysicsData = {}

local data = dofile("assets/physics/PhysicsDefinitions.lua")
PhysicsData.BodyData = data.bodies

PhysicsData.StaticGroup = 1

PhysicsData.fromSprite = function(options)
	options = options or {}

	local sprite = options.sprite

	local spriteStripped = string.sub(sprite, 0, sprite:len() - 4)

	assert(PhysicsData.BodyData[spriteStripped], "Physics Body Not Found!")

	local fixtures = PhysicsData.BodyData[spriteStripped].fixtures
	local data = fixtures[1]
	local polygons = {}

	local mass = data.mass
	local moment = 0

	for m = 1,#fixtures do 
		for i = 1,#fixtures[m].polygons do
			local poly = fixtures[m].polygons[i]

			table.insert(polygons, poly)
			moment = moment + MOAICpShape.momentForPolygon(data.mass, poly)
		end
	end

	if (options.static) then
		mass = MOAICp.INFINITY
		moment = MOAICp.INFINITY
	end

	local body = MOAICpBody.new(mass, moment)

	local shapes = {}

	for i = 1,#polygons do
		local shape = body:addPolygon(polygons[i])
		shape:setElasticity(data.elasticity)
		shape:setFriction(data.friction)
		shape:setType(1)
		shape.name = sprite .. i
		if (options.group) then shape:setGroup(options.group) end
		if (options.isSensor) then
			shape:setIsSensor(true)
		end

		table.insert(shapes, shape)
	end

	return body, shapes
end

PhysicsData.blobPolygon = function(file, options)
	assert(PhysicsData.BodyData[file], "Physics Body Not Found!")

	local fixtures = PhysicsData.BodyData[file].fixtures
	local hull = fixtures[1].hull

	local polygonData = {}

	for j = 1,#hull,2 do
		table.insert(polygonData, { x = hull[j], y = hull[j + 1]})
	end

	return polygonData
end