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
    __WORLD__.physicsWorld:setCallbacks(self.beginCollision,self.endCollision)
end

function CollisionSystem.beginCollision(fix1,fix2,col)
    local entityList = StateManager.current().entities
    local entity1, entity2
    for i=1, #entityList do
        if entityList[i].components.collision.body == fix1:getBody() then entity1 = entityList[i] end
        if entityList[i].components.collision.body == fix2:getBody() then entity2 = entityList[i] end
    end
    if fix1:getCategory() == 1 and fix2:getCategory() == 2 then
        -- entity1:delete()
        entity2.components.player.state = "hit"
    end
    if fix1:getCategory() == 2 and fix2:getCategory() == 1 then
        entity1.components.player.state = "hit"
        -- entity2:delete()
    end
end
function CollisionSystem:update(dt,entity)
    local col = entity.components.collision
    col.body:setLinearVelocity(entity:getSpeedX(),entity:getSpeedY())
    col.body:setAngle(entity:getAngle())
    -- col.body:setPosition(entity:getX(),entity:getY())
    -- print(col.fixtures[1]:getShape():getType())
end

function CollisionSystem:draw(entity)

    -- for _, body in pairs(__WORLD__.physicsWorld:getBodyList()) do
    --     for _, fixture in pairs(body:getFixtureList()) do
    --         local shape = fixture:getShape()
    --         if shape:typeOf("CircleShape") then
    --             local cx, cy = body:getWorldPoints(shape:getPoint())
    --             love.graphics.circle("fill", cx, cy, shape:getRadius())
    --         elseif shape:typeOf("PolygonShape") then
    --             love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
    --         else
    --             love.graphics.line(body:getWorldPoints(shape:getPoints()))
    --         end
    --     end
    -- end

    -- local col = entity.components.collision
    -- if col.visible then
    --     for i=1,#col.fixtures do
    --         if col.fixtures[i]:getShape():getType() == "circle" then
    --             love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
    --         end
    --         if col.fixtures[i]:getShape():getType() == "polygon" then
    --             love.graphics.polygon("fill", objects.ball2.body:getWorldPoints(objects.ball2.shape:getPoints()))
    --         end

end

function CollisionSystem:update_old(dt,entity)
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
