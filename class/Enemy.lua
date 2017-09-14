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
	ObjMove._init(self,x,y,filepath,initX,initY,width,height)

	-- Default Values
	self.type = "enemy"
	self.life = life
	self.hitboxToShot = 48
	self.hitboxToPlayer = 36
	self.invincibility = 0
	self:setDrawPriority(50)

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
				-- self.hitcount = self.hitcount + 1
				-- print("Hit Count:"..self.hitcount)
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

local function collideCircleWithRotatedRectangle(circle, rect) --Ported to Lua from http://www.migapro.com/circle-and-rotated-rectangle-collision-detection/

	local rectCenterX = rect.x
	local rectCenterY = rect.y

	local rectX = rectCenterX - rect.width / 2
	local rectY = rectCenterY - rect.length / 2

	local rectReferenceX = rectX
	local rectReferenceY = rectY

	-- Rotate circle's center point back
	local unrotatedCircleX = math.cos( rect.dir ) * ( circle.x - rectCenterX ) - math.sin( rect.dir ) * ( circle.y - rectCenterY ) + rectCenterX
	local unrotatedCircleY = math.sin( rect.dir ) * ( circle.x - rectCenterX ) + math.cos( rect.dir ) * ( circle.y - rectCenterY ) + rectCenterY

	-- Closest point in the rectangle to the center of circle rotated backwards(unrotated)
	local closestX, closestY

	-- Find the unrotated closest x point from center of unrotated circle
	if unrotatedCircleX < rectReferenceX then
		closestX = rectReferenceX
	elseif unrotatedCircleX > rectReferenceX + rect.width then
		closestX = rectReferenceX + rect.width
	else
		closestX = unrotatedCircleX
	end

	-- Find the unrotated closest y point from center of unrotated circle
	if unrotatedCircleY < rectReferenceY then
		closestY = rectReferenceY
	elseif unrotatedCircleY > rectReferenceY + rect.length then
		closestY = rectReferenceY + rect.length
	else
		closestY = unrotatedCircleY
	end

	-- Determine collision
	local collision = false
	local distance = math.dist( unrotatedCircleX, unrotatedCircleY, closestX, closestY )

	if distance < circle.radius then
		collision = true
	else
		collision = false
	end

	return collision
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