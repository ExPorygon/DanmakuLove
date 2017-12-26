local selection = {}

local scriptData = {}
local text = {}
local cursor = {}
local selectIndex = 1
local selectLength = 0

selection.listDrawLayer = initDrawLayers()

function selection:init()
end

function selection:enter()
    selectIndex = 1
    scriptData = generateScriptDataList()
    selectLength = #scriptData
    for i = 1, #scriptData do
        text[i] = ObjText(100,50+40*i,81,"Titillium_SemiBold_HUD.fnt",scriptData[i].Title)
    end
    cursor = ObjText(text[selectIndex]:getX()-60,text[selectIndex]:getY(),81,"Titillium_SemiBold_HUD.fnt","-->")
end

function selection:resume()
    -- scriptData = generateScriptDataList()
    -- selectLength = #scriptData
    -- for i = 1, #text do
    --     text[i]:delete()
    -- end
    -- for i = 1, #scriptData do
    --     text[i] = ObjText(100,50+40*i,81,"Titillium_SemiBold_HUD.fnt",scriptData[i].Title)
    -- end
end

function selection:update(dt)
    cursor:setDestAtWeight(text[selectIndex]:getX()-60,text[selectIndex]:getY(),3,20)
end

function selection:keypressed(key)
    if key == "up" then self.keyUp() end
    if key == "down" then self.keyDown() end
    if key == "z" then
        StateManager.push(states.game,love.filesystem.load(scriptData[selectIndex].FilePath))
    end
end

function selection.keyUp()
    if selectIndex == 1 then selectIndex = selectLength
    else selectIndex = selectIndex - 1 end
end

function selection.keyDown()
    if selectIndex == selectLength then selectIndex = 1
    else selectIndex = selectIndex + 1 end
end

function selection:draw()
    draw_layers(self.listDrawLayer)
    love.graphics.print("Select a script and press Z",100,60)
end

return selection
