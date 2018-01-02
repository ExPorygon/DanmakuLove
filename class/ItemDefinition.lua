require "class/Base"

ObjItemDefinition = {}
ObjItemDefinition.__index = ObjItemDefinition

setmetatable(ObjItemDefinition, {
	__index = ObjBase,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ObjItemDefinition:_init(image)
	ObjBase._init(self)

	-- Default Values
	self.type = "item_definition"
	self.image = love.graphics.newImage(image)
end

function ObjItemDefinition:setImage(image)
	self.image = love.graphics.newImage(image)
end

function ObjItemDefinition:addData(key,data)
	self[key] = data
	self:addDefaultData(key)
end

function ObjItemDefinition:addDefaultData(key)
	if not self[key].render then self[key].render = "alpha" end
	if not self[key].angular_velocity then self[key].angular_velocity = 0 end
	if not self[key].fixed_angle then self[key].fixed_angle = false end
	if not self[key].offsetX then self[key].offsetX = 0 end
	if not self[key].offsetY then self[key].offsetY = 0 end
	if not self[key].rot_angle then self[key].rot_angle = 0 end
end

function ObjItemDefinition:addDataSet(x,y,num_across,width_item,height_item,width_ind,height_ind,id_list,render,angular_velocity,offsetX,offsetY,rot_angle) --Deprecated and is honestly a huge mess
	for i = 0, num_across-1 do
		self:addData(id_list[i+1], { width = width_item, height = height_item, quad_item = love.graphics.newQuad(x+i*width_item, y, width_item, height_item, self.image:getDimensions()), quad_ind = love.graphics.newQuad(x+i*width_ind, y+height_ind, width_ind, height_ind, self.image:getDimensions()), offsetX = offsetX, offsetY = offsetY, render = render, angular_velocity = angular_velocity, rot_angle = rot_angle })
	end
end
