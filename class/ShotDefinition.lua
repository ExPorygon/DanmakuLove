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
	self:addDefaultData(key)
end

function ObjShotDefinition:addDefaultData(key)
	if not self[key].render then self[key].render = "alpha" end
	if not self[key].angular_velocity then self[key].angular_velocity = 0 end
	if not self[key].fixed_angle then self[key].fixed_angle = false end
	if not self[key].offsetX then self[key].offsetX = 0 end
	if not self[key].offsetY then self[key].offsetY = 0 end
	if not self[key].rot_angle then self[key].rot_angle = 0 end
end

function generateAnimaionParams(durations,frames,width,height)
	return { durations = durations, frames = frames, width = width, height = height }
end

function ObjShotDefinition:addDataSet(num_across,num_down,width,height,shot_list,color_list,render,angular_velocity,fixed_angle,offsetX,offsetY,rot_angle)
	for j = 0, num_down-1 do
		for i = 0, num_across-1 do
			self:addData(shot_list[j+1] .."_".. color_list[i+1], { width = width, height = height, quad = love.graphics.newQuad(0+i*width, 0+j*height, width, height, self.image:getDimensions()), delay_color = color_list[i+1], offsetX = offsetX, offsetY = offsetY, render = render, angular_velocity = angular_velocity, fixed_angle = fixed_angle, rot_angle = rot_angle })
		end
	end
end
