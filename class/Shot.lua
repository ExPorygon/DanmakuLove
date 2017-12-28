require "class/Move"
local anim8 = require 'lib/anim8'

local ShotData_Enemy = require "script/shot/TestShot_Enemy"

local color_code
local imgDelay
local quadDelay
local colorDelay
local scaleDelay
local minScaleDelay

ObjShot = {}
ObjShot.__index = ObjShot

setmetatable(ObjShot, {
	__index = ObjMove,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjShot:_init(x,y,source)
	if source == "enemy" then ObjMove._init(self,x,y,50) end
	if source == "player" then ObjMove._init(self,x,y,40) end

	-- Default Values
	self.type = "shot"
	self.graphic = 1
	self.delay = 0
	self.hitbox = 5
	self.damage = 0
	self.penetration = 0
	self.isGrazed = false
	self.grazeAmount = 1
	self.anim = false
	self.source = source
	if source == "enemy" then self.definition = ShotData_Enemy end
	if source == "player" then self.definition = player:getShotDefinition() end
	if self.definition then	self.image = self.definition.image end
end

function initShotManager()
	shot_all = {}
	laser_all = {}
	for i = 1, 5000 do
		local obj = ObjShot(0,0)
		obj.isDelete = true
		shot_all[i] = obj
	end
	for i = 1, 2000 do
		local obj = ObjLaser(0,0)
		obj.isDelete = true
		laser_all[i] = obj
	end

	color_code = {
		gray = {r=128,g=128,b=128}, red = {r=255,g=0,b=0}, darkred = {r=255,g=0,b=0}, pink = {r=255,g=0,b=128}, maroon = {r=255,g=0,b=128}, magenta = {r=255,g=0,b=255}, darkmagenta = {r=255,g=0,b=255}, purple = {r=128,g=0,b=255}, darkpurple = {r=128,g=0,b=255}, blue = {r=0,g=0,b=255}, darkblue = {r=0,g=0,b=255}, azure = {r=0,g=128,b=255}, darkazure = {r=0,g=128,b=255}, brightazure = {r=0,g=200,b=255}, aqua = {r=0,g=255,b=255}, darkaqua = {r=0,g=255,b=255}, spring = {r=0,g=255,b=128}, darkspring = {r=0,g=255,b=128}, green = {r=0,g=255,b=0}, darkgreen = {r=0,g=255,b=0}, chartreuse = {r=128,g=255,b=0}, swampgreen = {r=128,g=255,b=0}, brightchartreuse = {r=64,g=255,b=0}, yellow = {r=255,g=255,b=0}, darkyellow = {r=255,g=255,b=0}, brightyellow = {r=255,g=255,b=0}, gold = {r=255,g=192,b=0}, orange = {r=255,g=128,b=0}, darkorange = {r=255,g=128,b=0}, lightgray = {r=192,g=192,b=192}, black = {r=128,g=128,b=128}, white = {r=255,g=255,b=255}
	}

	imgDelay = love.graphics.newImage("img/delay.png")
	quadDelay = {}
	for i = 0, 7 do
		quadDelay[i+1] = love.graphics.newQuad(0+i*64, 0, 64, 64, imgDelay:getDimensions())
	end
	colorDelay = {
		gray = quadDelay[1], darkred = quadDelay[2], red = quadDelay[2], purple = quadDelay[3], magenta = quadDelay[3], darkblue = quadDelay[4], blue = quadDelay[4], darkaqua = quadDelay[5], aqua = quadDelay[5], darkgreen = quadDelay[6], green = quadDelay[6], darkyellow = quadDelay[7], yellow = quadDelay[7], darkorange = quadDelay[8], orange = quadDelay[8], white = quadDelay[1]
	}
	scaleDelay = 0
	minScaleDelay = 0

	bulletBreak = ObjSpriteBatch(50,"img/bullet_break.png",5000)
	bulletBreak:setGrid(64, 64, bulletBreak.image:getWidth(), bulletBreak.image:getHeight())
	bulletBreak:setBlendMode("add")
	bulletBreak.anim_list = {}
	bulletBreak.sprite_list = {}

	function ObjShot:bulletBreakEffect()
		local frames = bulletBreak.grid('1-8',1)
		local anim = anim8.newAnimation(frames,(1/60)*3,"pauseAtEnd")
		table.insert(bulletBreak.anim_list,anim)
		table.insert(bulletBreak.sprite_list,{x = self.x, y = self.y, frame = 0, color = color_code[self.data.delay_color], scaleX = self.scale.x*self.data.width/32, scaleY = self.scale.y*self.data.height/32})
	end

	function bulletBreak:update()
		local dt = 1/60
		bulletBreak:clear()
		for i = 1, #bulletBreak.sprite_list do
			local anim = bulletBreak.anim_list[i]
			local sprite = bulletBreak.sprite_list[i]
			local x = sprite.x
			local y = sprite.y
			local c = sprite.color
			sprite.frame = sprite.frame + 1
			bulletBreak.source:setColor(c.r,c.g,c.b,255)
			bulletBreak:addQuadSprite(anim:getFrameInfo(x,y,0,0.8*sprite.scaleX,0.8*sprite.scaleY,32,32))
			anim:update(dt)
		end
		for i = #bulletBreak.sprite_list, 1, -1 do
			if bulletBreak.sprite_list[i].frame >= 24 then
				table.remove(bulletBreak.sprite_list,i)
				table.remove(bulletBreak.anim_list,i)
			end
		end
	end
end

function updateAllShots(dt)
	for i = 1, 5000 do
		if shot_all[i].isDelete == false then
			shot_all[i]:update(dt)
		end
    end
	for i = 1, 2000 do
		if laser_all[i].isDelete == false then
			laser_all[i]:update(dt)
		end
	end
end

function ObjShot:setGraphic(graphic)
	self.graphic = graphic
end

function ObjShot:getGraphic()
	return self.graphic
end

function ObjShot:draw()
	if self.isDelete or not self.visible then return end

	local drawX,drawY
	if self:checkPriorityRange() then
		drawX, drawY = self.x + system.screen.left, self.y + system.screen.top
	else
		drawX, drawY = self.x, self.y
	end

	self.data = self.definition[self.graphic]
	assert(self.data,"Shot ID \""..self.graphic.."\" does not exist")

	if self.isDelay then
		local initBlendMode = love.graphics.getBlendMode()
		love.graphics.setBlendMode("add")
		minScaleDelay = 0.45*(self.data.width/16)
		scaleDelay = math.min(minScaleDelay+3.0*(self.delay/75), minScaleDelay+3.0)
		love.graphics.draw(imgDelay, colorDelay[self.data.delay_color], drawX, drawY, 0, scaleDelay, scaleDelay, 32, 32)
		love.graphics.setBlendMode(initBlendMode)
	else
		self.offset_auto.x = self.data.width/2
		self.offset_auto.y = self.data.height/2
		if self.data.offsetX then self.offset_manual.x = self.data.offsetX end
		if self.data.offsetY then self.offset_manual.y = self.data.offsetY end

		local initBlendMode = love.graphics.getBlendMode()
		self.blendMode = self.data.render
		love.graphics.setBlendMode(self.blendMode)
		love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)

		local dir
		if self.data.fixed_angle then
			dir = math.rad(self.data.rot_angle)
		else
			dir = math.rad(self.moveDir+90+self.data.rot_angle)
		end

		if self.data.animation_data and not self.anim then
			self:initShotAnim()
		end
		if self.anim then
			self.anim:draw(self.image, drawX, drawY, dir, self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
		else
			love.graphics.draw(self.image, self.data.quad, drawX, drawY, dir, self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
		end
		love.graphics.setBlendMode(initBlendMode)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function ObjShot:update(dt)
	if self.isDelete then return end
	self.data = self.definition[self.graphic]
	if self.anim then self.anim:update(dt) end
	self:spellCollision()
	if self.x > 1280+40 or self.y > 960+40 or self.x < -40 or self.y < -40 then
		self:delete()
		return
	end
	if self.delay > 0 then self.delay = self.delay - 1 end
	if self.delay > 0 then self.isDelay = true else self.isDelay = false end
	if self.isDelay == false then
		self.moveDir = self.moveDir + self.angvel * 60 * dt
		if (self.acc > 0 and self.speed < self.maxspeed) or (self.acc < 0 and self.speed > self.maxspeed) then
			self.speed = self.speed + self.acc * 60 * dt
		end
		self.x = self.x + (self.speed * 60 * math.cos(math.rad(self.moveDir)) * dt)
		self.y = self.y + (self.speed * 60 * math.sin(math.rad(self.moveDir)) * dt)
	end
end

function ObjShot:spellCollision()
	for i = 1, #spell_all do
		if spell_all[i].isDelete == false then
			if spell_all[i].eraseShot then
				local obj = spell_all[i].collision
				if obj.type == "circle" then
					if math.dist(obj.x,obj.y,self.x,self.y) < (self.hitbox + obj.radius) then
						self:delete()
					end
				end
				if obj.type == "rectangle" then
						-- local vert1,vert2,vert3,vert4 = getRectVertices(obj[j].startX,obj[j].startY,obj[j].endX,obj[j].endY,obj[j].width)
					if collideCircleWithRotatedRectangle( {x = self.x, y = self.y, radius = self.hitbox} , obj) then
						self:delete()
					end
				end
			end
		end
	end
	-- for i = 1, 2000 do
	-- 	local laser = laser_all[i]
	-- 	if laser.isDelete == false and laser.source == "enemy" then
	-- 		local length = laser.renderLength*laser.spawnScale
	-- 		if collideCircleWithRotatedRectangle({x = self.x, y = self.y, radius = self.hitbox+8},{x = laser.x-length/2*math.cos(math.rad(laser.moveDir)), y = laser.y-length/2*math.sin(math.rad(laser.moveDir)), dir = math.rad(0-laser.moveDir+90), length = length, width = laser.hitboxWidth}) then
	-- 			self:delete()
	-- 		end
	-- 	end
	-- end
end

function ObjShot:delete()
	if self.source == "enemy" then self:bulletBreakEffect() end
	self.isDelete = true
end

function ObjShot:initShotAnim()
	local animation_data = self.data.animation_data
	local grid = anim8.newGrid(animation_data.width, animation_data.height, self.image:getWidth(), self.image:getHeight(), animation_data.left, animation_data.top)
	local frames = grid(unpack(animation_data.frames))
	self.anim = anim8.newAnimation(frames, animation_data.durations)
end

function CreateShotA1(x,y,speed,dir,graphic,delay)
	local index = findDeadBullet()
	local obj = shot_all[index]
	obj:_init(x,y,"enemy")
	-- local obj = ObjShot(x,y,"enemy")
	-- table.insert(shot_all,obj)
	obj.speed = speed
	obj.moveDir = dir
	obj.graphic = graphic
	obj.delay = delay
	return obj
end

function CreateShotA2(x,y,speed,dir,acceleration,maxspeed,graphic,delay)
	local index = findDeadBullet()
	local obj = shot_all[index]
	obj:_init(x,y,"enemy")
	obj.speed = speed
	obj.moveDir = dir
	obj.acceleration = acceleration
	obj.maxspeed = maxspeed
	obj.graphic = graphic
	obj.delay = delay
	return obj
end

function CreatePlayerShotA1(x,y,speed,dir,dmg,pene,graphic)
	local index = findDeadBullet()
	local obj = shot_all[index]
	obj:_init(x,y,"player")
	obj.speed = speed
	obj.moveDir = dir
	obj.graphic = graphic
	obj.damage = dmg
	obj.penetration = pene
	return obj
end

function findDeadBullet()
	local x = 0
	while true do --search table til you find an index that is true.
		x = x + 1
		if shot_all[x].isDelete == true then
			break
		end
	end
	return x
end

function DeleteAllShot()
	for i=1,5000 do
		local shot = shot_all[i]
		if shot:isAlive() and shot.source == "enemy" then shot:delete() end
	end
end
