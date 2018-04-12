Position = {}
Position.__index = Position

setmetatable(Position, {
    __index = Component,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Position:_init(x,y)
    Component._init(self,"position")

    self.x = x
    self.y = y
end
