objBoss = ObjBoss(system:getCenterX(),200,"img/eternity.png",0,0,164,212)
objBoss:setName("Eternity Larva")

function testBossEternity()
	local nonspell_1 = love.filesystem.load("script/eternity/nonspell_1.lua")
	local nonspell_2 = love.filesystem.load("script/eternity/nonspell_2.lua")
	local nonspell_3 = love.filesystem.load("script/eternity/nonspell_1.lua")
	local nonspell_4 = love.filesystem.load("script/eternity/nonspell_2.lua")
	objBoss:addEvent(1,nonspell_1())
	objBoss:addEvent(1,nonspell_2())
	objBoss:addEvent(2,nonspell_3())
	objBoss:addEvent(3,nonspell_4())
	objBoss:start()
end
