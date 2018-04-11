require "class/Image"

ObjSpriteBatch = {}
ObjSpriteBatch.__index = ObjSpriteBatch

setmetatable(ObjSpriteBatch, {
	__index = ObjImage,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjSpriteBatch:_init(priority,filepath,maxsprites)
	ObjImage._init(self,0,0,priority,filepath)

	-- Default Values
	self.type = "spritebatch"
	self.source = love.graphics.newSpriteBatch(self.image,maxsprites,"dynamic")

end

function ObjSpriteBatch:clear()
	self.source:clear()
end

function ObjSpriteBatch:addQuadSprite(quad,x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
	return self.source:add(quad,x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
end

function ObjSpriteBatch:addSprite(x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
	return self.source:add(x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
end

function ObjSpriteBatch:setSprite(id,x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
	self.source:set(id,x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
end

function ObjSpriteBatch:setQuadSprite(id,quad,x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
	self.source:set(id,quad,x,y,rotAngle,scaleX,scaleY,offsetX,offsetY)
end

function ObjSpriteBatch:draw()
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
	love.graphics.draw(self.source,drawX,drawY) -- Investigate
	love.graphics.setBlendMode(initBlendMode)
	love.graphics.setColor(1, 1, 1, 1)
end
