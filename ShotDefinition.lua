local ShotData = {}
ShotData.shot_image = love.graphics.newImage("img/shot.png")

function ShotData.add(id,data)
	ShotData[id] = data
end

local color_list1 = { "gray", "darkred", "red", "purple", "magenta", "darkblue", "blue", "darkaqua", "aqua", "darkgreen", "green", "darkyellow", "yellow", "darkorange", "orange", "white" }
local color_list1a = { "gray", "red", "darkred", "pink", "maroon", "magenta", "darkmagenta", "purple", "darkpurple", "blue", "darkblue", "azure", "darkazure", "brightazure", "aqua", "darkaqua", "spring", "darkspring", "green", "darkgreen", "chartreuse", "swampgreen", "brightchartreuse", "yellow", "darkyellow", "brightyellow", "gold", "orange", "darkorange", "lightgray", "black", "white" }

local shot_list = { "arrowhead", "small", "small_bl" }

local width = 32
local height = 32
local id = 1
for j = 0, 2 do
	for i = 0, 15 do
		ShotData.add(shot_list[j+1] .."_".. color_list1[i+1], { width = width, height = height, quad = love.graphics.newQuad(0+i*width, 0+j*height, width, height, ShotData.shot_image:getDimensions()), delay_color = color_list1[i+1], render = "alpha", angular_velocity = 0, fixed_angle = false })
	end
end

return ShotData
