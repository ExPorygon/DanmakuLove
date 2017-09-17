require "class/Base"

ObjShotDefinition = {}
ObjShotDefinition.__index = ObjShotDefinition

setmetatable(ObjShotDefinition, {
	__index = ObjBase,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})



function ObjShotDefinition:_init(image)
	ObjBase._init(self)

	-- Default Values
	self.type = "shot_definition"
	self.image = love.graphics.newImage(image)
end

function ObjShotDefinition:setImage(image)
	self.image = love.graphics.newImage(image)
end

function ObjShotDefinition:addData(key,data)
	self[key] = data
end

function ObjShotDefinition:addDataSet(num_across,num_down,width,height,shot_list,color_list,render,angular_velocity,fixed_angle,offsetX,offsetY,rot_angle)
	if not render then render = "alpha" end
	if not angular_velocity then angular_velocity = 0 end
	if not fixed_angle then fixed_angle = false end
	if not offsetX then offsetX = 0 end
	if not offsetY then offsetY = 0 end
	for j = 0, num_down-1 do
		for i = 0, num_across-1 do
			self:addData(shot_list[j+1] .."_".. color_list[i+1], { width = width, height = height, quad = love.graphics.newQuad(0+i*width, 0+j*height, width, height, self.image:getDimensions()), delay_color = color_list[i+1], offsetX = offsetX, offsetY = offsetY, render = render, angular_velocity = angular_velocity, fixed_angle = fixed_angle })
		end
	end
end
