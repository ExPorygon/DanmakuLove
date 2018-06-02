RenderData = {}
RenderData.__index = RenderData

setmetatable(RenderData, {
    __index = Component,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function RenderData:_init(priority,filepath,initX,initY,width,height)
    Component._init(self,"render")

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
	-- if self.image then
	-- 	self.animList = {}
		-- self.grid =
	-- end

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
	-- self:setDrawPriority(self.drawPriority)
end

function RenderData:getDrawPriority(num)
	return self.drawPriority
end
