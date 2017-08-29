player = ObjPlayer(love.graphics.getWidth()/2,love.graphics.getHeight()-100,"img/Reimu.png")

function testPlayerReimu()
	player:setGrid(64, 96, player.image:getWidth(), player.image:getHeight())
	player:addAnim("idle",nil,0.07,'1-8',1)
	player:addAnim("left",'pauseAtEnd',0.07,'1-8',2)
	player:addAnim("right",'pauseAtEnd',0.07,'1-8',3)
	player:setAnim("idle")
	-- player:setScaleXY(1.5,1.5)

	player:startTask(player.shot)
	player:startNamedTask(player.renderHitbox,"hitbox",1)
	player:startNamedTask(player.renderHitbox,"hitbox_rev",-1)
end

function player.shot(self)
	local count = -1
	while true do
		if love.keyboard.isDown("z") and count == -1 and self.shotAllow or count > 2 then
			count = 0
		end
		if count == 2 then
			test_shot(self:getX()-12,self:getY()-5)
			test_shot(self:getX()+12,self:getY()-5)
			count = -1
		end
		if count >= 0 then count = count + 1 end
		wait(1)
	end
end

function test_shot(x,y)
	local obj = CreatePlayerShotA1(x,y,30,270,5,1,"arrowhead_red")
	obj:setScaleXY(1.0,1.0)
end

function player.bomb(self)
	local task = player:startTask(player.sealBomb,0)
	player:startTask(player.sealBomb,1)
	-- player:startTask(player.sealBomb,-1)

	while isTaskAlive(task) do wait(1) end
	player.isBombing = false
end

function player.sealBomb(self,rot)
	local objSpell = ObjSpell(self.x,self.y,"img/bomb.png")

	local scale = 3.0
	local angle = 0
	local angle_vel = 3
	local angle_acc = 0.04
	local alpha = 0

	objSpell:setDamage(2)
	self:setInvincibility(300)

	for i = 1, 180 do
		if scale > 1.5 then scale = scale - 2.0/90 end
		angle_vel = angle_vel + angle_acc
		angle = angle + rot*angle_vel
		if alpha < 255 then alpha = alpha + 255/30 end
		objSpell:setScaleXY(scale+0.4*rot,scale+0.4*rot)
		objSpell:setAngle(angle)
		objSpell:setAlpha(alpha-100*rot)
		objSpell:setCollisionRectByDir(objSpell:getX(),objSpell:getY(),angle,256*objSpell:getScaleX(),256*objSpell:getScaleY())
		wait(1)
	end
	for i = 1, 45 do
		alpha = alpha - 255/45
		angle = angle + rot*angle_vel
		objSpell:setAngle(angle)
		objSpell:setAlpha(alpha-100*rot)
		objSpell:setCollisionRectByDir(objSpell:getX(),objSpell:getY(),angle,256*objSpell:getScaleX(),256*objSpell:getScaleY())
		wait(1)
	end
	objSpell:delete()
	spell_all = {}
end
