--DanmakuLove[Pattern]
--Title[Nonspell_4]
--Text[Item Test]
--Player[]

local objPattern = ObjAttackPattern(1400,60)
local shot1 = getSoundObject("shot1")
local func = {}

function objPattern.start()
	-- objPattern.boss:setDestAtWeight(system:getCenterX(),200,10,5)
	objPattern.boss:setPosition(system:getCenterX(),system:getCenterY()-60)
	objPattern:startTask(func.fire,objPattern)
end

function objPattern.finish()
end

function func.fire(self)
	while true do
		--shot1:play(0.6)
		wait(120)
		for i=1, 20 do
			CreateItemA1(self.boss:getX()+love.math.random(-120,120),self.boss:getY()+love.math.random(-120,120),"power")
		end
	end
end

return objPattern
