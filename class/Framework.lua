local Framework = {}

setmetatable(Framework, {
	__index = ObjBase
})


function Framework:init()
	--log = require "lib.log"
    require "lib.math"
    require "lib.misc"
    require "lib.collision"

    require "class.Base"
    require "class.System"
    require "class.SpriteBatch"
    require "class.Sound"
    require "class.Text"
    require "class.Boss"
    require "class.AttackPattern"
    require "class.Laser"
	require "class.Item"
    require "class.Player"

    self.game_draw = {min = 20, max = 80}
    self.sound_list = {ALL = {}}

end

function setGameDrawPriority(min,max)
	Framework.game_draw.min = min
	Framework.game_draw.max = max
end

function getGameDrawPriorityMin()
	return Framework.game_draw.min
end

function getGameDrawPriorityMax()
	return Framework.game_draw.max
end

function getSoundObject(name)
	local sound = Framework.sound_list.ALL[name]
	return assert(sound,name..": Sound object not found")
end

function getSoundObjectList(group)
    return Framework.sound_list[group]
end

function setPlayer(player)
    Framework.player = player
end

function setSystem(system)
    Framework.system = system
end

function getPlayer()
    return Framework.player
end

function getSystem()
    return Framework.system
end

function getAngleToPlayer(obj)
	return AngleBetweenPoints(obj.x,obj.y,Framework.player.x,Framework.player.y)
end

function getPlayerState()
	return Framework.player.state
end

function getDistanceToPlayer(obj)
	return math.dist(getPlayer():getX(),getPlayer():getY(),obj.x,obj.y)
end

return Framework
