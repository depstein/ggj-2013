require "Utility"
require "Player"

Rope = Class:new()
Rope.type = "Rope"

function Rope:init(x, y, numRopeSegments) 
	self.ropeSegments = {}
	for i=1, numRopeSegments do
		segment = PhysicsGameObject:new():init(TextureAsset.get("bloodvessel.png"), {group=tableaddr(self), damp = false});
		segment.handle:setPos(x-50*i, y)
		segment:setColor(Game.colors.coral_red)
		segment.body:setMass(1)
		segment:setType(SceneManager.OBJECT_TYPES.ROPE_SEGMENT)
		self.ropeSegments[i] = segment
		if (i>1) then
			joint = MOAICpConstraint.newSlideJoint (self.ropeSegments[i-1].body, self.ropeSegments[i].body, -20, 0, 20, 0, 0, 1)
			--joint:setMaxForce ( 5000 )
			joint:setBiasCoef ( 0.75 )
			Game.sceneManager:getCpSpace():insertPrim ( joint )
		end
	end

	endpoint1 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {isSensor=true, noadd = true});
	endpoint1.handle:setPos(self.ropeSegments[1]:getPos())
	endpoint1:setType(tableaddr(Rope))
	endpoint1:setGroup(tableaddr(Rope))
	endpoint2 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {isSensor=true, noadd = true});
	endpoint2.handle:setPos(self.ropeSegments[numRopeSegments]:getPos())
	endpoint2:setType(tableaddr(Rope))
	endpoint2:setGroup(tableaddr(Rope))
	endpoint1:setColor(Game.colors.rhythm)
	endpoint2:setColor(Game.colors.rhythm)

	joint = MOAICpConstraint.newSlideJoint(self.ropeSegments[1].body, endpoint1.body, 20, 0, 0, 0, 0, 1)
	joint:setBiasCoef ( 0.75 )
	Game.sceneManager:getCpSpace():insertPrim ( joint )

	joint = MOAICpConstraint.newSlideJoint(self.ropeSegments[numRopeSegments].body, endpoint2.body, -20, 0, 0, 0, 0, 1)
	joint:setBiasCoef ( 0.75 )
	Game.sceneManager:getCpSpace():insertPrim ( joint )

	Game.sceneManager:getCpSpace():setCollisionHandler(SceneManager.OBJECT_TYPES.PLAYER, tableaddr(Rope), MOAICpSpace.BEGIN, self.collideWithPlayer)
	Game.sceneManager:getCpSpace():setCollisionHandler(SceneManager.OBJECT_TYPES.PLAYER, SceneManager.OBJECT_TYPES.ROPE_SEGMENT, MOAICpSpace.ALL, function(cpShapeA, cpShapeB, cpArbiter)
		return false
	end)

	return self
end

function Rope:collideWithPlayer(cpShapeA, cpShapeB, cpArbiter)
	if ((not cpArbiter:isFirstContact()) or cpShapeA:getBody().gameObject:hasJoints() or cpShapeB:getBody().gameObject:hasJoints()) then
		return
	end
	print("Connecting a rope to a player")

	local goA = cpShapeA:getBody().gameObject
	local goB = cpShapeB:getBody().gameObject
	local player, ropeBody
	if (goA.type == "Player") then
		player = goA
		ropeBody = cpShapeB:getBody()
	else
		player = goB
		ropeBody = cpShapeA:getBody()
	end

	joint = MOAICpConstraint.newSlideJoint(player.ropeBody, ropeBody, 0, 0, 0, 0, 0, 1)
	joint:setBiasCoef ( .75 )

	Game.sceneManager:getCpSpace():insertPrim ( joint )
	
	cpShapeA:getBody().gameObject:addJoint(joint, cpShapeB:getBody().gameObject)
	cpShapeB:getBody().gameObject:addJoint(joint, cpShapeA:getBody().gameObject)

	player.carryingRope = true
end