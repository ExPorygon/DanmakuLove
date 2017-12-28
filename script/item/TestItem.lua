require "class/ItemDefinition"

local item_list = { "power", "point", "full_power" }
local item_lista = { "bomb_piece", "life_piece", "bomb", "life" }

local item_sheet = ObjItemDefinition("img/system.png")

item_sheet:addDataSet(3,34,34,item_list)

return item_sheet
