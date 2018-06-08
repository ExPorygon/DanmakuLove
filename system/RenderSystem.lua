RenderSystem = {}
RenderSystem.__index = RenderSystem

setmetatable(RenderSystem, {
    __index = System,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function RenderSystem:_init(left,top,right,bottom)
    System._init(self,"render",{"position","render"})
    self.screen = {left = left, top = top, right = right, bottom = bottom}
end

function RenderSystem:draw(entity)
	-- if entity.isDelete or not entity.visible then return end

    local render_data = entity:getComponent("render")
    local pos_data = entity:getComponent("position")

    if not render_data.visible then return end

	local drawX,drawY
	-- if self:checkPriorityRange(entity) then
	-- 	drawX, drawY = pos_data.x + self.screen.left, pos_data.y + self.screen.top
	-- else
		drawX, drawY = pos_data.x, pos_data.y
	-- end

	local initBlendMode = love.graphics.getBlendMode()
	love.graphics.setBlendMode(render_data.blendMode)
	love.graphics.setColor(render_data.color.red, render_data.color.green, render_data.color.blue, render_data.alpha)
	if render_data.quad then
		love.graphics.draw(render_data.image, render_data.quad, drawX, drawY, math.rad(render_data.rotAngle), render_data.scale.x, render_data.scale.y, render_data.offset_auto.x+render_data.offset_manual.x, render_data.offset_auto.y+render_data.offset_manual.y)
	elseif self.image then
		love.graphics.draw(self.image, drawX, drawY, math.rad(self.rotAngle), self.scale.x, self.scale.y, self.offset_auto.x+self.offset_manual.x, self.offset_auto.y+self.offset_manual.y)
	end
	love.graphics.setBlendMode(initBlendMode)
	love.graphics.setColor(1, 1, 1, 1)
end

function draw_layers(listDrawLayer)
	for i = 1, 100 do
		local listIndex = {}
		for j = 1, #listDrawLayer[i] do
			if listDrawLayer[i][j].isDelete then
				table.insert(listIndex,j)
			else listDrawLayer[i][j]:draw() end
		end
		local offset = 0
		for j = 1, #listIndex do
			table.remove(listDrawLayer[i],listIndex[j]-offset)
			offset = offset + 1
		end
	end
end

function RenderSystem:checkPriorityRange(entity)
	-- if self.type == "spritebatch" or self.type == "image" then return false end
    local render_data = entity:getComponent("render")
	return render_data:getDrawPriority() > getGameDrawPriorityMin() and render_data:getDrawPriority() < getGameDrawPriorityMax()
end
