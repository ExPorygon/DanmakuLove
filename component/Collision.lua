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

function Collision:_init(shapetype,hitbox1,hitbox2,offsetX,offsetY)
    Component._init(self,"collision")

    -- assert(category == "enemy" or category == "player" or type(category)=="number",'The category must be either "player", "enemy", or an integer from 0 to 65535')
    -- assert(mask == "enemy" or mask == "player" or type(mask)=="number",'The mask must be either "player", "enemy", or an integer from 0 to 65535')

    self.body = love.physics.newBody(__WORLD__.physicsWorld,0,0,"dynamic")

    if not offsetX then offsetX = 0 end
    if not offsetY then offsetY = 0 end

    self.fixtures = {}
    local fixture
    if shapetype == "circle" then fixture = love.physics.newFixture(self.body, love.physics.newCircleShape(offsetX,offsetY,hitbox1), 0) end
    if shapetype == "rectangle" then fixture = love.physics.newFixture(self.body, love.physics.newRectangleShape(offsetX,offsetY,hitbox1,hitbox2), 0) end
    fixture:setSensor(true)
    table.insert(self.fixtures,fixture)
    -- table.insert(listEnemyCollisions,self.entity)

    self.enable = true
end

function Collision:bind(entity)
    local category, mask
    -- if entity:getType() == "enemy" then category = 1 mask = 2 end
    -- if entity:getType() == "player" then category = 2 mask = 5 end
    -- if entity:getType() == "shot" and entity.components.shot.source == "enemy" then category = 4 mask = 2 end
    -- if entity:getType() == "shot" and entity.components.shot.source == "player" then category = 8 mask = 1 end
    self.body:setPosition(entity:getX(),entity:getY())
    category = 1 mask = 2
    if entity.components.player then category = 2 mask = 5 end
    self.category = category
    self.mask = mask
    self.fixtures[1]:setFilterData(category,mask,0)
end

-- function Collision:addCollision(id,x,y,shape,hitbox1,hitbox2)
--     if shape == "circle" then shape = love.physics.newCircleShape(x,y,hitbox1) end
--     if shape == "rectangle" then shape = love.physics.newRectangleShape(x,y,hitbox1,hitbox2) end
--     self.fixtures[id] = love.physics.newFixture(self.body,shape,1)
--     self.fixtures[id]:setSensor(true)
-- end

-- function Collision:setSensor(id,bool)
--     self.body.fixture[id]:setSensor(bool)
-- end
