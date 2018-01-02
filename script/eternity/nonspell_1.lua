--DanmakuLove[Pattern]
--Title[Nonspell_1]
--Text[Nonspell #1]
--Player[]

local objPattern = ObjAttackPattern(1400,60)
local shot1 = getSoundObject("shot1")
local func = {}

function objPattern.start()
	objPattern.boss:setDestAtWeight(system:getCenterX(),200,10,5)
	objPattern:startTask(func.fire,objPattern,40,60)
	-- objPattern:startTask(self.fire,10,15)
end

function objPattern.finish()
	for i=1,20 do
		CreateItemA1(objPattern.boss.x+love.math.random(-90,90),objPattern.boss.y+love.math.random(-90,90),"DEFAULT_POINT",1000)
	end
end

function func.fire(self,num,w)
	while true do
		local dir = love.math.random(0,360)
		shot1:play(0.6)
		for i = 1, num do
			CreateShotA1(self.boss:getX(),self.boss:getY(),2.5,dir+i*360/num,"fire_red",10)
		end
		wait(w)
	end
end

return objPattern
