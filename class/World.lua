local World = {}

setmetatable(World, {
	__index = ObjBase
})


function World:init()
	--log = require "lib.log"
    require "lib.coroutine_error"
    require "lib.wait"
    require "lib.math"
    require "lib.misc"
    require "lib.collision"

    -- require "class.Base"
    -- require "class.System"
    -- require "class.SpriteBatch"
    -- require "class.Sound"
    -- require "class.Text"
    -- require "class.Boss"
    -- require "class.AttackPattern"
    -- require "class.Laser"
	-- require "class.Item"
    -- require "class.Player"

    self.game_draw = {min = 20, max = 80}
    self.sound_list = {ALL = {}}
	self.physicsWorld = love.physics.newWorld(0, 0, true)

end

function World:update(dt)
	self.physicsWorld:update(1)
end

function setGameDrawPriority(min,max)
	World.game_draw.min = min
	World.game_draw.max = max
end

function getGameDrawPriorityMin()
	return World.game_draw.min
end

function getGameDrawPriorityMax()
	return World.game_draw.max
end

function getSoundObject(name)
	local sound = World.sound_list.ALL[name]
	return assert(sound,name..": Sound object not found")
end

function getSoundObjectList(group)
    return World.sound_list[group]
end

function setPlayer(player)
    World.player = player
end

function getPlayer()
    return World.player
end

function getAngleToPlayer(obj)
	return AngleBetweenPoints(obj.x,obj.y,World.player.x,World.player.y)
end

function getPlayerState()
	return World.player.state
end

function getDistanceToPlayer(obj)
	return math.dist(getPlayer():getX(),getPlayer():getY(),obj.x,obj.y)
end

return World
