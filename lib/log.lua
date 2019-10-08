--Debug Logging Module

local log = {}

local saveDir = love.filesystem.getSaveDirectory()
local logDir = "log/"
local latest = "log/latest.log"
local all = "log/all.log"

log.isRunning = false

local old_print = print
function print(...)
	log.print(...)
	old_print(...)
end

function log.start(name)
	if log.isRunning then return end
	log.isRunning = true

	if not love.filesystem.exists(logDir) then love.filesystem.createDirectory(logDir) end
	love.filesystem.write(latest,"")
	if not love.filesystem.exists(all) then love.filesystem.write(all,"") end
	if name then
		log.print("--"..name.."--")
	else
		log.print("--Initiating Log--")
	end
	return true
end

function log.clear()
	love.filesystem.write(all,"")
end

function log.print(...)
	if not log.isRunning then return end
	local printResult = "["..os.date("%x - %X").."]\t"
	for i,v in ipairs({...}) do
		printResult = printResult .. v .. "\t"
    end
	printResult = printResult .. "\n"
	love.filesystem.append(latest,printResult)
	love.filesystem.append(all,printResult)
end

function log.stop()
	log.isRunning = false
end

return log
