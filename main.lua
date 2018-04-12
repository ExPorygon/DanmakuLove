function love.load()
	require "entity.Entity"

	require "component.Component"
	require "component.Position"
	require "component.Move"

	require "system.system"
	require "system.MoveSystem"

	moveSystem = MoveSystem()

	entity = Entity()
	position = Position(600,200)
	move = Move(3,45)
	entity:add(position)
	entity:add(move)
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
end

function love.update(dt)
	moveSystem:update(dt,entity)


	collectgarbage("step",2)
end

function love.draw()
	love.graphics.print("FPS:"..tostring(love.timer.getFPS()),1230,940)
	love.graphics.print(entity:getX().."  "..entity:getY(),30,30)
	love.graphics.print(entity:getSpeed(),30,60)
end
