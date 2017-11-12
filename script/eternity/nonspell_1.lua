--DanmakuLove[Pattern]
--Title[Nonspell_1]
--Text[Nonspell #1]
--Player[]

local objPattern = ObjAttackPattern(1400,60)
local shot1 = getSoundObject("shot1")

local function fire(self,num,w)
	while true do
		local dir = love.math.random(0,360)
		shot1:play(0.6)
		for i = 1, num do
			CreateShotA1(self.boss:getX(),self.boss:getY(),2.5,dir+i*360/num,"arrowhead_green",10)
		end
		wait(w)
	end
end

function objPattern.start()
	objPattern.boss:setDestAtWeight(system:getCenterX(),200,10,5)
	objPattern:startTask(fire,objPattern,40,60)
	-- objPattern:startTask(self.fire,10,15)
end

function objPattern.finish()
end



return objPattern
