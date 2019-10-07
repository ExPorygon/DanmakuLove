require "fixed"
require "lib.global"

function love.load()
	StateManager = require "lib.GameState"
	states = {
		scriptselection = require "state.ScriptSelection",
		game = require "state.Game"
	}
	SignalManager = require "lib.Signal"
	__FRAMEWORK__ = require "class.Framework"
	__FRAMEWORK__:init()

	ObjSound("shot1","sound/shot1.wav")
	ObjSound("pshot","sound/pshot.wav")
	ObjSound("shot2","sound/shot2.wav")
	ObjSound("spell","sound/spell.wav")
	ObjSound("graze","sound/graze.wav")

	StateManager.switch(states.scriptselection)
	StateManager.registerEvents()

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

function draw_layers(listDrawLayer)
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

function initDrawLayers()
	local drawTable = {}
	for i = 1, 100 do
		drawTable[i] = {}
	end
	return drawTable
end
