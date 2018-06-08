Entity = {}
Entity.__index = Entity

setmetatable(Entity, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Entity:_init()

	--Default Values
	self.isDelete = false
	self.type = "base"
	self.value = {}
    self.components = {}
	table.insert(StateManager.current().entities,self)
end

function Entity:add(component)
    assert(component.id,"Component already exists")
	component.entity = self
	if component.bind then component:bind(self) end
    self.components[component.id] = component
end

function Entity:getComponent(id)
    return self.components[id]
end

function Entity:delete()
    self.isDelete = true
end

function Entity:getType()
	return self.type
end

function Entity:getX()
	return self.components.position.x
end

function Entity:getY()
	return self.components.position.y
end

function Entity:setX(x)
	local position = self.components.position
	if position then position.x = x end
end

function Entity:setY(y)
	local position = self.components.position
	if position then position.y = y end
end

function Entity:getSpeed()
	return self.components.move.speed
end

function Entity:setSpeed(speed)
	local move = self.components.move
	if move then move.speed = speed end
end

function Entity:setMoveDirection(dir)
	local move = self.components.move
	if move then move.moveDir = dir end
end

function Entity:setAcceleration(acc)
	local move = self.components.move
	if move then move.acc = acc end
end

function Entity:setAngularVelocity(angvel)
	local move = self.components.move
	if move then move.angvel = angvel end
end

function Entity:setMaxSpeed(maxspeed)
	local move = self.components.move
	if move then move.maxspeed = maxspeed end
end

function Entity:getSpeed()
	return self.components.move.speed
end

function Entity:getSpeedX()
	local move = self.components.move
	if move then return self.components.move.speed * math.cos(math.rad(self.components.move.moveDir)) else return nil end
end

function Entity:getSpeedY()
	local move = self.components.move
	if move then return self.components.move.speed * math.sin(math.rad(self.components.move.moveDir)) else return nil end
end

function Entity:getMoveDirection()
	return self.components.move.moveDir
end

function Entity:setAngle(angle)
	local render = self.components.render
	if not render then return end
	render.rotAngle = angle
end

function Entity:getAngle()
	return self.components.render.rotAngle
end

function Entity:setScaleX(scale)
	local render = self.components.render
	if not render then return end
	render.scale.x = scale
end

function Entity:setScaleY(scale)
	local render = self.components.render
	if render then render.scale.y = scale end
end

function Entity:getScaleX(scale)
	return self.components.render.scale.x
end

function Entity:getScaleY(scale)
	return self.components.render.scale.y
end

function Entity:setScaleXY(scaleX,scaleY)
	local render = self.components.render
	if not render then return end
	render.scale.x = scaleX
	render.scale.y = scaleY
end

function Entity:setVisible(bool)
	local render = self.components.render
	if not render then return end
	-- assert(render,"The Entity does not have a 'render' component")
	render.visible = bool
end

function Entity:setCollisionEnable(bool)
	local col = self.components.collision
	if col then col.enable = bool end
end
