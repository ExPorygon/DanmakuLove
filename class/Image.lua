require "class/Base"
local anim8 = require 'lib/anim8'

ObjImage = {}
ObjImage.__index = ObjImage

setmetatable(ObjImage, {
	__index = ObjBase,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})


function ObjImage:_init(x,y,priority,filepath,initX,initY,width,height)
	ObjBase._init(self)
	self.type = "image"
	self.x = x
	self.y = y
	if filepath then
		self.filepath = filepath
		self.image = love.graphics.newImage(self.filepath)
	end
	if initX and initY and width and height then
		self.rect = {
			initX = initX,
			initY = initY,
			width = width,
			height = height
		}
		self.quad = love.graphics.newQuad(self.rect.initX, self.rect.initY, self.rect.width, self.rect.height, self.image:getDimensions())
	end
	if self.image then
		self.animList = {}
		-- self.grid =
	end
	-- Default Values
	self.scale = {}
	self.scale.x = 1
	self.scale.y = 1
	self.rotAngle = 0
	self.offset_auto = {}
	-- self.offset_center = true
	if self.quad then
		self.offset_auto.x = self.rect.width/2
		self.offset_auto.y = self.rect.height/2
	elseif self.image then
		self.offset_auto.x = self.image:getWidth()/2
		self.offset_auto.y = self.image:getHeight()/2
	end
	self.offset_manual = {x = 0, y = 0}
	self.blendMode = "alpha"
	self.color = {red = 255, green = 255, blue = 255}
	self.alpha = 255
	self.visible = true
	if priority then self.drawPriority = priority else self.drawPriority = 60 end
	self:setDrawPriority(self.drawPriority)
end

function ObjImage:checkPriorityRange()
	-- if self.type == "spritebatch" or self.type == "image" then return false end
	return self:getDrawPriority() > getGameDrawPriorityMin() and self:getDrawPriority() < getGameDrawPriorityMax()
end

function ObjImage:setDrawPriority(num)
	local listIndex = {}
	local state = StateManager.current()
	for i = 1, #state.listDrawLayer[self.drawPriority] do
		if state.listDrawLayer[self.drawPriority][i] == self then table.insert(listIndex,i) end
	end
	local offset = 0
	for i = 1, #listIndex do
		table.remove(state.listDrawLayer[self.drawPriority],listIndex[i]-offset)
		offset = offset + 1
	end
	self.drawPriority = num
	table.insert(state.listDrawLayer[self.drawPriority],self)
end

function ObjImage:getDrawPriority(num)
	return self.drawPriority
end

function ObjImage:setGrid(frameWidth, frameHeight, imageWidth, imageHeight)
	self.grid = anim8.newGrid(frameWidth, frameHeight, self.image:getWidth(), self.image:getHeight())
	-- self.offset_center = true
	self.offset_auto.x, self.offset_auto.y = frameWidth, frameHeight
	self.offset_auto.x = self.offset_auto.x/2
	self.offset_auto.y = self.offset_auto.y/2
end
function ObjImage:setAnim(name)
	if self.animCurrent ~= name then
		self.animCurrent = name
		self.animList[name]:gotoFrame(1)
		self.animList[name]:resume()
	end
end
function ObjImage:addAnim(name,onLoop,duration,...)
	local frames = self.grid(...)
	local animation = anim8.newAnimation(frames, duration, onLoop)
	self.animList[name] = animation
end
function ObjImage:getCurrentAnim()
	return self.animCurrent
end
function ObjImage:getAnim(name)
	return self.animList[name]
end

function ObjImage:setAutoOffsetEnable(bool) -- Enabled by default
	-- self.offset_center = bool
	if bool == true then
		if self.quad then
			self.offset_auto.x = self.rect.width/2
			self.offset_auto.y = self.rect.height/2
		elseif self.image then
			self.offset_auto.x = self.image:getWidth()/2
			self.offset_auto.y = self.image:getHeight()/2
		end
	elseif bool == false then
		self.offset_auto.x = 0
		self.offset_auto.y = 0
	end
end

function ObjImage:setX(x)
	self.x = x
end

function ObjImage:setY(y)
	self.y = y
end

function ObjImage:setPosition(x,y)
	self.x = x
	self.y = y
end

function ObjImage:setAngle(angle)
	self.rotAngle = angle
end

function ObjImage:setScaleX(scale)
	self.scale.x = scale
end

function ObjImage:setScaleY(scale)
	self.scale.y = scale
end

function ObjImage:getScaleX(scale)
	return self.scale.x
end

function ObjImage:getScaleY(scale)
	return self.scale.y
end

function ObjImage:setScaleXY(scaleX,scaleY)
	self.scale.x = scaleX
	self.scale.y = scaleY
end

function ObjImage:setWrap(horiz,vert)
	self.image:setWrap(horiz,vert)
end

function ObjImage:setOffsetX(offset)
	self.offset_manual.x = offset
end

function ObjImage:setOffsetY(offset)
	self.offset_manual.y = offset
end

function ObjImage:setOffsetXY(offsetX,offsetY)
	self.offset_manual.x = offsetX
	self.offset_manual.y = offsetY
end

function ObjImage:setVisible(bool)
	self.visible = bool
end

function ObjImage:getVisible()
	return self.visible
end

function ObjImage:setBlendMode(blend)
	self.blendMode = blend
end

function ObjImage:setAlpha(alpha)
	self.alpha = alpha
end

function ObjImage:setColor(red,green,blue)
	self.color.red = red
	self.color.green = green
	self.color.blue = blue
end

function ObjImage:getX()
	return self.x
end

function ObjImage:getY()
	return self.y
end

function ObjImage:getPosition()
	return self.x, self.y
end

function ObjImage:update(dt)
	if self.isDelete then return end
	local animCurrent = self.animCurrent
	if animCurrent then self.animList[animCurrent]:update(dt) end
end

function ObjImage:draw()
	if self.isDelete or not self.visible then return end

	local drawX,drawY
	if self:checkPriorityRange() then
		drawX, drawY = self.x + system.screen.left, self.y + system.screen.top
	else
		drawX, drawY = self.x, self.y
	end

	local initBlendMode = love.graphics.getBlendMode()
	love.graphics.setBlendMode(self.blendMode)
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)
	if self.quad then
		love.graphics.draw(self.image, self.quad, drawX, drawY, math.rad(self.rotAngle), self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
	elseif self.animCurrent then
		local animCurrent = self.animCurrent
		if animCurrent then self.animList[animCurrent]:draw(self.image, drawX, drawY, math.rad(self.rotAngle), self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y) end
	elseif self.image then
		love.graphics.draw(self.image, drawX, drawY, math.rad(self.rotAngle), self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
	end
	love.graphics.setBlendMode(initBlendMode)
	love.graphics.setColor(255, 255, 255, 255)
end
