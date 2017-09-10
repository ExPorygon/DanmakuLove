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


function ObjImage:_init(x,y,filepath,initX,initY,width,height)
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
	self.offset = {}
	if self.quad then
		self.offset.x = self.rect.width/2
		self.offset.y = self.rect.height/2
	elseif self.image then
		self.offset.x = self.image:getWidth()/2
		self.offset.y = self.image:getHeight()/2
	end
	self.blendMode = "alpha"
	self.color = {
		red = 255,
		green = 255,
		blue = 255
	}
	self.alpha = 255
	self.visible = true
	self.drawPriority = 60
	self:setDrawPriority(self.drawPriority)
end

function ObjImage:setDrawPriority(num)
	local listIndex = {}
	for i = 1, #listDrawLayer[self.drawPriority] do
		if listDrawLayer[self.drawPriority][i] == self then table.insert(listIndex,i) end
	end
	local offset = 0
	for i = 1, #listIndex do
		table.remove(listDrawLayer[self.drawPriority],listIndex[i]-offset)
		offset = offset + 1
	end
	self.drawPriority = num
	table.insert(listDrawLayer[self.drawPriority],self)
end

function ObjImage:setGrid(frameWidth, frameHeight, imageWidth, imageHeight, left, top, border)
	self.grid = anim8.newGrid(64, 96, self.image:getWidth(), self.image:getHeight())
end

function ObjImage:setAnim(name)
	if self.animCurrent ~= name then
		self.animCurrent = name
		self.animList[name]:gotoFrame(1)
		self.animList[name]:resume()
		self.offset.x, self.offset.y = self.animList[name]:getDimensions()
		self.offset.x = self.offset.x/2
		self.offset.y = self.offset.y/2
	end
end
function ObjImage:addAnim(name,onLoop,duration,...)
	local frames = self.grid(...)
	local animation = anim8.newAnimation(frames, duration, onLoop)
	self.animList[name] = animation
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

function ObjImage:setVisible(bool)
	self.visible = bool
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
	-- print(self.animList["idle"])
	if self.isDelete then return end
	local animCurrent = self.animCurrent
	if animCurrent then self.animList[animCurrent]:update(dt) end
end

function ObjImage:draw()
	if self.isDelete or not self.visible then return end
	local initBlendMode = love.graphics.getBlendMode()
	love.graphics.setBlendMode(self.blendMode)
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)
	if self.quad then
		love.graphics.draw(self.image, self.quad, self.x, self.y, math.rad(self.rotAngle), self.scale.x, self.scale.y, self.offset.x, self.offset.y)
	elseif self.animCurrent then
		local animCurrent = self.animCurrent
		if animCurrent then self.animList[animCurrent]:draw(self.image, self.x, self.y, math.rad(self.rotAngle), self.scale.x, self.scale.y, self.offset.x, self.offset.y) end
	elseif self.image then
		love.graphics.draw(self.image, self.x, self.y, math.rad(self.rotAngle), self.scale.x, self.scale.y, self.offset.x, self.offset.y)
	end
	love.graphics.setBlendMode(initBlendMode)
	love.graphics.setColor(255, 255, 255, 255)
end