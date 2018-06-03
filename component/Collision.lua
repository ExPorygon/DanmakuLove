Collision = {}
Collision.__index = Collision

setmetatable(Collision, {
    __index = Component,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Collision:_init(type,hitbox)
    Component._init(self,"collision")

    assert(type == "enemy" or type == "player",'The type must be either "player" or "enemy"')

    if type then self.type = type else self.type = "enemy" end
    if hitbox then self.hitbox = hitbox else self.hitbox = 0 end
    self.isColliding = false

    -- table.insert(listEnemyCollisions,self.entity)
end
