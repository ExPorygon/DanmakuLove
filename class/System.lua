ObjSystem = {}
ObjSystem.__index = ObjSystem

setmetatable(ObjSystem, {
	__index = ObjBase,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})


function ObjSystem:_init(left,top,right,bottom)

	--Default Values
	self.screen = {left = left, top = top, right = right, bottom = bottom}
	self.item_collected = {point = 0}
	self.score = 0
	self.graze = 0
	self.point_item_value = 10000
	self.enemy_list = {}
	self.boss_list = {}
	self.shot_list = {}
	self.spell_list = {}
	self.item_list = {}
	self.sound_list = {ALL = {}}
	self.shot_auto_delete = {left = -64, top = -64, right = 64, bottom = 64}
	self.volume_music = 1.0
	self.volume_sfx = 1.0
	self.current_event = {}
	--self.state = use hump for this
	self.isReplay = false

end

function ObjSystem:getSoundObject(name)
	local sound = self.sound_list.ALL[name]
	if sound == nil then error("Sound object not found") end
	return sound
end

function ObjSystem:setMusicVolume(volume)
	self.volume_music = volume
end

function ObjSystem:setSFXVolume(volume)
	self.volume_sfx = volume
end

function ObjSystem:getMusicVolume()
	return self.volume_music
end

function ObjSystem:getSFXVolume()
	return self.volume_sfx
end

function ObjSystem:getCenter()
	return (self.screen.right - self.screen.left) / 2, (self.screen.bottom - self.screen.top) / 2
end

function ObjSystem:getCenterX()
	return (self.screen.right - self.screen.left) / 2
end

function ObjSystem:getCenterY()
	return (self.screen.bottom - self.screen.top) / 2
end
