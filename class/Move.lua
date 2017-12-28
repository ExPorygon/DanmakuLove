require "class/Image"

ObjMove = {}
ObjMove.__index = ObjMove

setmetatable(ObjMove, {
	__index = ObjImage,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjMove:_init(x,y,priority,filepath,initX,initY,width,height)
	ObjImage._init(self,x,y,priority,filepath,initX,initY,width,height)

	-- Default Values
	self.type = "move"
	self.speed = 0
	self.moveDir = 0
	self.acc = 0
	self.maxspeed = 0
	self.angvel = 0
	self.isMoving = false
	self.destX = 0
	self.destY = 0
end

function ObjMove:setDestAtWeight(x,y,weight,max_speed)
	if x == self.x and y == self.y then return end
	local function move(obj,x,y,weight,max_speed)
		local distance = math.dist(self.x,self.y,x,y)
		local angle = AngleBetweenPoints(self.x,self.y,x,y)
		while distance > 1 do
			local speed = distance/weight
			if speed > max_speed then speed = max_speed end
			obj:setX(self.x + math.cos(math.rad(angle))*speed)
			obj:setY(self.y + math.sin(math.rad(angle))*speed)
			distance = math.dist(self.x,self.y,x,y)
			coroutine.yield()
		end
		obj:setPosition(x,y)
	end

	self:startNamedTask(move,"move",self,x,y,weight,max_speed)
end

function ObjMove:setDestAtSpeed(x,y,speed)
	self.destX = x
	self.destY = y
	self.speed = speed
	self.moveDir = AngleBetweenPoints(self.x,self.y,x,y)
	self.acc = 0
	self.angvel = 0
	self.isMoving = true
end

function ObjMove:setSpeed(speed)
	self.speed = speed
end

function ObjMove:setDirection(dir)
	self.moveDir = dir
end

function ObjMove:setAcceleration(acc)
	self.acc = acc
end

function ObjMove:setAngularVelocity(angvel)
	self.angvel = angvel
end

function ObjMove:setMaxSpeed(maxspeed)
	self.maxspeed = maxspeed
end

function ObjMove:getSpeed()
	return self.speed
end

function ObjMove:getSpeedX()
	return self.speed * math.cos(math.rad(self.moveDir))
end

function ObjMove:getSpeedY()
	return self.speed * math.sin(math.rad(self.moveDir))
end

function ObjMove:getDirection()
	return self.moveDir
end

function ObjMove:update(dt)
	if self.isDelete then return end
	self:resumeTask("move")
	self.moveDir = self.moveDir + self.angvel * 60 * dt
	if (self.acc > 0 and self.speed < self.maxspeed) or (self.acc < 0 and self.speed > self.maxspeed) then
		self.speed = self.speed + self.acc * 60 * dt
	end
	self.x = self.x + (self.speed * 60 * math.cos(math.rad(self.moveDir)) * dt)
	self.y = self.y + (self.speed * 60 * math.sin(math.rad(self.moveDir)) * dt)
	if self.isMoving then
		if math.dist(self.x,self.y,self.destX,self.destY) <= self.speed then
			self.x = self.destX
			self.y = self.destY
			self.speed = 0
			self.moveDir = 0
			self.isMoving = false
		end
	end
end

function AngleBetweenPoints(x1, y1, x2, y2) --get angle from (x1, y1) to (x2, y2)
	return math.deg(math.atan2(y2-y1, x2-x1))
end

function AngleBetweenPointsRad(x1, y1, x2, y2) --get angle from (x1, y1) to (x2, y2)
	return math.atan2(y2-y1, x2-x1)
end
