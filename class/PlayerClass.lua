require "class/MoveClass"

ObjPlayer = {}
ObjPlayer.__index = ObjPlayer

setmetatable(ObjPlayer, {
	__index = ObjMove,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjPlayer:_init(x,y,filepath,initX,initY,width,height)
	ObjMove._init(self,x,y,filepath,initX,initY,width,height)

	-- Default Values
	self.type = "player"
	self.life = 2
	self.bomb = 2
	self.hitbox = 5
	self.slowSpeed = 1.9
	self.fastSpeed = 6

	self.shotAllow = true
	self.bombAllow = true
	self.invincibility_init = 210
	self.invincibility = 0
	self.deathbomb_frames_init = 15
	self.deathbomb_frames = self.deathbomb_frames_init
	self.death_frames_init = 10
	self.death_frames = self.death_frames_init
	self.respawn_frames_init = 60
	self.respawn_frames = self.respawn_frames_init
	self.state = "normal"

	self.task = {}
	self.hitcount = 0 -- temp
	self:setDrawPriority(41)

end


function ObjPlayer:startTask(task,...)
	local coo = coroutine.create(task)
	coroutine.resume(coo,self,...)
	table.insert(self.task,coo)
	return coo
end

function ObjPlayer:update(dt)
	self:move(dt)
	if self:collision() == true then
		self:startTask(self.explodeEffect)
		self.state = "hit"
		print("hit")
	end

	if self.invincibility > 0 then
		self.invincibility = self.invincibility - 1
	end

	if self.state == "hit" then
		if self.deathbomb_frames > 0 and love.keyboard.isDown("x") then
			self.state = "normal"
			self.deathbomb_frames = self.deathbomb_frames_init
		end
		if self.deathbomb_frames <= 0 then
			self.life = self.life - 1
			self.state = "down"
			self.deathbomb_frames = self.deathbomb_frames_init
		else self.deathbomb_frames = self.deathbomb_frames - 1 end
	end

	if self.state == "down" then
		if self.death_frames <= 0 then
			self.state = "respawn"
			self:setAnim("idle")
			self.invincibility = self.invincibility_init
			self.death_frames = self.death_frames_init
		else self.death_frames = self.death_frames - 1 end
	end

	if self.state == "respawn" then
		self.x = love.graphics.getWidth()/2
		self.y = love.graphics.getHeight() - 100 + 140*self.respawn_frames/self.respawn_frames_init
		if self.respawn_frames <= 0 then
			self.state = "normal"
			self.respawn_frames = self.respawn_frames_init
			else self.respawn_frames = self.respawn_frames - 1 end
	end

	if self.state ~= "normal" then self.shotAllow = false else self.shotAllow = true end
	if self.state ~= "normal" and self.state ~= "hit" then self.bombAllow = false else self.bombAllow = true end

	for i = 1, #self.task do
		if coroutine.status(self.task[i]) == "suspended" then coroutine.resume(self.task[i]) end
 	end
end

function ObjPlayer:move(dt)
	ObjImage.update(self,dt)
	if self.state ~= "normal" then return end

	local diag = false
	local Right = love.keyboard.isDown("right")
	local Left = love.keyboard.isDown("left")
	local Down = love.keyboard.isDown("down")
	local Up = love.keyboard.isDown("up")
	local Focus = love.keyboard.isDown("lshift")

	if Focus then self.speed = self.slowSpeed else self.speed = self.fastSpeed end

	if Right and Down and self.x < sWidth and self.y < sHeight then
		self:setAnim("right")
		self.x = self.x + self.speed * math.cos(math.rad(45)) * 100 * dt
		self.y = self.y + self.speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if Right and Up and self.x < sWidth and self.y > 0 then
		self:setAnim("right")
		self.x = self.x + self.speed * math.cos(math.rad(45)) * 100 * dt
		self.y = self.y - self.speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if Left and Down and self.x > 0 and self.y < sHeight then
		self:setAnim("left")
		self.x = self.x - self.speed * math.cos(math.rad(45)) * 100 * dt
		self.y = self.y + self.speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if Left and Up and self.x > 0 and self.y > 0 then
		self:setAnim("left")
		self.x = self.x - self.speed * math.cos(math.rad(45)) * 100 * dt
		self.y = self.y - self.speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if not diag then
		if Right and self.x < sWidth then
			self:setAnim("right")
			self.x = self.x + (self.speed * 100 * dt)
		end
		if Left and self.x > 0 then
			self:setAnim("left")
			self.x = self.x - (self.speed * 100 * dt)
		end

		if Down and self.y < sHeight then
			self.y = self.y + (self.speed * 100 * dt)
		end
		if Up and self.y > 0 then
			self.y = self.y - (self.speed * 100 * dt)
		end
	end

	if not Left and not Right then
		self:setAnim("idle")
	end
end

function ObjPlayer:collision()
	for i = 1, 5000 do
		if shot_all[i].isDelete == false and shot_all[i].source == "enemy" then
			if math.dist(shot_all[i].x,shot_all[i].y,self.x,self.y) < (self.hitbox + 10) then
				shot_all[i]:delete()
				if self.state == "normal" and self.invincibility <= 0 then
					return true
				end
			end
		end
	end
end

function ObjPlayer.explodeEffect()
	local obj = ObjImage(player.x,player.y,"img/explode.png")
	local id = #player.task
	obj:setBlendMode("add")
	obj:setDrawPriority(60)

	local alpha = 150
	local scale = 0
	local maxscale = 4
	for i = 0, 20 do
		scale = maxscale*math.sin(math.rad(90)*i/20)
		alpha = alpha - 150/20
		obj:setColor(255,64,64)
		obj:setAlpha(alpha)
		obj:setScaleXY(scale,scale)
		wait(player.task[id],1)
	end
	obj:delete()
end
function ObjPlayer:draw()
	if self.isDelete or not self.visible or self.state == "down" then return end
	local initBlendMode = love.graphics.getBlendMode()
	love.graphics.setBlendMode(self.blendMode)
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)
	if self.quad then
		love.graphics.draw(self.image, self.quad, self.x, self.y, self.rotAngle, self.scale.x, self.scale.y, self.offset.x, self.offset.y)
	elseif self.animCurrent then
		local animCurrent = self.animCurrent
		if animCurrent then self.animList[animCurrent]:draw(self.image, self.x, self.y, self.rotAngle, self.scale.x, self.scale.y, self.offset.x, self.offset.y) end
	elseif self.image then
		love.graphics.draw(self.image, self.x, self.y, self.rotAngle, self.scale.x, self.scale.y, self.offset.x, self.offset.y)
	end
	love.graphics.setBlendMode(initBlendMode)
	love.graphics.setColor(255, 255, 255, 255)
end