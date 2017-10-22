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
	ObjBase._init(self)

	--Default Values
	self.screen = {left = left, top = top, right = right, bottom = bottom}
	self.difficulty = "HARD"
	self.item_collected = {point = 0}
	self.score = 0
	self.hiscore = 0
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
	self:resumeAllTasks()
	-- self.hud.life:setText(player.life)
	-- self.hud.spell:setText(player.spell)
	self.hud.life:clear()
	for i = 1, player.life do
		self.hud.life:addQuadSprite(love.graphics.newQuad(426,3,41,38,512,1024),930+40*i,210,0,1,1,41/2,38/2)
	end
	self.hud.spell:clear()
	for i = 1, player.spell do
		self.hud.spell:addQuadSprite(love.graphics.newQuad(422,42,45,43,512,1024),930+40*i,250,0,1,1,45/2,43/2)
	end
	self.hud.score:setText(NumToCommas(system.score))
	self.hud.hiscore:setText(NumToCommas(system.hiscore))
	self.hud.piv:setText(NumToCommas(system.point_item_value))
	self.hud.graze:setText(NumToCommas(system.graze))
end

function ObjSystem:initHUD()
	local function Difficulty()
		local diff = ObjText(820,15,81,"Revue_Red.fnt",self.difficulty)
		diff:setAlignment("center")
		diff:setWrapLimit(500)
	end
	local function HiScore()
		local hiscore = ObjText(850,60,81,"Titillium_SemiBold_HUD.fnt","HiScore:")
		local num = ObjText(770,60,81,"Titillium_SemiBold_HUD.fnt")
		num:setAlignment("right")
		num:setWrapLimit(500)
		self.hud["hiscore"] = num
	end
	local function Score()
		local score = ObjText(850,100,81,"Titillium_SemiBold_HUD.fnt","Score:")
		local num = ObjText(770,100,81,"Titillium_SemiBold_HUD.fnt")
		num:setAlignment("right")
		num:setWrapLimit(500)
		self.hud["score"] = num
	end
	local function Life()
		local life = ObjText(850,190,81,"Titillium_SemiBold_HUD.fnt","Life:")
		life:setColor(255,64,255)
		-- local num = ObjText(1100,160,81,"Titillium_SemiBold_HUD.fnt")
		-- num:setColor(255,64,255)
		-- num:setAlignment("right")
		-- num:setWrapLimit(100)

		local num_bg = ObjSpriteBatch(81,"img/system.png",8)
		local num = ObjSpriteBatch(81,"img/system.png",8)
		for i = 1, 8 do
			num_bg:addQuadSprite(love.graphics.newQuad(468,3,41,38,512,1024),930+40*i,210,0,1,1,41/2,38/2)
		end
		self.hud["life_bg"] = num_bg
		self.hud["life"] = num
	end
	local function Spell()
		local spell = ObjText(850,230,81,"Titillium_SemiBold_HUD.fnt","Spell:")
		spell:setColor(64,255,64)
		-- local num = ObjText(1100,200,81,"Titillium_SemiBold_HUD.fnt")
		-- num:setColor(64,255,64)
		-- num:setAlignment("right")
		-- num:setWrapLimit(100)
		local num_bg = ObjSpriteBatch(81,"img/system.png",8)
		local num = ObjSpriteBatch(81,"img/system.png",8)
		for i = 1, 8 do
			num_bg:addQuadSprite(love.graphics.newQuad(467,42,45,43,512,1024),930+40*i,250,0,1,1,45/2,43/2)
		end
		self.hud["spell_bg"] = num_bg
		self.hud["spell"] = num
	end
	local function PIV()
		local value = ObjText(900,320,81,"Titillium_SemiBold_HUD.fnt","Value:")
		value:setColor(64,64,255)
		local num = ObjText(700,320,81,"Titillium_SemiBold_HUD.fnt")
		num:setColor(64,64,255)
		num:setAlignment("right")
		num:setWrapLimit(500)
		self.hud["piv"] = num
	end
	local function Graze()
		local graze = ObjText(900,360,81,"Titillium_SemiBold_HUD.fnt","Graze:")
		graze:setColor(128,128,128)
		local num = ObjText(700,360,81,"Titillium_SemiBold_HUD.fnt")
		num:setColor(128,128,128)
		num:setAlignment("right")
		num:setWrapLimit(500)
		self.hud["graze"] = num
	end
	Difficulty()
	HiScore()
	Score()
	Spell()
	Life()
	PIV()
	Graze()
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

function ObjSystem:getScreenHeight()
	return self.screen.bottom - self.screen.top
end

function ObjSystem:getScreenWidth()
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

function NumToCommas(input)
	local number = ""
	local stringInput = tostring(input)
	local length = string.len(stringInput)
		for i = length-1, 0, -1 do
			number = number .. string.sub(stringInput,length-i,length-i)
			if length > 3 then
				if i%3 == 0 and i ~= 0 then
					number = number .. ","
				end
			end
		end
	return number
end
