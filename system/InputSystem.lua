InputSystem = {}
InputSystem.__index = InputSystem

setmetatable(InputSystem, {
    __index = System,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function InputSystem:_init()
    System._init(self,"input",{"input","position"})
end

function InputSystem:update(dt,entity)
    -- if self.state ~= "normal" then return end

    local pos_data = entity:getComponent("position")

	local diag = false
	local Right = love.keyboard.isDown("right")
	local Left = love.keyboard.isDown("left")
	local Down = love.keyboard.isDown("down")
	local Up = love.keyboard.isDown("up")
	local Focus = love.keyboard.isDown("lshift")

	-- local screen = {left = 10, top = 10, right = system.screen.right - system.screen.left - 10, bottom = system.screen.bottom - system.screen.top - 10}
    local screen = {left = 10, top = 10, right = 1280 - 10, bottom = 720 - 10}

    local speed
	if Focus then speed = 2 else speed = 6 end

	if Right and Down and pos_data.x < screen.right and pos_data.y < screen.bottom then
		-- pos_data:setAnim("right")
		pos_data.x = pos_data.x + speed * math.cos(math.rad(45)) * 100 * dt
		pos_data.y = pos_data.y + speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if Right and Up and pos_data.x < screen.right and pos_data.y > screen.top then
		-- pos_data:setAnim("right")
		pos_data.x = pos_data.x + speed * math.cos(math.rad(45)) * 100 * dt
		pos_data.y = pos_data.y - speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if Left and Down and pos_data.x > screen.left and pos_data.y < screen.bottom then
		-- pos_data:setAnim("left")
		pos_data.x = pos_data.x - speed * math.cos(math.rad(45)) * 100 * dt
		pos_data.y = pos_data.y + speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if Left and Up and pos_data.x > screen.left and pos_data.y > screen.top then
		-- pos_data:setAnim("left")
		pos_data.x = pos_data.x - speed * math.cos(math.rad(45)) * 100 * dt
		pos_data.y = pos_data.y - speed * math.sin(math.rad(45)) * 100 * dt
		diag = true
	end

	if not diag then
		if Right and pos_data.x < screen.right then
			-- pos_data:setAnim("right")
			pos_data.x = pos_data.x + (speed * 100 * dt)
		end
		if Left and pos_data.x > screen.left then
			-- pos_data:setAnim("left")
			pos_data.x = pos_data.x - (speed * 100 * dt)
		end

		if Down and pos_data.y < screen.bottom then
			pos_data.y = pos_data.y + (speed * 100 * dt)
		end
		if Up and pos_data.y > screen.top then
			pos_data.y = pos_data.y - (speed * 100 * dt)
		end
	end

	-- if not Left and not Right then
	-- 	pos_data:setAnim("idle")
	-- end
end