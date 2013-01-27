require "PhysicsGameObject"

DropLocation = PhysicsGameObject:new()
DropLocation.type = "DropLocation"

function DropLocation:init(asset, options)
	options = options or {}
	options.static = true
	options.isSensor = true
	PhysicsGameObject.init(self, asset, options)
	self:createPhysicsObject(options)

	self:setType(tableaddr(DropLocation))

	self:setColor(Game.colors.yellow)

	Game.sceneManager:getCpSpace():setCollisionHandler(tableaddr(DropLocation), tableaddr(BallObject), MOAICpSpace.BEGIN, self.collideWithBall)
	return self
end

function DropLocation:collideWithBall(cpShapeA, cpShapeB, cpArbiter)
	if not cpArbiter:isFirstContact() then
		return
	end
	print("Connecting a ball to a drop location")

	local goA = cpShapeA:getBody().gameObject
	local goB = cpShapeB:getBody().gameObject
	local ball
	if (goA.type == "BallObject") then
		ball = goA
	else
		ball = goB
	end

	local rope = ball.rope.parent
	local player =  rope.player
	for k, v in pairs(player.joints) do
		player:removeJoint(k)
	end
	player.carryingRope = false

	for k, v in pairs(cpShapeA:getBody().gameObject.joints) do
		cpShapeA:getBody().gameObject:removeJoint(k)
	end
	for k, v in pairs(cpShapeB:getBody().gameObject.joints) do 
		cpShapeB:getBody().gameObject:removeJoint(k)
	end

	joint = MOAICpConstraint.newSlideJoint(cpShapeA:getBody(), cpShapeB:getBody(), 0, 0, 0, 0, 0, 50)
	joint:setBiasCoef ( 0.75 )

	Game.sceneManager:getCpSpace():insertPrim ( joint )
	cpShapeA:getBody().gameObject:addJoint(joint, cpShapeB:getBody().gameObject)
	cpShapeB:getBody().gameObject:addJoint(joint, cpShapeA:getBody().gameObject)

	rope:destroy()
	goA:destroy()
	goB:destroy()

	Game.waveManager:spawnWave()
end