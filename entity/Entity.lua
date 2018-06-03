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
    self.components[component.id] = component
end

function Entity:getComponent(id)
    return self.components[id]
end

function Entity:delete()
    self.isDelete = true
end

function Entity:getX()
	return self.components.position.x
end

function Entity:getY()
	return self.components.position.y
end

function Entity:getSpeed()
	return self.components.move.speed
end

function Entity:setVisible(bool)
	local render = self.components.render
	if not render then return end
	-- assert(render,"The Entity does not have a 'render' component")
	render.visible = bool
end
