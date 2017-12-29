require "class/ItemDefinition"

local item_list = { "power", "point", "full_power"}
local item_lista = { "bomb_piece", "life_piece", "bomb", "life" }

local item_sheet = ObjItemDefinition("img/system.png")

item_sheet:addDataSet(3,34,34,item_list)
item_sheet:addData("delete", { width = 34, height = 34, quad_item = love.graphics.newQuad(102, 0, 34, 34, item_sheet.image:getDimensions()), render = "add" })

return item_sheet
