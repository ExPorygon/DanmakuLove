require "class/Move"

ObjSpell = {}
ObjSpell.__index = ObjSpell

setmetatable(ObjSpell, {
	__index = ObjMove,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjSpell:_init(x,y,filepath,initX,initY,width,height)
	ObjMove._init(self,x,y,40,filepath,initX,initY,width,height)

	-- Default Values
	self.type = "spell"
	self.damage = 0
	self.eraseShot = true
	self.collision = {}
	-- self.collision_list = {}

	table.insert(spell_all,self)
end

function ObjSpell:setDamage(damage)
	self.damage = damage
end

function ObjSpell:setEraseShot(erase)
	self.eraseShot = erase
end

function ObjSpell:setCollisionCircle(x,y,radius)
	local collision_circle = { type = "circle", x = x, y = y, radius = radius }
	-- table.insert(self.collision_list,collision_circle)
	self.collision = collision_circle
end

-- function ObjSpell:setCollisionRectByPoint(startX,startY,endX,endY,width)
-- 	local collision_line = { type = "rectangle", startX = x, startY = y, endX = endX, endY = endY, width = width }
-- 	table.insert(self.collision_list,collision_line)
-- end

function ObjSpell:setCollisionRectByDir(x,y,dir,length,width)
	-- local endX = x + length*math.cos(math.rad(dir))
	-- local endY = y + length*math.sin(math.rad(dir))
	-- local collision_line = { type = "rectangle", startX = x, startY = y, endX = endX, endY = endY, width = width }
	local collision_line = { type = "rectangle", x = x, y = y, dir = math.rad(-dir), length = length, width = width }
	-- table.insert(self.collision_list,collision_line)
	self.collision = collision_line
end
