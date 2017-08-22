objEnemy = ObjEnemy(640,200,1000,"img/eternity.png",0,0,164,212)

function testEnemyEternity()
	objEnemy:startTask(objEnemy.mainTask)
end

function objEnemy.mainTask()
	objEnemy:startTask(objEnemy.fire1)
	objEnemy:startTask(objEnemy.fire2)
end

function objEnemy.fire1()
	testTask(10,15)
end
function objEnemy.fire2()
	testTask(60,90)
end
function testTask(num,w)
	local id = #objEnemy.task
	while true do
		local dir = love.math.random(0,360)
		for i = 0, num-1 do
			CreateShotA1(objEnemy:getX(),objEnemy:getY(),2.5,dir+i*360/num,"arrowhead_gray",10)
		end
		wait(objEnemy.task[id],w)
	end
end
