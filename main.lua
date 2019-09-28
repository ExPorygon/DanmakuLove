require "fixed"

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

function generateScriptDataList()
	local list = generateScriptList("script")
	local returnData = {}
	for i = #list, 1, -1 do
		if not checkScriptHeader(list[i]) then table.remove(list,i) end
	end
	for i = 1, #list do
		local data = generateScriptData(list[i])
		if data.Type ~= "Player" then table.insert(returnData,{FilePath = list[i], Type = data.Type, Title = data.Title, Text = data.Text}) end
	end
	return returnData
end

function generateScriptData(filepath)
	local file = love.filesystem.read(filepath)
	local data = {}
	for s in file:gmatch("[^\n]+") do
		local cap1, cap2 = s:match('--(%a*)%[(.-)%]')
		if cap1 == nil then break end
		if cap1 == "DanmakuLove" then cap1 = "Type" end
		data[cap1] = cap2
	end
	return data
end

function generateScriptList(directory)
	local scriptList = {}
	local itemList = love.filesystem.getDirectoryItems(directory)
	for i = 1, #itemList do
		local path = directory.."/"..itemList[i]
		if love.filesystem.getInfo(path,'directory') then
			local list = generateScriptList(path)
			scriptList = concatTables(scriptList,list)
		elseif path:sub(path:len()-3,path:len()) == ".lua" then
			table.insert(scriptList,path)
		end
	end
	return scriptList
end

function concatTables(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function checkScriptHeader(filepath)
	local file = love.filesystem.read(filepath)
	if file:find("--DanmakuLove") then return true else return false end
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
