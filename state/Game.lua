local game = State("game")
local boss = {}
local count = 0

function game:init()
    self:register(MoveSystem())
	self:register(RenderSystem(73,32,841,928))
    self:register(InputSystem())
    self:register(PlayerSystem())
    self:register(CollisionSystem())
    self:register(AnimationSystem())
end

function game:enter(old_state,toRun)
    count = 0
    -- game.listDrawLayer = initDrawLayers()
    -- setSystem(ObjSystem(73,32,841,928))
    -- system = getSystem()
    -- setPlayer(love.filesystem.load("script/player/TestPlayer_Reimu.lua")())
    -- player = getPlayer()
    -- player.start()

    -- system:initFrame()
    -- system:initHUD()
    -- initShotManager()
    -- initItemManager()

    -- local obj_ToRun = toRun()
    --
    -- if obj_ToRun:getType() == "attackpattern" then
    --     boss = obj_ToRun.defaultBoss
    --     if boss then
    --         boss:addEvent(1,obj_ToRun)
    --         boss:start()
    --     else
    --         boss = ObjBoss(-80,-20)
    --         boss:addEvent(1,obj_ToRun)
    --         boss:start()
    --     end
    -- end
    -- if obj_ToRun:getType() == "boss" then
    --     boss = obj_ToRun
    --     boss:start()
    -- end
end

function game:update(dt)
    -- updateAllShots(dt)
    -- updateAllItems(dt)
	-- bulletBreak:update(dt)
	-- system:update()
	-- getPlayer():update(dt)
	-- if boss:isAlive() then
    --     boss:update(dt)
    -- else
    --     count = count+1
    --     if count>180 then StateManager.pop() end
    -- end
    State.update(self,dt)
end

function game:keypressed(key)
    if key == 'd' then DeleteAllShot() end
end

function game:draw()
    -- draw_layers(self.listDrawLayer)
    State.draw(self)
    love.graphics.setColor(0.76, 0.18, 0.05)
	for _, body in pairs(__WORLD__.physicsWorld:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("fill", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
	love.graphics.setColor(1, 1, 1)
end

return game
