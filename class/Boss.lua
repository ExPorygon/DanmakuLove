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
	self.name = "?????"
	self.effect_color = {}
	self.circleColor = "Red"
	self.auraColor = {1,1,1}

	self.isDelete = true

	self.lifebarCurrent = 1
	self.stepCurrent = 1
	self.eventList = {}
	self.HUD = {}
	self.life = {}
	self.lifeCount = 0
	self.lifebar_fill = 0
	for i = 1, 20 do self.eventList[i] = {} self.life[i] = {} end

end

function ObjBoss.initHUD(self)
	self.HUD.lifebar = ObjImage(system:getCenterX()+30,60,79,"img/lifebar.png",169,7,686,50)

	self.HUD.divider = {}
	for i = 1, #self.life[self.lifebarCurrent]-1 do
		self.HUD.divider[i] = ObjImage(-100,60,79,"img/divider.png")
		self.HUD.divider[i]:setScaleXY(0.7,1.07)
		-- self.HUD.divider[i]:setBlendMode("add")
	end

	self.HUD.lifebar_overlay = ObjImage(system:getCenterX()+30,60,79,"img/lifebar.png",169,71,686,50)
	self.HUD.timer_bg = ObjImage(60,60,79,"img/timer_bg.png")
	self.HUD.timer = ObjText(108,77,79,"Aldrich_HUD.fnt")
	self.HUD.name = ObjText(173,47,79,"Economica_HUD.fnt")
	self.HUD.lifebar_num = ObjSpriteBatch(79,"img/lifebar_heart.png",20)

	local alpha = 0
	for i = 1, 30 do
		alpha = alpha + 255/30
		for i,v in pairs(self.HUD) do
			if not v.type then
				for i = 1, #v do
					v[i]:setAlpha(alpha)
				end
			else v:setAlpha(alpha) end
		end
		wait(1)
	end
end

function ObjBoss:updateHUD()
	local life = self.lifebarCurrent
	local step = self.stepCurrent

	local life_list = {}
	for i = 1, #self.eventList[life] do
		life_list[i] = self.eventList[life][i].life
	end

	local lifeTotal = 0
	for i = 1, #life_list do
		lifeTotal = lifeTotal + life_list[i]
	end

	local fraction_list = {}
	for i = 1, #life_list do
		fraction_list[i] = life_list[i]/lifeTotal
	end

	local factor = 0
	for i = 1, #life_list do
		factor = factor + self.life[life][i]/life_list[i]*fraction_list[i]
	end

	if self.lifebar_fill < 1 then self.lifebar_fill = self.lifebar_fill + 1/60 end

	self.HUD.lifebar.quad:setViewport(169,7,30+(686-30)*factor*self.lifebar_fill,50)
	if self.eventCurrent then self.HUD.timer:setText(string.format("%0.0f",self.eventCurrent.timer)) end

	self.HUD.name:setText(self.name)
	self.HUD.name:setColor(128,255,255)

	local offset = 0
	for i = 1, #self.HUD.divider do
		-- local fractionIndex = #fraction_list
		-- self.HUD.divider[i]:setPosition(30+fraction_list[fractionIndex+1-i],)
		offset = offset + 670*fraction_list[i]
		self.HUD.divider[i]:setPosition(94+670-offset,60)
		self.HUD.divider[i]:setColor(0,55+200*(offset/670),255)
		self.HUD.divider[i]:setAlpha(75+180*(offset/670))
	end

	self.HUD.lifebar_num:clear()
	for i = 1, self.lifeCount do
		self.HUD.lifebar_num:addSprite(85+30*i,100,0,0.6,0.6,32,32)
	end
end

function ObjBoss:start()
	self.isDelete = false
	for i = 1, #self.eventList do
		for j = 1, #self.eventList[i] do
			self.life[i][j] = self.eventList[i][j].life
		end
	end
	for i = 1, 20 do
		local lifebar = self.life[i]
		if lifebar[#lifebar] and lifebar[#lifebar] > 0 then self.lifeCount = self.lifeCount + 1  end
	end
	self:startTask(self.initHUD)
	self.mainTask = coroutine.create(self.main)
	coroutine.resume(self.mainTask,self)
end

function ObjBoss.main(self)
	for i = 1, #self.eventList do
		self.lifeCount = self.lifeCount - 1
		if #self.eventList[i] <= 0 then break end
		self.lifebar_fill = 0
		self.lifebarCurrent = i
		for j = 1, #self.eventList[i] do
			self.stepCurrent = j
			local event = self.eventList[i][j]
			system.current_event = event
			self.eventCurrent = event
			-- self:setLife(event.life)
			event.boss = self
			event:startTask(event.start)
			coroutine.yield()
		end
	end
	for i,v in pairs(self.HUD) do
		if not v.type then
			for i = 1, #v do
				v[i]:delete()
			end
		else v:delete() end
	end
	self.eventCurrent = nil
	self:delete()
end

function ObjBoss:addEvent(num,event) --Usually an attack pattern object, can also be dialogue events as well
	table.insert(self.eventList[num],event)
end

function ObjBoss:setLife(life)
	self.life[self.lifebarCurrent][self.stepCurrent] = life
end

function ObjBoss:getLife()
	return self.life[self.lifebarCurrent][self.stepCurrent]
end

function ObjBoss:setName(name)
	self.name = name
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
	self:collision(self,dt)
	self:updateHUD()
	-- if self.task.death_explosion then coroutine.resume(self.task.death_explosion) end
end

function ObjBoss:collision()
	local lifebar = self.lifebarCurrent
	local step = self.stepCurrent
	for i = 1, 5000 do
		if shot_all[i].isDelete == false and shot_all[i].source == "player" then
			if math.dist(shot_all[i].x,shot_all[i].y,self.x,self.y) < (self.hitboxToShot + 14) then
				if self.invincibility <= 0 then self.life[lifebar][step] = self.life[lifebar][step] - shot_all[i].damage end
				shot_all[i].penetration = shot_all[i].penetration - 1
				if shot_all[i].penetration <= 0 then
					shot_all[i].isDelete = true
				end
			end
		end
	end
	if self.invincibility > 0 then return end
	for i = 1, #spell_all do
		if spell_all[i].isDelete == false then
			local obj = spell_all[i].collision
			if obj.type == "circle" then
				if math.dist(obj.x,obj.y,self.x,self.y) < (self.hitboxToShot + obj.radius) then
					self.life[lifebar][step] = self.life[lifebar][step] - spell_all[i].damage
				end
			end
			if obj.type == "rectangle" then
					-- local vert1,vert2,vert3,vert4 = getRectVertices(obj[j].startX,obj[j].startY,obj[j].endX,obj[j].endY,obj[j].width)
				if collideCircleWithRotatedRectangle( {x = self.x, y = self.y, radius = self.hitboxToShot} , obj) then
					self.life[lifebar][step] = self.life[lifebar][step] - spell_all[i].damage
				end
			end
		end
	end
end
