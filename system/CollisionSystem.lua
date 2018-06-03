CollisionSystem = {}
CollisionSystem.__index = CollisionSystem

setmetatable(CollisionSystem, {
    __index = System,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function CollisionSystem:_init(left,top,right,bottom)
    System._init(self,"collision",{"collision","position"})
    self.screen = {left = left, top = top, right = right, bottom = bottom}
end

function CollisionSystem:update(dt,entity)
    local listAllEntity = StateManager.current().entities
    local col1 = entity:getComponent("collision")

    local pos1 = entity:getComponent("position")

    col1.isColliding = false
    col1.listAllColliders = {}
    for i = 1, #listAllEntity do
		-- local shot = shot_all[i]
        local entityToCollide = listAllEntity[i]

		if self:match(entityToCollide) and entityToCollide.isDelete == false and entityToCollide ~= entity then
            local col2 = entityToCollide:getComponent("collision")
            local pos2 = entityToCollide:getComponent("position")
			if math.dist(pos1.x,pos1.y,pos2.x,pos2.y) < (col1.hitbox + col2.hitbox) then

				-- collision:delete()
				-- if entity.state == "normal" and entity.invincibility <= 0 then
					-- return true
                    col1.isColliding = true --Perhaps replace this and following line with a signal?

                    table.insert(col1.listAllColliders,entityToCollide)
				-- end
			end
		end
	end
end
function CollisionSystem:checkPriorityRange(entity)
	-- if self.type == "spritebatch" or self.type == "image" then return false end
    local render_data = entity:getComponent("render")
	return render_data:getDrawPriority() > getGameDrawPriorityMin() and render_data:getDrawPriority() < getGameDrawPriorityMax()
end
