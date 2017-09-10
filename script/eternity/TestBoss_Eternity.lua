objBoss = ObjBoss(640,200,"img/eternity.png",0,0,164,212)

function testBossEternity()
	local nonspell_1 = require "script/eternity/nonspell_1"
	local nonspell_2 = require "script/eternity/nonspell_2"
	objBoss:addEvent(1,nonspell_1)
	objBoss:addEvent(2,nonspell_2)
	objBoss:start()
end
