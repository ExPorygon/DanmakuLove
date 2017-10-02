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
	self.game_draw = {min = 20, max = 80}
	self.volume_music = 1.0
	self.volume_sfx = 1.0
	self.hud = {}
	self.current_event = {}
	--self.state = use hump for this
	self.isReplay = false

end

function ObjSystem:update()
	self.hud.life:setText("Lives:   "..player.life)
	self.hud.spell:setText("Spell:   "..player.spell)
end

function ObjSystem:initHUD()
	-- local score = ObjText(900,200,81,"Eurostile_HUD.fnt","Score: "..player.score)
	-- score:setColor(255,255,255)
	-- self.hud["score"] = score

	local life = ObjText(900,300,81,"Eurostile_HUD.fnt","Life: "..player.life)
	life:setColor(255,64,255)
	self.hud["life"] = life

	local spell = ObjText(900,340,81,"Eurostile_HUD.fnt","Spell: "..player.spell)
	spell:setColor(64,255,64)
	self.hud["spell"] = spell
end

function ObjSystem:initFrame()
	self.frameImg = ObjImage(640,480,81,"img/frame.png")
end

function ObjSystem:setGameDrawPriority(min,max)
	self.game_draw.min = min
	self.game_draw.max = max
end

function ObjSystem:getGameDrawPriorityMin()
	return self.game_draw.min
end

function ObjSystem:getGameDrawPriorityMax()
	return self.game_draw.max
end

function ObjSystem:getSoundObject(name)
	local sound = self.sound_list.ALL[name]
	return assert(sound,name..": Sound object not found")
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

function ObjSystem:getHeight()
	return self.screen.bottom - self.screen.top
end

function ObjSystem:getWidth()
	return self.screen.right - self.screen.left
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
