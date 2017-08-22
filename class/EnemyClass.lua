require "class/MoveClass"

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
	self.hitboxToShot = 32
	self.hitboxToPlayer = 24
	self:setDrawPriority(50)
	self.task = {}

end

function ObjEnemy:setLife(life)
	self.life = life
end

function ObjEnemy:getLife()
	return self.life
end

function ObjEnemy:startTask(task)
	local coo = coroutine.create(task)
	table.insert(self.task,coo)
	return coo
end

function ObjEnemy:update(dt)
	if self.isDelete then return end
	ObjMove.update(self,dt)
	self:collision()
	for i = 1, #self.task do
		if coroutine.status(self.task[i]) ~= "dead" then coroutine.resume(self.task[i]) end
 	end
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
				self.life = self.life - shot_all[i].damage
				shot_all[i].penetration = shot_all[i].penetration - 1
				if shot_all[i].penetration <= 0 then
					shot_all[i].isDelete = true
				end
			end
		end
	end
end
