require "class/ShotDefinition"

local shot_sheet = ObjShotDefinition("img/reimu_player.png")

shot_sheet:addData("amulet_red",{ width = 128, height = 32, quad = love.graphics.newQuad(384, 352, 128, 32, shot_sheet.image:getDimensions()), rot_angle = 270, offsetX = 47})

return shot_sheet
