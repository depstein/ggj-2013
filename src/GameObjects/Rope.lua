require "Player"

Rope = {}
Rope.type = "Rope"

function Rope:new(o)
	o = o or {}
	setmetatable(o, {__index = self})
	return o
end

function Rope:init(x, y, numRopeSegments) 
	self.ropeSegments = {}
	for i=1, numRopeSegments do
		segment = PhysicsGameObject:new():init(TextureAsset.get("whiterectangle.png"), {group=tableaddr(self)});
		segment.handle:setPos(x-50*i, y)
		segment:setColor(Colors.coral_red)
		segment.body:setMass(0.1)
		self.ropeSegments[i] = segment
		if (i>1) then
			joint = MOAICpConstraint.newSlideJoint (self.ropeSegments[i-1].body, self.ropeSegments[i].body, -25, 0, 25, 0, 0, 1)
			--joint:setMaxForce ( 5000 )
			joint:setBiasCoef ( 0.75 )
			SceneManager.i:getCpSpace():insertPrim ( joint )
		end
	end

	endpoint1 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {isSensor=true});
	endpoint1.handle:setPos(self.ropeSegments[1]:getPos())
	endpoint1:setType(tableaddr(Rope))
	endpoint2 = PhysicsGameObject:new():init(TextureAsset.get("whitesquare.png"), {isSensor=true});
	endpoint2.handle:setPos(self.ropeSegments[numRopeSegments]:getPos())
	endpoint2:setType(tableaddr(Rope))
	endpoint1:setColor(Colors.rhythm)
	endpoint2:setColor(Colors.rhythm)

	joint = MOAICpConstraint.newSlideJoint(self.ropeSegments[1].body, endpoint1.body, 25, 0, 0, 0, 0, 5)
	joint:setBiasCoef ( 0.75 )
	SceneManager.i:getCpSpace():insertPrim ( joint )

	joint = MOAICpConstraint.newSlideJoint(self.ropeSegments[numRopeSegments].body, endpoint2.body, -25, 0, 0, 0, 0, 5)
	joint:setBiasCoef ( 0.75 )
	SceneManager.i:getCpSpace():insertPrim ( joint )

	SceneManager.i:getCpSpace():setCollisionHandler(SceneManager.objectTypes.player, tableaddr(Rope), MOAICpSpace.BEGIN, self.collideWithRope)
	return self
end

function Rope:collideWithRope(cpShapeA, cpShapeB, cpArbiter)
	if not cpArbiter:isFirstContact() then
		return
	end
	joint = MOAICpConstraint.newSlideJoint(cpShapeA:getBody(), cpShapeB:getBody(), 0, 0, 0, 0, 0, 50)
	joint:setBiasCoef ( 0.75 )
	SceneManager.i:getCpSpace():insertPrim ( joint )
	cpShapeA:setGroup(tableaddr(Rope))
	cpShapeB:setGroup(tableaddr(Rope))
end