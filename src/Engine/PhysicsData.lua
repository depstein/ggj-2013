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
			local poly = { }
			local origPoly = fixtures[m].polygons[i]

			for j = 1,#origPoly,2 do
				poly[j] = origPoly[j]
				poly[j + 1] = origPoly[j + 1]
			end

			table.insert(polygons, poly)
			moment = moment + MOAICpShape.momentForPolygon(data.mass, fixtures[m].polygons[i])
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

		table.insert(shapes, shape)
	end

	return body, shapes
end

function tableaddr(table)
    return tonumber('0x' .. tostring(table):sub(8))
end