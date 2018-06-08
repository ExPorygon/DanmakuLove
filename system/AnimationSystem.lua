AnimationSystem = {}
AnimationSystem.__index = AnimationSystem

setmetatable(AnimationSystem, {
    __index = System,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function AnimationSystem:_init(left,top,right,bottom)
    System._init(self,"animation",{"position","animation"})
    self.screen = {left = left, top = top, right = right, bottom = bottom}
end

function AnimationSystem:update(dt,entity)
    entity.components.animation.animation:update(1)
end

function AnimationSystem:draw(entity)
    entity.components.animation.animation:draw(entity:getX(),entity:getY())
end
