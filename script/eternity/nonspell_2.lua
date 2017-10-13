local objPattern = ObjAttackPattern(900,60)
local shot2 = system:getSoundObject("shot1")

function objPattern.mainTask(self)
	self.boss:setInvincibility(210)
	wait(150)
	objPattern:startTask(self.fire,50,90)
	objPattern:startTask(self.fire,10,15)
end

function objPattern.fire(self,num,w)
	while true do
		local dir = love.math.random(0,360)
		shot2:play(0.6)
		for i = 1, num do
			CreateShotA1(self.boss:getX(),self.boss:getY(),2.5,dir+i*360/num,"arrowhead_aqua",10)
		end
		wait(w)
	end
end

return objPattern
