local game = {}
local boss = {}
local count = 0

function game:enter(old_state,toRun)
    count = 0
    game.listDrawLayer = initDrawLayers()
    setSystem(ObjSystem(73,32,841,928))
    system = getSystem()
    setPlayer(love.filesystem.load("script/player/TestPlayer_Reimu.lua")())
    player = getPlayer()
    player.start()

    system:initFrame()
    system:initHUD()
    initShotManager()

    local obj_ToRun = toRun()

    if obj_ToRun:getType() == "attackpattern" then
        boss = obj_ToRun.defaultBoss
        if boss then
            boss:addEvent(1,obj_ToRun)
            boss:start()
        else
            boss = ObjBoss(-80,-20)
            boss:addEvent(1,obj_ToRun)
            boss:start()
        end
    end
    if obj_ToRun:getType() == "boss" then
        boss = obj_ToRun
        boss:start()
    end
end

function game:update(dt)
    updateAllShots(dt)
	bulletBreak:update(dt)
	system:update()
	getPlayer():update(dt)
	if boss:isAlive() then
        boss:update(dt)
    else
        count = count+1
        if count>180 then StateManager.pop() end
    end
end

function game:keypressed(key)
    if key == 'd' then DeleteAllShot() end
end

function game:draw()
    draw_layers(self.listDrawLayer)
end

return game
