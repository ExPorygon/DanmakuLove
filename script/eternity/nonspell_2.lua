--DanmakuLove[Pattern]
--Title[Nonspell_2]
--Text[Nonspell #2]
--Player[]

local objPattern = ObjAttackPattern(900,60)
local shot2 = getSoundObject("shot1")
local func = {}

function objPattern.start()
	objPattern.boss:setDestAtWeight(system:getCenterX(),200,10,5)
	objPattern.boss:setInvincibility(210)
	objPattern:cutIn("TABLE","img/eternity_cut.png")
	objPattern:startSpell(3000000)
	wait(120)
	objPattern:startTask(func.fire,objPattern,50,90)
	objPattern:startTask(func.fire,objPattern,10,15)
	objPattern:startTask(func.move,objPattern)
end

function func.fire(self,num,w)
	while true do
		local dir = love.math.random(0,360)
		shot2:play(0.6)
		for i = 1, num do
			CreateShotA1(self.boss:getX(),self.boss:getY(),2.5,dir+i*360/num,"arrowhead_aqua",10)
		end
		wait(w)
	end
end

function func.move(self)
	while true do
		self.boss:setDestAtWeight(self.boss:getX()+200,self.boss:getY()+50,10,5)
		wait(180)
		self.boss:setDestAtWeight(self.boss:getX()-400,self.boss:getY(),10,5)
		wait(180)
		self.boss:setDestAtWeight(self.boss:getX()+200,self.boss:getY()-50,10,5)
		wait(180)
	end
end

return objPattern
