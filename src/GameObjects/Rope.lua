require "Utility"
require "Player"
require "BallObject"

Rope = Class:new()
Rope.type = "Rope"

function Rope:init(x, y, numRopeSegments) 
	self.ropeHealth = 3
	self.ropeSegments = {}
	for i=1, numRopeSegments do
		segment = PhysicsGameObject:new():init(TextureAsset.get("bloodvessel.png"), {group=tableaddr(self), damp = false});
		segment.parent = self
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

	local endpoint1 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {isSensor=true, noadd = true});
	endpoint1.handle:setPos(self.ropeSegments[1]:getPos())
	endpoint1:setType(tableaddr(Rope))
	endpoint1:setGroup(tableaddr(Rope))
	endpoint1.parent = self
	local endpoint2 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {isSensor=true, noadd = true});
	endpoint2.handle:setPos(self.ropeSegments[numRopeSegments]:getPos())
	endpoint2:setType(tableaddr(Rope))
	endpoint2:setGroup(tableaddr(Rope))
	endpoint2.parent = self
	endpoint1:setColor(Game.colors.rhythm)
	endpoint2:setColor(Game.colors.rhythm)

	self.endpoint1 = endpoint1
	self.endpoint2 = endpoint2

	joint = MOAICpConstraint.newSlideJoint(self.ropeSegments[1].body, endpoint1.body, 20, 0, 0, 0, 0, 1)
	joint:setBiasCoef ( 0.75 )
	Game.sceneManager:getCpSpace():insertPrim ( joint )

	joint = MOAICpConstraint.newSlideJoint(self.ropeSegments[numRopeSegments].body, endpoint2.body, -20, 0, 0, 0, 0, 1)
	joint:setBiasCoef ( 0.75 )
	Game.sceneManager:getCpSpace():insertPrim ( joint )

	Game.sceneManager:getCpSpace():setCollisionHandler(SceneManager.OBJECT_TYPES.PLAYER, tableaddr(Rope), MOAICpSpace.BEGIN, self.collideWithPlayer)
	Game.sceneManager:getCpSpace():setCollisionHandler(tableaddr(BallObject), tableaddr(Rope), MOAICpSpace.BEGIN, self.collideWithBall)
	Game.sceneManager:getCpSpace():setCollisionHandler(SceneManager.OBJECT_TYPES.PLAYER, SceneManager.OBJECT_TYPES.ROPE_SEGMENT, MOAICpSpace.ALL, function(cpShapeA, cpShapeB, cpArbiter)
		return false
	end)
	Game.sceneManager:getCpSpace():setCollisionHandler(SceneManager.OBJECT_TYPES.ROPE_SEGMENT, SceneManager.OBJECT_TYPES.ENEMY, MOAICpSpace.BEGIN, self.ropeTakeHit)
	return self
end

function Rope:destroy()
	self.endpoint1:destroy()
	self.endpoint2:destroy()
	for k, v in pairs(self.ropeSegments) do
		v:destroy()
	end

	GameObject.destroy(self)
end

function Rope:collideWithPlayer(cpShapeA, cpShapeB, cpArbiter)
	if ((not cpArbiter:isFirstContact()) or cpShapeA:getBody().gameObject:hasJoints() or cpShapeB:getBody().gameObject:hasJoints()) then
		return
	end
	--print("Connecting a rope to a player")

	local goA = cpShapeA:getBody().gameObject
	local goB = cpShapeB:getBody().gameObject
	local player, ropeBody
	if (goA.type == "Player") then
		player = goA
		goB.parent.player = player
		ropeBody = cpShapeB:getBody()
	else
		player = goB
		goA.parent.player = player
		ropeBody = cpShapeA:getBody()
	end

	joint = MOAICpConstraint.newSlideJoint(player.ropeBody, ropeBody, 0, 0, 0, 0, 0, 1)
	joint:setBiasCoef ( .75 )

	Game.sceneManager:getCpSpace():insertPrim ( joint )
	
	cpShapeA:getBody().gameObject:addJoint(joint, cpShapeB:getBody().gameObject)
	cpShapeB:getBody().gameObject:addJoint(joint, cpShapeA:getBody().gameObject)

	player.carryingRope = true
end

function Rope:collideWithBall(cpShapeA, cpShapeB, cpArbiter)
	if ((not cpArbiter:isFirstContact()) or cpShapeA:getBody().gameObject:hasJoints() or cpShapeB:getBody().gameObject:hasJoints()) then
		return
	end
	--print("Connecting a rope to a ball")

	local goA = cpShapeA:getBody().gameObject
	local goB = cpShapeB:getBody().gameObject
	local ball, rope
	if (goA.type == "BallObject") then
		ball = goA
		ball.rope = goB
		ropeBody = cpShapeB:getBody()
	else
		ball = goB
		ball.rope = goA
		ropeBody = cpShapeA:getBody()
	end

	joint = MOAICpConstraint.newSlideJoint(cpShapeA:getBody(), cpShapeB:getBody(), 0, 0, 0, 0, 0, 50)
	joint:setBiasCoef ( 0.75 )

	Game.sceneManager:getCpSpace():insertPrim ( joint )
	
	cpShapeA:getBody().gameObject:addJoint(joint, cpShapeB:getBody().gameObject)
	cpShapeB:getBody().gameObject:addJoint(joint, cpShapeA:getBody().gameObject)
end

function Rope:ropeTakeHit(cpShapeA, cpShapeB, cpArbiter)
	if not cpArbiter:isFirstContact() then
		return
	end
	print("Rope took a hit!")

	local goA = cpShapeA:getBody().gameObject
	local goB = cpShapeB:getBody().gameObject
	local enemy, rope
	if (goA.type == "Rope") then
		rope = goA.parent
		enemy = goB
	else
		rope = goB.parent
		enemy = goA
	end

	rope.ropeHealth = rope.ropeHealth - 1
	if rope.ropeHealth <= 0 then
		print("DESTROYING ROPE")
		if rope.player then
			rope.player.carryingRope = false
				for k, v in pairs(rope.player.joints) do
				rope.player:removeJoint(k)
			end
		end
		Game.waveManager:spawnRope()
		rope:destroy()
	end
end