MoveSystem = {}
MoveSystem.__index = MoveSystem

setmetatable(MoveSystem, {
    __index = System,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function MoveSystem:_init()
    System._init(self,"move",{"position","move"})
end

function MoveSystem:update(dt,entity)
	-- if entity.isDelete then return end
	-- entity:resumeTask("move")

    local move_data = entity:getComponent("move")
    local pos_data = entity:getComponent("position")

	move_data.moveDir = move_data.moveDir + move_data.angvel * 60 * dt
	if (move_data.acc > 0 and move_data.speed < move_data.maxspeed) or (move_data.acc < 0 and move_data.speed > move_data.maxspeed) then
		move_data.speed = move_data.speed + move_data.acc * 60 * dt
	end
	pos_data.x = pos_data.x + (move_data.speed * 60 * math.cos(math.rad(move_data.moveDir)) * dt)
	pos_data.y = pos_data.y + (move_data.speed * 60 * math.sin(math.rad(move_data.moveDir)) * dt)

    -- if move_data.isMoving then
	-- 	if math.dist(move_data.x,move_data.y,move_data.destX,move_data.destY) <= move_data.speed then
	-- 		move_data.x = move_data.destX
	-- 		move_data.y = move_data.destY
	-- 		move_data.speed = 0
	-- 		move_data.moveDir = 0
	-- 		move_data.isMoving = false
	-- 	end
	-- end
end
