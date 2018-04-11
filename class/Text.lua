require "class/Move"

ObjText = {}
ObjText.__index = ObjText

setmetatable(ObjText, {
	__index = ObjMove,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjText:_init(x,y,priority,name,text,size)
	ObjMove._init(self,x,y,priority)

	--Default Values
	self.type = "text"
	self.fontpath = "font/"..name
	if size then self.size = size else self.size = 12 end
	if text then self.text = text else self.text = "" end
	self.alignmode = "left"
	self.wraplimit = 10000
	self.source = love.graphics.newText(love.graphics.newFont(self.fontpath),text)

end

function ObjText:setText(text,wraplimit,alignmode)
	self.text = text
	if not alignmode then alignmode = self.alignmode end
	if not wraplimit then wraplimit = self.wraplimit end
	self.alignmode = alignmode
	self.wraplimit = wraplimit
	self.source:setf(text,wraplimit,alignmode)
end

function ObjText:setAlignment(alignmode)
	self.alignmode = alignmode
	self.source:setf(self.text,self.wraplimit,alignmode)
end

function ObjText:setFont(name,size)
	self.fontpath = "font/"..name
	if size then self.size = size end
	self.source:setFont(love.graphics.newFont(self.fontpath,self.size))
end

function ObjText:setWrapLimit(wraplimit)
	self.wraplimit = wraplimit
	self.source:setf(self.text,wraplimit,self.alignmode)
end

function ObjText:setFontSize(size)
	self.size = size
	self.source:setFont(love.graphics.newFont(self.fontpath,size))
end


function ObjText:draw()
	if self.isDelete or not self.visible then return end
	-- love.graphics.push()
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue, self.alpha)
	-- love.graphics.scale(self.scale.x,self.scale.y)
	love.graphics.draw(self.source, self.x, self.y)
	love.graphics.setColor(1, 1, 1, 1)
	-- love.graphics.pop()
end
