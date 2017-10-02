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
	system.sound_list.ALL[name] = self
end

function ObjSound:play(volume)
	if volume then self.source:setVolume(volume) end
	if self.source:isPlaying() then self.source:rewind() else self.source:play() end
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
	if self.group then table.remove(system.sound_list[group],self.groupIndex) end
	self.group = group
	if not system.sound_list[group] then system.sound_list[group] = {} end
	self.groupIndex = #system.sound_list[group] + 1
	table.insert(system.sound_list[group],self)
end

function ObjSound:update(dt)
	self:setVolume(self:getVolume()*system:getSFXVolume())
end