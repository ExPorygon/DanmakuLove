function update_objects(list,dt)
	for i = 1, 5000 do
		if list[i].isDelete == false then
			list[i]:update(dt)
		end
    end
end
function draw_objects(list)
	for i = 1, 5000 do
		if list[i].isDelete == false then
			list[i]:draw()
		end
	end
end
