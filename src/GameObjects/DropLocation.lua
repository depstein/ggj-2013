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

	Game.sceneManager:getCpSpace():setCollisionHandler(tableaddr(DropLocation), tableaddr(Rope), MOAICpSpace.BEGIN, self.collideWithRope)
	return self
end

function DropLocation:collideWithRope(cpShapeA, cpShapeB, cpArbiter)
	if not cpArbiter:isFirstContact() then
		return
	end

	Game.particleManager:addParticle('deathBlossomCharge.pex')--assets/particles/

	for k, v in pairs(cpShapeA:getBody().gameObject.joints) do 
		Game.sceneManager:getCpSpace():removePrim(v)
	end
	for k, v in pairs(cpShapeB:getBody().gameObject.joints) do 
		Game.sceneManager:getCpSpace():removePrim(v)
	end

	joint = MOAICpConstraint.newSlideJoint(cpShapeA:getBody(), cpShapeB:getBody(), 0, 0, 0, 0, 0, 50)
	joint:setBiasCoef ( 0.75 )

	Game.sceneManager:getCpSpace():insertPrim ( joint )
	cpShapeA:getBody().gameObject:setGroup(tableaddr(Rope))
	table.insert(cpShapeA:getBody().gameObject.joints, joint)
	cpShapeB:getBody().gameObject:setGroup(tableaddr(Rope))
	table.insert(cpShapeB:getBody().gameObject.joints, joint)
end