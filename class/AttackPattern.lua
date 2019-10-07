require "class/Base"

ObjAttackPattern = {}
ObjAttackPattern.__index = ObjAttackPattern

setmetatable(ObjAttackPattern, {
	__index = ObjBase,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjAttackPattern:_init(life,timer,name,spell,survival,last)
	ObjBase._init(self)

	-- Default Values
	self.type = "attackpattern"
	self.life = life
	if timer then self.timer_init = timer else self.timer_init = 60 end
	self.timer = self.timer_init
	self.score = 0
	self.score_init = 0
	self.score_count = 0
	self.isScoreDecay = true
	self.shootdown_num = 0
	self.bomb_num = 0
	self.damage_rate = {shot = 100, bomb = 100}
	self.cutImage = ""
	if spell then self.isSpell = spell else self.isSpell = false end
	if last then self.isLastSpell = last else self.isLastSpell = false end
	if survival then self.isSurvivalSpell = survival else self.isSurvivalSpell = false end
	self.bossName = "?????"
	if name then self.attackName = name else self.attackName = "Test Sign \"Generic Pattern\"" end
	self.scoreBase = 1

	self.circleColor = "Red"
	self.auraColor = {1,1,1}
	self.id = 1
	self.spellID = 1

	--Switches
	self.bombSwitch = true
	self.shootdownSwitch = true

end

function ObjAttackPattern:update(dt)
	-- if self.isDelete then return end
	self:resumeAllTasks()

	self.timer = self.timer - 1/60
	self.score_count = self.score_count + 1
	if self.score_count > 300 and not self.isSurvivalSpell and self.isScoreDecay then
		self.score = self.score_init*(1/3)+(self.score_init*(2/3)*(self.timer/(self.timer_init-5)))
	end

	if self.timer <= 0 then self:_finish() end
	if self.boss:getLife() <= 0 then self:_finish() end

	if player.isBombing and self.bombSwitch then self.bomb_num = self.bomb_num + 1 self.bombSwitch = false
	elseif not player.isBombing then self.bombSwitch = true end
	if player.state == "down" and self.shootdownSwitch then self.shootdown_num = self.shootdown_num + 1 self.shootdownSwitch = false
	elseif player.state ~= "down" then self.shootdownSwitch = true end
end

function ObjAttackPattern:start()
end

function ObjAttackPattern:_finish()
	self.finish()
	self.boss:setLife(0)
	self:delete()
	coroutine.resume(self.boss.mainTask)
end

function ObjAttackPattern.finish()
end

function ObjAttackPattern:setDefaultBoss(obj)
	self.defaultBoss = obj
end

function ObjAttackPattern:getDefaultBoss()
	return self.defaultBoss
end

function ObjAttackPattern:setScore(score)
	self.score = score
end

function ObjAttackPattern:setScoreDecayEnable(bool) --Enabled by default
	self.isScoreDecay = bool
end

function ObjAttackPattern:resetScoreDecay()
	self.score_init = self.score
	self.score_count = 0
end

function ObjAttackPattern:setDamageRate(shotRate,bombRate)
	self.damage_rate.shot = shotRate
	self.damage_rate.bomb = bombRate
end

function ObjAttackPattern:getBombCount()
	return self.bomb_num
end

function ObjAttackPattern:getShootdownCount()
	return self.shootdown_num
end

function ObjAttackPattern:setTimer(timer)
	self.timer = timer
	self.timer_init = timer
end

function ObjAttackPattern:getTimer()
	return self.timer
end

function ObjAttackPattern:setScoreBase(base)
	self.scoreBase = base
end

function ObjAttackPattern:startSpell(score)
	if self.isSpell then return end
	self.isSpell = true
	if score then
		self.score_init = score
		self.score = score
	else
		self.score_init = 0
		self.score = 0
	end
	getSoundObject("spell"):play(0.8)
end

function ObjAttackPattern:setAttackName(name)
	self.attackName = name
end

function ObjAttackPattern:setBossName(name)
	self.bossName = name
end

function ObjAttackPattern:setAttackID(id)
	self.id = id
end

function ObjAttackPattern:setSpellID(id)
	self.spellID = id
end

function ObjAttackPattern:cutIn(cutType,cutImg)
	local sWidth = system:getScreenWidth()
	local sHeight = system:getScreenHeight()
	local SpellCardName = self.attackName

	local function Cut(num)
		local img
		if num then img = cutImg[num] else img = cutImg end
		local obj = ObjMove(-1000,-1000,30,img)
		local a = 220 --alpha
		local count = 0 --frame counter
		local x = 0
		local y = 0

		local s = 0.8 --scale
		local f = 0
		local g = 0
		if cutType == "NAZRIN" then
			x = sWidth+256
			y = sHeight/2-100
		end
		if cutType == "TABLE" then
			if num==nil or num==1 then
				x = -40
				y = sHeight/2
			end
			if num==2 then
				x = sWidth+40
				y = sHeight/2
			end
			if num==3 then
				x = sWidth/2-25
				y = sHeight+20
			end
		end
		while obj:isAlive() do
			if cutType == "NAZRIN" then
				if count<21 then x=x-20 y=y+5 end
				if count>=21 and count<100 then x=x-1 y=y+0.5 end
				if count>=100 then x=x-20 y=y+5 end
				if count>120 then obj:delete() end
				obj:setScaleXY(s,s)
				obj:setPosition(x,y)
				obj:setAlpha(a)
			end
			if num==nil or num==1 then
				if cutType == "TABLE" then
					if count<30 then x=x+40-g g=g+40/30 end
					if count>=70 then s=s+0.02-f f=f+0.0005 a=a-220/40 end
					if count>160 then obj:delete() end
					obj:setScaleXY(s,s)
					obj:setPosition(x,y)
					obj:setAlpha(a)
				end
			end
			if num==2 then
				if cutType == "TABLE" then
					if count<30 then x=x-40-g g=g+40/30 end
					if count>=70 then s=s+0.02-f f=f+0.0005 a=a-220/40 end
					if count>160 then obj:delete() end
					obj:setScaleXY(s,s)
					obj:setPosition(x,y)
					obj:setAlpha(a)
				end
			end
			if num==3 then
				if cutType == "TABLE" then
					if count<30 then y=y-40-g g=g+40/30 end
					if count>=70 then s=s+0.02-f f=f+0.0005 a=a-220/40 end
					if count>160 then obj:delete() end
					obj:setScaleXY(s,s)
					obj:setPosition(x,y)
					obj:setAlpha(a)
				end
			end
			count=count+1
			coroutine.yield()
		end
	end
	local function ScrollingText(self)
		local function Text(x,y,dir)
			local objAttack = ObjMove(x,y,29,"img/SpellCardAttack.png",0,0,256*20,32)
			objAttack:setWrap("repeat")
			local a = 0

			if dir == 135 then objAttack:setAngle(dir-180) end
			if dir == 315 then objAttack:setAngle(dir) end

			for i = 1, 30 do
				objAttack:setAlpha(a)
				objAttack:setPosition(x,y)
				x=x+5*math.cos(math.rad(dir))
				y=y+5*math.sin(math.rad(dir))
				a=a+255/30
				coroutine.yield()
			end
			for i = 1, 70 do
				objAttack:setPosition(x,y)
				x=x+6*math.cos(math.rad(dir))
				y=y+6*math.sin(math.rad(dir))
				coroutine.yield()
			end
			for i = 1, 30 do
				objAttack:setAlpha(a)
				objAttack:setPosition(x,y)
				x=x+6*math.cos(math.rad(dir))
				y=y+6*math.sin(math.rad(dir))
				a=a-255/30
				coroutine.yield()
			end
			objAttack:delete()
		end
		for i = -6, 12 do
			system:startTask(Text,-200+i*240,-200,135)
			system:startTask(Text,-200+i*240+60,-200+60,315)
		end
	end
	local function SpellText(self)
		local function SpellBG()
			local objbg = ObjMove(-1000,-1000,69,"img/SpellNameBG.png")
			local scale = 1.5
			local a = 0
			local a2 = 0

			for i = 1, 20 do
				objbg:setPosition(sWidth-270,740)
				objbg:setAlpha(a)
				objbg:setScaleXY(scale,scale)
				if scale>1 then scale=scale-0.5/20 end
				coroutine.yield()
			end
			for i = 1, 45 do coroutine.yield() end
			objbg:setDestAtWeight(sWidth-270,120,6,18)
			while(self:isAlive()) do
				objbg:setAlpha(a2)
				objbg:update(love.timer.getDelta())
				coroutine.yield()
			end
			for i = 1, 20 do
				objbg:setX(objbg:getX()+40)
				objbg:update(love.timer.getDelta())
				coroutine.yield()
			end
			objbg:delete()
		end
		local function SpellBonus()
			local y2 = 800
			local a = 0
			local a2 = 0
			local objtext2a = ObjText(-1000,-1000,70,"Titillium_SemiBold_Spell.fnt")
			objtext2a:setText("Bonus:",270,"right")
			objtext2a:setColor(128,255,255)

			local objtext2b = ObjText(-1000,-1000,70,"Titillium_SemiBold_Spell.fnt")
			objtext2b:setAlignment("right")
			objtext2b:setWrapLimit(270)

			for i = 1, 20 do
				objtext2a:setPosition(sWidth/2-90,y2,0)
				objtext2b:setPosition(sWidth/2-10,y2,0)
				objtext2a:setAlpha(a)
				objtext2b:setAlpha(a)
				if self.shootdown_num > 0 or self.bomb_num > 0 then
					objtext2b:setText("Failed")
				else
					objtext2b:setText(math.floor(self.score))
				end
				coroutine.yield()
			end
			for i = 1, 45 do
				if self.shootdown_num > 0 or self.bomb_num > 0 then
					objtext2b:setText("Failed")
				else
					objtext2b:setText(math.floor(self.score))
				end
				coroutine.yield()
			end
			objtext2a:setDestAtWeight(sWidth/2-90,180,6,18)
			objtext2b:setDestAtWeight(sWidth/2-10,180,6,18)
			while(self:isAlive()) do
				objtext2a:setAlpha(a2)
				objtext2b:setAlpha(a2)
				objtext2a:update(love.timer.getDelta())
				objtext2b:update(love.timer.getDelta())
				if self.shootdown_num > 0 or self.bomb_num > 0 then
					objtext2b:setText("Failed")
				else
					objtext2b:setText(math.floor(self.score))
				end
				coroutine.yield()
			end
			for i = 1, 20 do
				objtext2a:setX(objtext2a:getX()+40)
				objtext2b:setX(objtext2b:getX()+40)
				coroutine.yield()
			end
			objtext2a:delete()
			objtext2b:delete()
		end

		local objtext = ObjText(-1000,-1000,70,"Cirno_Spell.fnt")
		local x1 = sWidth/2-570
		local a = 0
		local a2 = 0
		local y1 = 765

		objtext:setText(SpellCardName,1000,"right")


		system:startTask(SpellBG)
		system:startTask(SpellBonus)

		for i = 1, 20 do
			objtext:setPosition(x1,y1)
			objtext:setAlpha(a)
			objtext:update(love.timer.getDelta())
			if a<255 then a=a+255/20 end
			if x1>sWidth/2-20 then x1=x1-30/20 end
			coroutine.yield()
		end
		for i = 1, 45 do coroutine.yield() end
		a2 = a
		objtext:setDestAtWeight(x1,140,6,18)
		while(self:isAlive()) do
			objtext:setText(SpellCardName)
			objtext:setAlpha(a2)
			objtext:update(love.timer.getDelta())
			if player:getY()<90 and a2>a-180 then
				a2=a2-10
			elseif a2<a then
				a2=a2+10
			end
			coroutine.yield()
		end
		for i = 1, 20 do
			objtext:setX(objtext:getX()+40)
			objtext:update(love.timer.getDelta())
			coroutine.yield()
		end
		objtext:delete()
	end

	if type(cutImg) == "table" then
		for i = #table, 1, -1 do
			system:startTask(Cut,i)
		end
	else system:startTask(Cut) end
	system:startTask(SpellText,self)
	system:startTask(ScrollingText,self)
end
