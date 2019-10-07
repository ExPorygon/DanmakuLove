--Debug Logging Module

local log = {}

local saveDir = love.filesystem.getSaveDirectory()
local logDir = "log/"
local latest = "log/latest.log"
local all = "log/all.log"

log.isRunning = false

local old_print = print
function print(...)
	log.print(arg[1])
	old_print(...)
	--log.print(...)
end

function log.start(name)
	if log.isRunning then return end
	log.isRunning = true

	if not love.filesystem.exists(logDir) then love.filesystem.createDirectory(logDir) end
	love.filesystem.write(latest,"")
	if not love.filesystem.exists(all) then love.filesystem.write(all,"") end
	if name then
		log.print(os.date("%x - %X").."\t--"..name.."--")
	else
		log.print(os.date("%x - %X").."\t--Initiating Log--")
	end

	--love.filesystem.write(latest,"--Initiating Log--")

	--if love.filesystem.exists(all) then
		--love.filesystem.append(all,"\n--Initiating Log--\n")
	--else
		--love.filesystem.write(all,"--Initiating Log--\n")
	--end
	return true
end

function log.clear()
	love.filesystem.write(all,"")
end

function log.print(...)
	if not log.isRunning then return end
	local printResult = "["..os.date("%X").."]\t"
	for i,v in ipairs(arg) do
		printResult = printResult .. tostring(v) .. "\t"
    end
	printResult = printResult .. "\n"
	love.filesystem.append(latest,printResult)
	love.filesystem.append(all,printResult)
end

function log.stop()
	log.isRunning = false
end

return log
