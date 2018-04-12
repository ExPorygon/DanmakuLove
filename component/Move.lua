Move = {}
Move.__index = Move

setmetatable(Move, {
    __index = Component,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Move:_init(speed,moveDir,acc,maxspeed,angvel)
    Component._init(self,"move")

	if speed then self.speed = speed else self.speed = 0 end
	if moveDir then self.moveDir = moveDir else self.moveDir = 0 end
	if acc then self.acc = acc else self.acc = 0 end
	if maxspeed then self.maxspeed = maxspeed else self.maxspeed = 0 end
	if angvel then self.angvel = angvel else self.angvel = 0 end

	self.isMoving = false
	self.destX = 0
	self.destY = 0
end
