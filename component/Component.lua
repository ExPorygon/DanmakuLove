Component = {}
Component.__index = Component

setmetatable(Component, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Component:_init(id)
	self.id = id
end
