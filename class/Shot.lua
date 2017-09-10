require "class/Move"
local ShotData = require("ShotDefinition")

ObjShot = {}
ObjShot.__index = ObjShot

local imgDelay = love.graphics.newImage("img/delay.png")
local quadDelay = {}
for i = 0, 7 do
	quadDelay[i+1] = love.graphics.newQuad(0+i*64, 0, 64, 64, imgDelay:getDimensions())
end
local colorDelay = {
	gray = quadDelay[1],
	darkred = quadDelay[2],
	red = quadDelay[2],
	purple = quadDelay[3],
	magenta = quadDelay[3],
	darkblue = quadDelay[4],
	blue = quadDelay[4],
	darkaqua = quadDelay[5],
	aqua = quadDelay[5],
	darkgreen = quadDelay[6],
	green = quadDelay[6],
	darkyellow = quadDelay[7],
 	yellow = quadDelay[7],
	darkorange = quadDelay[8],
	orange = quadDelay[8],
	white = quadDelay[1]
}
local scaleDelay = 0
local minScaleDelay = 0

setmetatable(ObjShot, {
	__index = ObjMove,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

shot_all = {}
for i = 1, 5000 do
	local obj = ObjShot(0,0)
	obj.isDelete = true
	shot_all[i] = obj
	-- table.insert(shot_all,i,obj)
end

function ObjShot:_init(x,y)
	ObjMove._init(self,x,y)

	-- Default Values
	self.type = "shot"
	self.graphic = 1
	self.delay = 0
	self.hitbox = 5
	self.image = ShotData.shot_image
	self.damage = 0
	self.penetration = 0
	self.source = "enemy"
	self:setDrawPriority(50)

end

function ObjShot:setGraphic(graphic)
	self.graphic = graphic
end

function ObjShot:getGraphic()
	return self.graphic
end

function ObjShot:draw()
	if self.isDelete or not self.visible then return end

	if self.delay > 0 then self.isDelay = true else self.isDelay = false end
	self.data = ShotData[self.graphic]

	if self.isDelay then
		love.graphics.setBlendMode("add")
		minScaleDelay = 0.45*(self.data.width/16)
		scaleDelay = math.min(minScaleDelay+3.0*(self.delay/75), minScaleDelay+3.0)
		love.graphics.draw(imgDelay, colorDelay[self.data.delay_color], self.x, self.y, 0, scaleDelay, scaleDelay, 32, 32)
		self.delay = self.delay - 1
		if self.delay <= 0 then self.isDelay = false love.graphics.setBlendMode("alpha") end
	else

		self.offset.x = self.data.width/2
		self.offset.y = self.data.height/2

		local initBlendMode = love.graphics.getBlendMode()
		love.graphics.setBlendMode(self.blendMode)
		love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)
		if self.data.fixed_angle then
			love.graphics.draw(self.image, self.data.quad, self.x, self.y, 0, self.scale.x, self.scale.y, self.offset.x, self.offset.y)
		else
			love.graphics.draw(self.image, self.data.quad, self.x, self.y, math.rad(self.moveDir+90), self.scale.x, self.scale.y, self.offset.x, self.offset.y)
		end
		love.graphics.setBlendMode(initBlendMode)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function ObjShot:update(dt)
	if self.isDelete then return end
	self:spellCollision()
	if self.x > 1280+40 or self.y > 960+40 or self.x < -40 or self.y < -40 then
		self:delete()
		return
	end
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
end

-- function ObjShot:delete()
-- 	self.isDelete = true
-- 	-- self:bulletBreakEffect()
-- end

function ObjShot:bulletBreakEffect()
	objBreak = ObjImage(self.x,self.y,"img/bullet_break.png")
	objBreak:setGrid(64, 64, objBreak.image:getWidth(), objBreak.image:getHeight())
	objBreak:addAnim("break",'pauseAtEnd',0.05,'1-8',1)
	objBreak:setAnim("break")
end

function CreateShotA1(x,y,speed,dir,graphic,delay)
	local index = findDeadBullet()
	local obj = shot_all[index]
	obj:_init(x,y)
	obj.speed = speed
	obj.moveDir = dir
	obj.graphic = graphic
	obj.delay = delay
	return obj
end

function CreatePlayerShotA1(x,y,speed,dir,dmg,pene,graphic)
	local index = findDeadBullet()
	local obj = shot_all[index]
	obj:_init(x,y)
	obj.speed = speed
	obj.moveDir = dir
	obj.graphic = graphic
	obj.damage = dmg
	obj.penetration = pene
	obj.source = "player"
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
		shot_all[i]:delete()
	end
end
