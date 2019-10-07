local script = {}
local dm = require 'lib.data_management'

function script.generateData(filepath)
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

function script.generateList(directory)
	local scriptList = {}
	local itemList = love.filesystem.getDirectoryItems(directory)
	for i = 1, #itemList do
		local path = directory.."/"..itemList[i]
		if love.filesystem.getInfo(path,'directory') then
			local list = script.generateList(path)
			scriptList = dm.concatTables(scriptList,list)
		elseif path:sub(path:len()-3,path:len()) == ".lua" then
			table.insert(scriptList,path)
		end
	end
	return scriptList
end

function script.checkHeader(filepath)
	local file = love.filesystem.read(filepath)
	if file:find("--DanmakuLove") then return true else return false end
end

function script.generateDataList()
	local list = script.generateList("script")
	local returnData = {}
	for i = #list, 1, -1 do
		if not script.checkHeader(list[i]) then table.remove(list,i) end
	end
	for i = 1, #list do
		local data = script.generateData(list[i])
		if data.Type ~= "Player" then table.insert(returnData,{FilePath = list[i], Type = data.Type, Title = data.Title, Text = data.Text}) end
	end
	return returnData
end

return script
