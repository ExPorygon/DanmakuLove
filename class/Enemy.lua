require "class/Move"

ObjEnemy = {}
ObjEnemy.__index = ObjEnemy

setmetatable(ObjEnemy, {
	__index = ObjMove,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjEnemy:_init(x,y,life,filepath,initX,initY,width,height)
	ObjMove._init(self,x,y,40,filepath,initX,initY,width,height)

	-- Default Values
	self.type = "enemy"
	self.life = life
	self.hitboxToShot = 48
	self.hitboxToPlayer = 36
	self.invincibility = 0

end

function ObjEnemy:setLife(life)
	self.life = life
end

function ObjEnemy:getLife()
	return self.life
end

function ObjEnemy:setHitbox(hitboxToShot,hitboxToPlayer)
 self.hitboxToShot = hitboxToShot
 self.hitboxToPlayer = hitboxToPlayer
end

function ObjEnemy:setHitboxToShot(hitbox)
 self.hitboxToShot = hitbox
end

function ObjEnemy:setHitboxToPlayer(hitbox)
 self.hitboxToPlayer = hitbox
end

function ObjEnemy:setInvincibility(frames)
	self.invincibility = frames
end

function ObjEnemy:update(dt)
	if self.isDelete then return end

	if self.invincibility > 0 then
		self.invincibility = self.invincibility - 1
	end

	ObjMove.update(self,dt)
	self:collision()
	self:resumeAllTasks()
	if self.life <= 0 then
		self.isDelete = true
		self = nil
	end
end

function ObjEnemy:collision()
	for i = 1, 5000 do
		if shot_all[i].isDelete == false and shot_all[i].source == "player" then
			if math.dist(shot_all[i].x,shot_all[i].y,self.x,self.y) < (self.hitboxToShot + 14) then
				if self.invincibility <= 0 then self.life = self.life - shot_all[i].damage end
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
					self.life = self.life - spell_all[i].damage
				end
			end
			if obj.type == "rectangle" then
					-- local vert1,vert2,vert3,vert4 = getRectVertices(obj[j].startX,obj[j].startY,obj[j].endX,obj[j].endY,obj[j].width)
				if collideCircleWithRotatedRectangle( {x = self.x, y = self.y, radius = self.hitboxToShot} , obj) then
					self.life = self.life - spell_all[i].damage
				end
			end
		end
	end
end

local function getRectVertices(startX,startY,endX,endY,width)
	local angle = AngleBetweenPointsRad(startX,startY,endX,endY)
	local x1 = startX + math.cos(angle-90)*width
	local y1 = startY + math.sin(angle-90)*width

	local x2 = startX + math.cos(angle+90)*width
	local y2 = startY + math.sin(angle+90)*width

	local x3 = endX + math.cos(angle-90)*width
	local y3 = endY + math.sin(angle-90)*width

	local x4 = endX + math.cos(angle+90)*width
	local y4 = endY + math.sin(angle+90)*width

	return {x=x1,y=y1},{x=x2,y=y2},{x=x3,y=y3},{x=x4,y=y4}
end
