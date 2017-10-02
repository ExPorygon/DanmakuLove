require "class/Image"

ObjText = {}
ObjText.__index = ObjText

setmetatable(ObjText, {
	__index = ObjImage,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjText:_init(x,y,priority,name,text,size)
	ObjImage._init(self,x,y,priority)

	--Default Values
	self.type = "text"
	self.fontpath = "font/"..name
	if size then self.size = size else self.size = 12 end
	self.source = love.graphics.newText(love.graphics.newFont(self.fontpath),text)

end

function ObjText:setText(text)
	self.source:set(text)
end

function ObjText:setBMFont(name)
	self.fontpath = "font/"..name..".fnt"
	self.source:setFont(love.graphics.newFont(self.fontpath,self.size))
end

function ObjText:setTTFont(name)
	self.fontpath = "font/"..name..".ttf"
	self.source:setFont(love.graphics.newFont(self.fontpath,self.size))
end

function ObjText:setFontSize(size)
	self.size = size
	self.source:setFont(love.graphics.newFont(self.fontpath,size))
end


function ObjText:draw()
	if self.isDelete or not self.visible then return end
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)
	love.graphics.draw(self.source, self.x, self.y)
	love.graphics.setColor(255, 255, 255, 255)
end
