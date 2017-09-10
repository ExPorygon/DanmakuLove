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
	self.type = "attack_pattern"
	self.life = life
	if timer then self.timer_init = timer else self.timer_init = 60 end
	self.timer = self.timer_init
	self.shootdown_num = 0
	self.bomb_num = 0
	self.damage_rate = {shot = 100, bomb = 100}
	self.cutImage = ""
	if spell then self.isSpell = spell else self.isSpell = false end
	if last then self.isLastSpell = last else self.isLastSpell = false end
	if survival then self.isSurvivalSpell = survival else self.isSurvivalSpell = false end
	self.bossName = "?????"
	if name then self.attackName = name else self.attackName = "Test Sign 'Generic Pattern'" end
	self.scoreBase = 1
	self.circleColor = "Red"
	self.auraColor = {1,1,1}
	self.id = 1
	self.spellID = 1

	--Switches
	self.bombSwitch = true
	self.shootdownSwitch = true

end

function ObjAttackPattern.start(self)
	self:startTask(self.mainTask)

	-- while self:isAlive() do
		-- self:update()
		-- wait(1)
	-- end
end

function ObjAttackPattern:update(dt)
	-- if self.isDelete then return end
	self:resumeAllTasks()

	-- self.life = self.boss.life
	self.timer = self.timer - 1/60

	if self.timer <= 0 then self:finish() end
	if self.boss.life <= 0 then self:finish() end

	if player.isBombing and self.bombSwitch then self.bomb_num = self.bomb_num + 1 self.bombSwitch = false
	elseif not player.isBombing then self.bombSwitch = true end
	if player.state == "down" and self.shootdownSwitch then self.shootdown_num = self.shootdown_num + 1 self.shootdownSwitch = false
	elseif player.state ~= "down" then self.shootdownSwitch = true end
end

function ObjAttackPattern:finish()
	self:delete()
	coroutine.resume(self.boss.mainTask)
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
	self.scoreBase = BaseClass
end

function ObjAttackPattern:startSpell()
	self.isSpell = true
	--Insert cutin function here
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
