--DanmakuLove[Pattern]
--Title[Nonspell_3]
--Text[Laser Test]
--Player[]

local objPattern = ObjAttackPattern(1400,60)
local shot1 = getSoundObject("shot1")
local func = {}

function objPattern.start()
	-- objPattern.boss:setDestAtWeight(system:getCenterX(),200,10,5)
	objPattern.boss:setPosition(system:getCenterX(),system:getCenterY()-60)
	objPattern:startTask(func.fire,objPattern,40,60)
	-- objPattern:startTask(self.fire,10,15)
	-- for i=1,20 do
	-- 	for j=1,20 do
	-- 		CreateShotA1(0+50*i,0+50*j,0,0,"small_red",0)
	-- 	end
	-- end
end

function objPattern.finish()
end

function func.fire(self,num,w)
	--while true do
		local dir = love.math.random(60,120)
		--shot1:play(0.6)
		--for i = 1, num do
			--CreateLaserA1(self.boss:getX(),self.boss:getY(),2.5,dir+i*360/num,"arrowhead_green",10)
			wait(120)
			local obj = CreateLaserA1(self.boss:getX(),self.boss:getY(),2.0,180,200,60,"small_red",0)
	--	end
		wait(120)
		obj:setSpeed(0)
	--end
end

return objPattern
