require "class/Move"

local ItemData = require "script/item/TestItem"

ObjItem = {}
ObjItem.__index = ObjItem

setmetatable(ObjItem, {
	__index = ObjMove,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function initItemManager()
	item_all = {}
	for i = 1, 5000 do
		local obj = ObjItem(0,0)
		obj.isDelete = true
		item_all[i] = obj
	end
end

function updateAllItems(dt)
	for i = 1, 5000 do
		if item_all[i].isDelete == false then
			item_all[i]:update(dt)
		end
    end
end

function ObjItem:_init(x,y)
	ObjMove._init(self,x,y,49)

	-- Default Values
	self.type = "item"
	self.id = 1
	self.hitbox = 32
	self.score = 0
	self.collect = false
	self.autoCollectEnable = true
	self.defaultScoreRenderEnable = true
	self.definition = ItemData
	if self.definition then self.image = self.definition.image end
	self.autoCollectEnable = true
end

function ObjItem:setHitbox(hitbox)
	self.hitbox = hitbox
end

function ObjItem:setDropSpeed(speed)
	self.dropSpeed = speed
end

function ObjItem:setDefaultRenderScoreEnable(bool)
	self.defaultScoreRenderEnable = bool
end

function ObjItem:setAutoCollectEnable(bool)
	self.autoCollectEnable = bool
end

function ObjItem:setID(id)
	self.id = id
end

function ObjItem:autoCollectLine()
	if self.autoCollectEnable and getPlayer().y < getPlayer().autoCollectLine then
		self.collect = true
	end
end

function ObjItem.renderScoreText(x,y,text,R,G,B)
	local objText = ObjText(x,y,61,"crystalclear.ttf",text,20)
	objText:setAlignment("center")
	objText:setWrapLimit(60)
	objText:setColor(R,G,B)
	objText:setFontSize(20)

	local alpha = 200
	local count = 1

	for i=1,20 do
		objText:setPosition(x+40,y,0)
		objText:setAlpha(alpha)
		y=y-0.6
		coroutine.yield()
	end
	for i=1,10 do
		objText:setPosition(x+40,y,0)
		objText:setAlpha(alpha)
		alpha=alpha-200/10
		y=y-0.6
		coroutine.yield()
	end
	objText:delete()
end

function ObjItem:update(dt)
	if self.isDelete then return end
	ObjMove.update(self,dt)
	self:collision()
	self:autoCollectLine()
	self:resumeAllTasks()
end

function ObjItem.initPattern(self,pattern)
	if pattern == "STANDARD_A1" then
		self:setSpeed(-2.5)
		self:setDirection(90)
		self:setAcceleration(0.05)
		self:setMaxSpeed(self.dropSpeed or 2.5)
		local angle = 0
		for i=1,15 do
			angle = angle + 360/15*5
			self:setAngle(angle)
			coroutine.yield()
		end
	elseif pattern == "STANDARD_B1" then
	elseif pattern == "MOVE_TO_PLAYER" then
		self:setSpeed(15)
		while self:isDeleted() do
			self:setDirection(getAngleToPlayer(self))
			coroutine.yield()
		end
	elseif pattern == nil then error("You must enter a valid pattern string code")
	else error("'"..pattern.."'is not a valid pattern code") end
end

function ObjItem:collision()
	local collectRadius
	if love.keyboard.isDown("lshift") then collectRadius = 140 else collectRadius = 75 end

	if self.collect == false and getDistanceToPlayer(self) <= collectRadius then
		self:setSpeed(10)
		self:setAcceleration(2)
		self:setMaxSpeed(15)
		self.collect = true
	end
	if self.collect == true and getDistanceToPlayer(self) <= self.hitbox then
		if self.defaultScoreRenderEnable == true then getSystem():startTask(self.renderScoreText,self.x,self.y,self.score,255,255,255) end
		self:delete()
		--AddScore(self.score)
		--Insert item signaling here maybe
	end
	if self.collect == true then
		self:setDirection(getAngleToPlayer(self))
		self:setSpeed(15)
		if getPlayerState() == "down" then self.collect = false end
	end
end

function ObjItem:initItemAnim()
	local animation_data = self.data.animation_data
	local grid = anim8.newGrid(animation_data.width, animation_data.height, self.image:getWidth(), self.image:getHeight(), animation_data.left, animation_data.top)
	local frames = grid(unpack(animation_data.frames))
	self.anim = anim8.newAnimation(frames, animation_data.durations)
end

function ObjItem:draw()
	if self.isDelete or not self.visible then return end

	local drawX,drawY
	if self:checkPriorityRange() then
		drawX, drawY = self.x + system.screen.left, self.y + system.screen.top
	else
		drawX, drawY = self.x, self.y
	end

	self.data = self.definition[self.id]
	assert(self.data,"Item ID \""..self.id.."\" does not exist")

	self.offset_auto.x = self.data.width/2
	self.offset_auto.y = self.data.height/2
	if self.data.offsetX then self.offset_manual.x = self.data.offsetX end
	if self.data.offsetY then self.offset_manual.y = self.data.offsetY end

	local initBlendMode = love.graphics.getBlendMode()
	self.blendMode = self.data.render
	love.graphics.setBlendMode(self.blendMode)
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)

	if self.data.animation_data and not self.anim then
		self:initItemAnim()
	end
	if self.anim then
		self.anim:draw(self.image, drawX, drawY, dir, self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
	else
		love.graphics.draw(self.image, self.data.quad_item, drawX, drawY, math.rad(self.data.rot_angle+self.rotAngle), self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
	end
	love.graphics.setBlendMode(initBlendMode)
	love.graphics.setColor(255, 255, 255, 255)
end

function CreateItemA1(x,y,id,score)
	local index = findDeadItem()
	local obj = item_all[index]
	obj:_init(x,y)
	obj.id = id
	obj.score = score
	return obj
end

function CreateItemA2(x,y,id,pattern,score)
	local index = findDeadItem()
	local obj = item_all[index]
	obj:_init(x,y)
	obj.id = id
	obj.score = score
	obj.defaultPattern = true
	obj:startNamedTask(obj.initPattern,"__Init_Move_Pattern__",obj,pattern)
	return obj
end

function CreateItemB1(x,y,id,drop_speed,score)
	local index = findDeadItem()
	local obj = item_all[index]
	obj:_init(x,y)
	obj.id = id
	obj.score = score
	obj.dropSpeed = drop_speed
	obj:setSpeed(drop_speed)
	obj:setDirection(90)
	return obj
end

function CreateItemB2(x,y,id,drop_speed,pattern,score)
	local index = findDeadItem()
	local obj = item_all[index]
	obj:_init(x,y)
	obj.id = id
	obj.score = score
	obj.dropSpeed = drop_speed
	obj:startNamedTask(obj.initPattern,"__Init_Move_Pattern__",obj,pattern)
	return obj
end

function findDeadItem()
	local x = 0
	while true do --search table til you find an index that is true.
		x = x + 1
		if item_all[x].isDelete == true then
			break
		end
	end
	return x
end
