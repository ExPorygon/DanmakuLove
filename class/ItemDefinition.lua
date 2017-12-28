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

function ObjItemDefinition:addDataSet(num_across,width,height,id_list,render,angular_velocity,offsetX,offsetY,rot_angle)
	for i = 0, num_across-1 do
		self:addData(id_list[i+1], { width = width, height = height, quad_item = love.graphics.newQuad(0+i*width, 0, width, height, self.image:getDimensions()), quad_ind = love.graphics.newQuad(0+i*width, height, width, height, self.image:getDimensions()), offsetX = offsetX, offsetY = offsetY, render = render, angular_velocity = angular_velocity, rot_angle = rot_angle })
	end
end
