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
		segment = PhysicsGameObject:new():init(TextureAsset.get("whiterectangle.png"));
		segment.handle:setPos(x-50*i, y)
		segment:setColor(Colors.coral_red)
		self.ropeSegments[i] = segment
		if (i>1) then
			joint = MOAICpConstraint.newPivotJoint (self.ropeSegments[i-1].body, self.ropeSegments[i].body, -25, 0, 25, 0)
			--joint:setMaxForce ( 5000 )
			joint:setBiasCoef ( 0.75 )
			SceneManager.i:getCpSpace():insertPrim ( joint )
		end
	end
	return self
end

function Rope:setStartBody(startObject)
	joint = MOAICpConstraint.newPivotJoint (startObject.body, self.ropeSegments[1].body, 0, 0, 25, 0)
			--joint:setMaxForce ( 5000 )
			joint:setBiasCoef ( 0.75 )
			SceneManager.i:getCpSpace():insertPrim ( joint )
end