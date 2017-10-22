local objPattern = ObjAttackPattern(1400,60)
local shot1 = system:getSoundObject("shot1")

function objPattern.mainTask(self)
	objPattern:startTask(self.fire,self,40,60)
	-- objPattern:startTask(self.fire,10,15)
end

function objPattern.fire(self,num,w)
	while true do
		local dir = love.math.random(0,360)
		shot1:play(0.6)
		for i = 1, num do
			CreateShotA1(self.boss:getX(),self.boss:getY(),2.5,dir+i*360/num,"arrowhead_green",10)
		end
		wait(w)
	end
end

return objPattern
