require "class/Enemy"

ObjBoss = {}
ObjBoss.__index = ObjBoss

setmetatable(ObjBoss, {
	__index = ObjEnemy,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjBoss:_init(x,y,filepath,initX,initY,width,height)
	ObjEnemy._init(self,x,y,1,filepath,initX,initY,width,height)

	-- Default Values
	self.type = "boss"
	self.bossName = "?????"
	self.effect_color_list = {}
	self.circleColor = "Red"
	self.auraColor = {1,1,1}
	self.isDelete = true

	self.eventList = {}
	for i = 1, 20 do self.eventList[i] = {} end

end

function ObjBoss:start()
	self.isDelete = false
	self.mainTask = coroutine.create(self.main)
	coroutine.resume(self.mainTask,self)
end

function ObjBoss.main(self)
	for i = 1, #self.eventList do
		for j = 1, #self.eventList[i] do
			local event = self.eventList[i][j]
			system.current_event = event
			self.eventCurrent = event
			self:setLife(event.life)
			event.boss = self
			event:startTask(event.start)
			coroutine.yield()
		end
	end
	self.eventCurrent = nil
	self:delete()
end

function ObjBoss:addEvent(num,event) --Usually an attack pattern object, can also be dialogue events as well
	table.insert(self.eventList[num],event)
end

function ObjBoss:setBossName(name)
	self.bossName = name
end

function ObjBoss:setCircleColor(color)
	self.circleColor = color
end

function ObjBoss:setAuraColor(color)
	self.auraColor = color
end

function ObjBoss:addEffectColor(key,red,green,blue)
 self.effect_color_list[key] = {red=red,green=green,blue=blue}
end

function ObjBoss:updateCurrentEvent()
	if self.eventCurrent then self.eventCurrent:update() end
end

function ObjBoss:update(dt)
	if self.isDelete then return end

	if self.invincibility > 0 then
		self.invincibility = self.invincibility - 1
	end

	self:resumeAllTasks()
	self:updateCurrentEvent()
	ObjEnemy.collision(self,dt)
	-- if self.task.death_explosion then coroutine.resume(self.task.death_explosion) end
end
