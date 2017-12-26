require "class/ShotDefinition"

local color_list1 = { "gray", "darkred", "red", "purple", "magenta", "darkblue", "blue", "darkaqua", "aqua", "darkgreen", "green", "darkyellow", "yellow", "darkorange", "orange", "white" }

local color_list1a = { "gray", "red", "darkred", "pink", "maroon", "magenta", "darkmagenta", "purple", "darkpurple", "blue", "darkblue", "azure", "darkazure", "brightazure", "aqua", "darkaqua", "spring", "darkspring", "green", "darkgreen", "chartreuse", "swampgreen", "brightchartreuse", "yellow", "darkyellow", "brightyellow", "gold", "orange", "darkorange", "lightgray", "black", "white" }

local shot_sheet = ObjShotDefinition("img/shot.png")
shot_sheet:addDataSet(16,3,32,32,{"arrowhead","small_bl","small"},color_list1)
shot_sheet:addData("fire_red", { width = 64, height = 64, delay_color = "red", render = "add", animation_data = { durations = 6/60, frames = {'1-4',1}, width = 64, height = 64, left = 0, top = 96} })

return shot_sheet
