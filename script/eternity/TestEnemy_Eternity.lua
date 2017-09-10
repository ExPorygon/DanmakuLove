objEnemy = ObjEnemy(640,200,1000,"img/eternity_target.png",0,0,164,212)

function testEnemyEternity()
	objEnemy:startTask(objEnemy.mainTask,objEnemy)
end

function objEnemy.mainTask(self)
	objEnemy:startTask(self.fire,60,90)
	-- objEnemy:startTask(self.fire,10,15)
end

function objEnemy.fire(self,num,w)
	while true do
		local dir = love.math.random(0,360)
		for i = 1, num do
			CreateShotA1(self:getX(),self:getY(),2.5,dir+i*360/num,"arrowhead_gray",10)
		end
		wait(w)
	end
end
