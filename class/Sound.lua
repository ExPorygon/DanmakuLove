require "class/Base"

ObjSound = {}
ObjSound.__index = ObjSound

setmetatable(ObjSound, {
	__index = ObjBase,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})


function ObjSound:_init(name,filepath,group)
	ObjBase._init(self)

	self.type = "sound"
	self.source = love.audio.newSource(filepath, "static")
	self.name = name
	if group then self:setGroup(group) end
	getSoundObjectList("ALL")[name] = self
end

function ObjSound:play(volume)
	if volume then self.source:setVolume(volume) end
	if self.source:isPlaying() then self.source:seek(0) else self.source:play() end
end

function ObjSound:pause()
	self.source:pause()
end

function ObjSound:resume()
	self.source:resume()
end

function ObjSound:stop()
	self.source:stop()
end

function ObjSound:rewind()
	self.source:rewind()
end

function ObjSound:setVolume(volume)
	self.source:setVolume(volume)
end

function ObjSound:getVolume()
	return self.source:getVolume()
end

function ObjSound:setLooping(bool)
	self.source:setLooping(bool)
end

function ObjSound:setGroup(group)
	local sound_group = getSoundObjectList(group)
	if self.group then table.remove(sound_group,self.groupIndex) end
	self.group = group
	if not sound_group then sound_group = {} end
	self.groupIndex = #sound_group + 1
	table.insert(sound_group,self)
end

function ObjSound:update(dt)
	if system then self:setVolume(self:getVolume()*system:getSFXVolume()) end
end
