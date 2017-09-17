local objPattern = ObjAttackPattern(500,60)

function objPattern.mainTask(self)
	objPattern:startTask(self.fire,40,60)
	-- objPattern:startTask(self.fire,10,15)
end

function objPattern.fire(self,num,w)
	while true do
		local dir = love.math.random(0,360)
		for i = 1, num do
			CreateShotA1(self.boss:getX(),self.boss:getY(),2.5,dir+i*360/num,"arrowhead_green",10)
		end
		wait(w)
	end
end

return objPattern
