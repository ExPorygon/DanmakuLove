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
	require "class/PlayerClass"
	require "class/ShotClass"
	require "class/EnemyClass"

	require "script/player/TestPlayer_Reimu"
	require "script/eternity/TestEnemy_Eternity"

	sHeight = love.graphics.getHeight()
	sWidth =  love.graphics.getWidth()

	testPlayerReimu()
	-- testImage()
	testEnemyEternity()


end

function testImage()
	testImg = ObjMove(600,200,"img/Star.png")
	testImg:setBlendMode("add")
	testImg:setScaleXY(0.2,0.2)
	testImg:setAlpha(150)
	testImg:setColor(32,255,255)
	-- testImg:setSpeed(0)
	-- testImg:setDirection(90)
	-- testImg:setAcceleration(0.01)
	-- testImg:setMaxSpeed(2.0)
	-- testImg:setAngularVelocity(0.3)
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
	if key == 'k' then DeleteAllShot() end
end

function love.update(dt)
	update_objects(shot_all,dt)

	player:update(dt)
	-- testImg:update(dt)
	objEnemy:update(dt)
	collectgarbage("step",2)
end

function love.draw()
	love.graphics.print("FPS:"..tostring(love.timer.getFPS()),5,5)
	-- love.graphics.print("Memory Usage:"..torstring(collectgarbage("count")/1000),5,15)
	love.graphics.print("Enemy Life:"..tostring(objEnemy:getLife()),objEnemy:getX()-60,objEnemy:getY()-100)
	love.graphics.print("Player State:"..player.state,5,45)
	love.graphics.print("Player invincibility:"..player.invincibility,5,55)

	draw_layers()
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
