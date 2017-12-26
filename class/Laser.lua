require "class/Shot"

ObjLaser = {}
ObjLaser.__index = ObjLaser

setmetatable(ObjLaser, {
	__index = ObjShot,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjLaser:_init(x,y,source)
	ObjShot._init(self,x,y,source)

	-- Default Values
	self.type = "laser"
	self.renderLength = 0
	self.hitboxLength = 0
	self.renderWidth = 0
	self.hitboxWidth = 0
	self.spawnScale = 0
	self.lengthScale = {x=0, y=0}
	self.maxGrazeDelay = 7
	self.grazeDelay = 0

end

function ObjLaser:setGrazeDelay(delay)
	self.maxGrazeDelay = delay
end

function ObjLaser:update(dt)
	if self.isDelete then return end
	if self.grazeDelay > 0 then self.grazeDelay = self.grazeDelay - 1 end
	self.data = self.definition[self.graphic]
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

function ObjLaser:spellCollision()
	for i = 1, #spell_all do
		if spell_all[i].isDelete == false then
			if spell_all[i].eraseShot then
				local obj = spell_all[i].collision
				if obj.type == "circle" then
					if collideCircleWithRotatedRectangle( {x = obj.x, y = obj.y, radius = obj.hitbox} , obj) then
						self:delete()
					end
				end
				if obj.type == "rectangle" then
					if collideRectangleWithRectangle(
					{X1 = self.x-self.hitboxWidth/2*math.cos(self.moveDir),
					Y1 = self.y-self.hitboxWidth/2*math.sin(self.moveDir),
					X2 = self.x-self.hitboxLength*math.cos(self.moveDir)+self.hitboxWidth/2*math.cos(self.moveDir),
					Y2 = self.y-self.hitboxLength*math.sin(self.moveDir)+self.hitboxWidth/2*math.sin(self.moveDir)},
					{X1 = obj.x+obj.length/2*math.cos(obj.dir)-obj.width/2*math.cos(obj.dir),
					Y1 = obj.y+obj.length/2*math.cos(obj.dir)-obj.width/2*math.sin(obj.dir),
					X2 = obj.x-obj.length/2*math.cos(obj.dir)+obj.width/2*math.cos(obj.dir),
					Y2 = obj.y-obj.length/2*math.sin(obj.dir)+obj.width/2*math.sin(obj.dir)}) then
						self:delete()
					end
				end
			end
		end
	end
end

function ObjLaser:draw()
	if self.isDelete or not self.visible then return end

	local drawX,drawY
	if self:checkPriorityRange() then
		drawX, drawY = self.x + system.screen.left, self.y + system.screen.top
	else
		drawX, drawY = self.x, self.y
	end

	self.data = self.definition[self.graphic]
	if self.data == nil then error(self.graphic.." does not exist") end
	if not self.data.render then self.data.render = "alpha" end
	if not self.data.rot_angle then self.data.rot_angle = 0 end

	if self.isDelay then
		local initBlendMode = love.graphics.getBlendMode()
		love.graphics.setBlendMode("add")
		minScaleDelay = 0.45*(self.data.width/16)
		scaleDelay = math.min(minScaleDelay+3.0*(self.delay/75), minScaleDelay+3.0)
		love.graphics.draw(imgDelay, colorDelay[self.data.delay_color], drawX, drawY, 0, scaleDelay, scaleDelay, 32, 32)
		love.graphics.setBlendMode(initBlendMode)
	else
		self.offset_auto.x = self.data.width/2
		self.offset_auto.y = 0
		if self.data.offsetX then self.offset_manual.x = self.data.offsetX end
		if self.data.offsetY then self.offset_manual.y = self.data.offsetY end
		self.lengthScale.x = self.renderWidth/self.data.width
		self.lengthScale.y = self.renderLength/self.data.height
		if self.spawnScale < 1 then self.spawnScale = self.spawnScale + self.speed/self.renderLength else self.spawnScale = 1 end

		local initBlendMode = love.graphics.getBlendMode()
		love.graphics.setBlendMode(self.blendMode)
		love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)
		love.graphics.draw(self.image, self.data.quad, drawX, drawY, math.rad(self.moveDir+90)+math.rad(self.data.rot_angle), self.lengthScale.x, self.lengthScale.y*self.spawnScale, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
		love.graphics.setBlendMode(initBlendMode)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function CreateLaserA1(x,y,speed,dir,length,width,graphic,delay)
	local index = findDeadLaser()
	local obj = laser_all[index]
	obj:_init(x,y,"enemy")
	obj.speed = speed
	obj.moveDir = dir
	obj.renderLength = length
	obj.hitboxLength = length
	obj.renderWidth = width
	obj.hitboxWidth = width*0.6
	obj.graphic = graphic
	obj.delay = delay
	return obj
end

function findDeadLaser()
	local x = 0
	while true do --search table til you find an index that is true.
		x = x + 1
		if laser_all[x].isDelete == true then
			break
		end
	end
	return x
end
