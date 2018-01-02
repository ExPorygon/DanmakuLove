require "class/ItemDefinition"

local item_sheet = ObjItemDefinition("img/system.png")

item_sheet:addData("DEFAULT_POWER", {
    width = 34, height = 34,
    width_indicator = 34, height_indicator = 30,
    quad = love.graphics.newQuad(0, 0, 34, 34, item_sheet.image:getDimensions()),
    quad_indicator = love.graphics.newQuad(0, 34, 34, 30, item_sheet.image:getDimensions())
})

item_sheet:addData("DEFAULT_POINT", {
    width = 34, height = 34,
    width_indicator = 34, height_indicator = 30,
    quad = love.graphics.newQuad(34, 0, 34, 34, item_sheet.image:getDimensions()),
    quad_indicator = love.graphics.newQuad(34, 34, 34, 30, item_sheet.image:getDimensions())
})

item_sheet:addData("DEFAULT_FULL_POWER", {
    width = 34, height = 34,
    width_indicator = 34, height_indicator = 30,
    quad = love.graphics.newQuad(68, 0, 34, 34, item_sheet.image:getDimensions()),
    quad_indicator = love.graphics.newQuad(68, 34, 34, 30, item_sheet.image:getDimensions())
})

item_sheet:addData("DEFAULT_BOMB_PIECE", {
    width = 72, height = 69,
    width_indicator = 58, height_indicator = 51,
    quad = love.graphics.newQuad(0, 64, 72, 69, item_sheet.image:getDimensions()),
    quad_indicator = love.graphics.newQuad(7, 133, 58, 51, item_sheet.image:getDimensions())
})

item_sheet:addData("DEFAULT_BOMB", {
    width = 72, height = 69,
    width_indicator = 58, height_indicator = 51,
    quad = love.graphics.newQuad(72, 64, 72, 69, item_sheet.image:getDimensions()),
    quad_indicator = love.graphics.newQuad(79, 133, 58, 51, item_sheet.image:getDimensions())
})

item_sheet:addData("DEFAULT_LIFE_PIECE", {
    width = 72, height = 69,
    width_indicator = 58, height_indicator = 51,
    quad = love.graphics.newQuad(144, 68, 69, 63, item_sheet.image:getDimensions()),
    quad_indicator = love.graphics.newQuad(150, 133, 58, 51, item_sheet.image:getDimensions())
})

item_sheet:addData("DEFAULT_LIFE", {
    width = 72, height = 69,
    width_indicator = 58, height_indicator = 51,
    quad = love.graphics.newQuad(213, 68, 69, 63, item_sheet.image:getDimensions()),
    quad_indicator = love.graphics.newQuad(219, 133, 58, 51, item_sheet.image:getDimensions())
})

item_sheet:addData("DEFAULT_DELETE", {
    width = 34, height = 34,
    quad = love.graphics.newQuad(102, 0, 34, 34, item_sheet.image:getDimensions()),
    render = "add"
})

return item_sheet
