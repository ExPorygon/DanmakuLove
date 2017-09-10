ObjSystem = {}
ObjSystem.__index = ObjSystem

setmetatable(ObjSystem, {
	__index = ObjBase,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})


function ObjSystem:_init(left,top,right,bottom)

	--Default Values
	self.screen = {left = left, top = top, right = right, bottom = bottom}
	self.item = {point = 0}
	self.score = 0
end

function ObjSystem:getCenter()
	return (self.screen.right - self.screen.left) / 2, (self.screen.bottom - self.screen.top) / 2
end

function ObjSystem:getCenterX()
	return (self.screen.right - self.screen.left) / 2
end

function ObjSystem:getCenterY()
	return (self.screen.bottom - self.screen.top) / 2
end
