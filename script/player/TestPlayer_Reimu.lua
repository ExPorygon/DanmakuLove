player = ObjPlayer(love.graphics.getWidth()/2,love.graphics.getHeight()-100,"img/Reimu.png")

function testPlayerReimu()
	player:addAnim("idle",nil,'1-8',1)
	player:addAnim("left",'pauseAtEnd','1-8',2)
	player:addAnim("right",'pauseAtEnd','1-8',3)
	player:setAnim("idle")
	-- player:setScaleXY(1.5,1.5)

	player:startTask(player.shot)
	player:startTask(player.renderHitbox1)
	player:startTask(player.renderHitbox2)
end

function player.shot()
	local count = -1
	local id = #player.task
	while true do
		if love.keyboard.isDown("z") and count == -1 and player.shotAllow or count > 2 then
			count = 0
		end
		if count == 2 then
			test_shot(player:getX()-12,player:getY()-5)
			test_shot(player:getX()+12,player:getY()-5)
			count = -1
		end
		if count >= 0 then count = count + 1 end
		wait(player.task[id],1)
	end
end
function player.renderHitbox1()
	player.renderHitbox(1)
end
function player.renderHitbox2()
	player.renderHitbox(-1)
end
function player.renderHitbox(rot)
	local obj = ObjImage(0,0,"img/hitbox.png")
	local id = #player.task
	local count = 0
	local alpha = 0
	local scale = 0
	local focusStart = true

	obj:setDrawPriority(51)


	while true do
		if player.state == "down" then obj:setVisible(false) else obj:setVisible(true) end
		if love.keyboard.isDown("lshift") and focusStart then
			scale = 2
			alpha = 0
			focusStart = false
		end
		if scale > 0.8 then
			scale = scale - 1.2/10
			alpha = alpha + 255/10
			count = count + 4
		end
		if not love.keyboard.isDown("lshift") then
			if scale <= 0.8 and scale > 0 then
				scale = scale - 0.8/10
				alpha = alpha - 255/10
			end
			focusStart = true
		end
		obj:setAngle(count*rot)
		obj:setPosition(player:getX(), player:getY())
		obj:setScaleXY(scale, scale)
		obj:setAlpha(alpha)

		-- if(GetPlayerState==STATE_DOWN||GetPlayerState==STATE_END){ObjRender_SetAlpha(obj, 0);}

		count = count + 3.5;
		wait(player.task[id],1)
	end
end

function test_shot(x,y)
	local obj = CreatePlayerShotA1(x,y,23,270,5,5,"arrowhead_red")
	obj:setScaleXY(1.0,1.0)
end
