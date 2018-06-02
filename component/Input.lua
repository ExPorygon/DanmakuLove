Input = {}
Input.__index = Input

setmetatable(Input, {
    __index = Component,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Input:_init()
    Component._init(self,"input")
end
