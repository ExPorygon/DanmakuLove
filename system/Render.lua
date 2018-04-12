local Move = {}
Move.__index = Move

setmetatable(Move, {
    __index = System,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Move:_init()
    System._init(self,"move",{"position","move"})
end

function Move:update(dt,entity)
	-- if entity.isDelete then return end
	-- entity:resumeTask("move")

	entity.moveDir = entity.moveDir + entity.angvel * 60 * dt
	if (entity.acc > 0 and entity.speed < entity.maxspeed) or (entity.acc < 0 and entity.speed > entity.maxspeed) then
		entity.speed = entity.speed + entity.acc * 60 * dt
	end
	entity.x = entity.x + (entity.speed * 60 * math.cos(math.rad(entity.moveDir)) * dt)
	entity.y = entity.y + (entity.speed * 60 * math.sin(math.rad(entity.moveDir)) * dt)

    -- if entity.isMoving then
	-- 	if math.dist(entity.x,entity.y,entity.destX,entity.destY) <= entity.speed then
	-- 		entity.x = entity.destX
	-- 		entity.y = entity.destY
	-- 		entity.speed = 0
	-- 		entity.moveDir = 0
	-- 		entity.isMoving = false
	-- 	end
	-- end
end
