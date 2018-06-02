System = {}
System.__index = System

setmetatable(System, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function System:_init(id,requires)
    assert(type(requires) == 'table')
	self.id = id
    self.requires = requires
end

function System:load(entity) end
function System:update(dt, entity) end
function System:draw(entity) end
function System:destroy(entity) end

function System:match(entity)
	for i = 1, #self.requires do
		if entity:getComponent(self.requires[i]) == nil then
			return false
		end
	end
	return true
end
