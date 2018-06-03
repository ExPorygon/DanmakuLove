PlayerSystem = {}
PlayerSystem.__index = PlayerSystem

setmetatable(PlayerSystem, {
    __index = System,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function PlayerSystem:_init()
    System._init(self,"player",{"player","position"})
end

function PlayerSystem:update(dt,entity)
    local player = entity:getComponent("player")
    local collision = entity:getComponent("collision")
    local pos_data = entity:getComponent("position")

    if player.state == "normal" and collision.isColliding == true then
		-- player:startNamedTask(player.explodeEffect,"death_explosion",player)
		player.state = "hit"
	end

    if player.invincibility > 0 then
		player.invincibility = player.invincibility - 1
	end

	if player.state == "hit" then
		if player.deathbomb_frames > 0 and love.keyboard.isDown("x") then
			player.state = "normal"
			player.deathbomb_frames = player.deathbomb_frames_init
		end
		if player.deathbomb_frames <= 0 then
			player.life = player.life - 1
			player.state = "down"
			player.deathbomb_frames = player.deathbomb_frames_init
		else player.deathbomb_frames = player.deathbomb_frames - 1 end
	end

	if player.state == "down" then
		if player.death_frames <= 0 then
			player.state = "respawn"
			-- player:setAnim("idle")
			player.invincibility = player.invincibility_init
			player.death_frames = player.death_frames_init
		else player.death_frames = player.death_frames - 1 end
	end

	if player.state == "respawn" then
		-- player.x = system:getCenterX()
        pos_data.x = 600
		-- player.y = system:getScreenHeight() - 100 + 140*player.respawn_frames/player.respawn_frames_init+system.screen.top
        pos_data.y = 900 - 100 + 140*player.respawn_frames/player.respawn_frames_init
		if player.respawn_frames <= 0 then
			player.state = "normal"
			player.respawn_frames = player.respawn_frames_init
        else player.respawn_frames = player.respawn_frames - 1 end
	end
    if player.state == "down" then entity:setVisible(false) else entity:setVisible(true) end
	if player.state ~= "normal" then player.shotAllow = false else player.shotAllow = true end
	if player.state ~= "normal" and player.state ~= "hit" then player.bombAllow = false else player.bombAllow = true end

	-- if love.keyboard.isDown("x") and not player.isBombing and player.state == "normal" and player.spell > 0 then
	-- 	player.spell = player.spell - 1
	-- 	player:startNamedTask(player.bomb,"bomb",player)
	-- 	player.isBombing = true
	-- end
	-- if not isTaskAlive(player.task.bomb) then player.isBombing = false end

	-- player:resumeAllTasks()
    print(player.state)
    print(player.deathbomb_frames)
    print(player.death_frames)
end
