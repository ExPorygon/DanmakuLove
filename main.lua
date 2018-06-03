function love.load()
	__WORLD__ = require "class.World"
	__WORLD__:init()
	-- listEnemyCollisions = {}

	require "state.State"

	require "entity.Entity"

	require "component.Component"
	require "component.Position"
	require "component.Move"
	require "component.RenderData"
	require "component.Input"
	require "component.PlayerData"
	require "component.Collision"

	require "system.System"
	require "system.MoveSystem"
	require "system.RenderSystem"
	require "system.InputSystem"
	require "system.PlayerSystem"
	require "system.CollisionSystem"

	StateManager = require "lib.GameState"
	states = {
		scriptselection = require "state.ScriptSelection",
		game = require "state.Game"
	}
	-- StateManager.switch(states.scriptselection)
	StateManager.switch(states.game)
	StateManager.registerEvents()

	entity = Entity()
	entity:add(Position(600,200))
	entity:add(Move(0,45))
	entity:add(RenderData(30,"img/eternity.png",0,0,164,212))
	entity:add(Collision("enemy",60))

	player = Entity()
	player:add(Position(600,680))
	player:add(PlayerData())
	player:add(Input())
	player:add(RenderData(30,"img/eternity.png",0,0,164,212))
	player:add(Collision("player",4))
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
end

function love.update(dt)
	collectgarbage("step",2)
end

function love.draw()
	love.graphics.print("FPS:"..tostring(love.timer.getFPS()),1230,940)

end
