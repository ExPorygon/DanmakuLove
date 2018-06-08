AnimationData = {}
AnimationData.__index = AnimationData

setmetatable(AnimationData, {
    __index = Component,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function AnimationData:_init(priority,filepath)
    Component._init(self,"animation")

	if filepath then
		self.filepath = filepath
		self.image = love.graphics.newImage(self.filepath)
	end
    self.grid = animator.newGrid(64,96,self.image,0,0,self.image:getWidth(),96)
    self.animation = animator.newAnimation(self.grid:getFrames('1-8',1),4,self.image)
    self.animation:setLooping(true)

	-- Default Values
	self.scale = {}
	self.scale.x = 1
	self.scale.y = 1
	self.rotAngle = 0
	self.offset_auto = {}
	-- self.offset_center = true

	-- if self.quad then
	-- 	self.offset_auto.x = self.rect.width/2
	-- 	self.offset_auto.y = self.rect.height/2
	-- elseif self.image then
	-- 	self.offset_auto.x = self.image:getWidth()/2
	-- 	self.offset_auto.y = self.image:getHeight()/2
	-- end

	self.offset_manual = {x = 0, y = 0}
	self.blendMode = "alpha"
	self.color = {red = 255, green = 255, blue = 255}
	self.alpha = 255
	self.visible = true
	if priority then self.drawPriority = priority else self.drawPriority = 60 end
	-- self:setDrawPriority(self.drawPriority)
end

function AnimationData:getDrawPriority(num)
	return self.drawPriority
end
