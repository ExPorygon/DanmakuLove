function love.load()
	listDrawLayer = {}
	for i = 1, 100 do
		listDrawLayer[i] = {}
	end

	require "lib/coroutine_error"
	require "lib/function_list"
	require "lib/function_wait"
	require "lib/function_math"
	require "lib/function_misc"
	require "lib/function_collision"

	require "class/System"
	system = ObjSystem(73,32,841,928)

	require "class/Player"
	require "class/SpriteBatch"
	require "class/Shot"
	require "class/Boss"
	require "class/Sound"
	require "class/Text"
	require "class/AttackPattern"

	ObjSound("shot1","sound/shot1.wav")
	ObjSound("pshot","sound/pshot.wav")
	ObjSound("shot2","sound/shot2.wav")
	ObjSound("spell","sound/spell.wav")

	require "script/player/TestPlayer_Reimu"
	-- require "script/eternity/TestEnemy_Eternity"
	require "script/eternity/TestBoss_Eternity"

	system:initFrame()
	system:initHUD()

	sHeight = love.graphics.getHeight()
	sWidth =  love.graphics.getWidth()

	testPlayerReimu()
	-- testEnemyEternity()
	testBossEternity()

end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
	if key == 'd' then DeleteAllShot() end
end

function love.update(dt)
	update_objects(shot_all,dt)
	bulletBreak:update(dt)
	system:update()
	player:update(dt)
	-- testImg:update(dt)
	-- objEnemy:update(dt)
	objBoss:update(dt)
	collectgarbage("step",2)
end

function love.draw()
	draw_layers()
	-- love.graphics.print("Boss Life:"..tostring(objBoss:getLife()),1100,700)
	love.graphics.print("FPS:"..tostring(love.timer.getFPS()),1230,940)
end

function draw_layers()
	for i = 1, 100 do
		local listIndex = {}
		for j = 1, #listDrawLayer[i] do
			if listDrawLayer[i][j].isDelete then
				table.insert(listIndex,j)
			else listDrawLayer[i][j]:draw() end
		end
		local offset = 0
		for j = 1, #listIndex do
			table.remove(listDrawLayer[i],listIndex[j]-offset)
			offset = offset + 1
		end
	end
end
