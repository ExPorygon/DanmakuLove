require "class/Move"
require "class/Spell"

ObjPlayer = {}
ObjPlayer.__index = ObjPlayer

spell_all = {}

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
	self.hitbox = 4
	self.slowSpeed = 1.9
	self.fastSpeed = 6

	self.isBombing = false

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

	self:setDrawPriority(41)

end

function ObjPlayer:setInvincibility(iframes)
	self.invincibility = iframes
end

function ObjPlayer:update(dt)
	self:move(dt)
	if self:collision() == true then
		self:startNamedTask(self.explodeEffect,"death_explosion")
		self.state = "hit"
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

	if love.keyboard.isDown("x") and not self.isBombing and self.state == "normal" then
		self:startNamedTask(self.bomb,"bomb")
		self.isBombing = true
	end

	self:resumeAllTasks()
	-- if self.task.death_explosion then coroutine.resume(self.task.death_explosion) end
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
		local shot = shot_all[i]
		if shot.isDelete == false and shot.source == "enemy" then
			if math.dist(shot.x,shot.y,self.x,self.y) < (self.hitbox + shot.hitbox) then
				shot:delete()
				if self.state == "normal" and self.invincibility <= 0 then
					return true
				end
			end
		end
	end
end

function ObjPlayer.explodeEffect(self)
	local obj = ObjImage(self.x,self.y,"img/explode.png")
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
		wait(1)
	end
	obj:delete()
end

function ObjPlayer.renderHitbox(self,rot)
	local obj = ObjImage(0,0,"img/hitbox.png")
	local count = 0
	local alpha = 0
	local scale = 0
	local focusStart = true

	obj:setDrawPriority(51)

	while true do
		if self.state == "down" then obj:setVisible(false) else obj:setVisible(true) end
		if love.keyboard.isDown("lshift") and focusStart then
			scale = 2
			alpha = 0
			focusStart = false
		end
		if scale > 0.8 then
			scale = scale - 1.2/10
			alpha = alpha + 255/10
			count = count + 4
		end
		if not love.keyboard.isDown("lshift") then
			if scale <= 0.8 and scale > 0 then
				scale = scale - 0.8/10
				alpha = alpha - 255/10
			end
			focusStart = true
		end
		obj:setAngle(count*rot)
		obj:setPosition(self:getX(), self:getY())
		obj:setScaleXY(scale, scale)
		obj:setAlpha(alpha)

		count = count + 3.5;
		wait(1)
	end
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