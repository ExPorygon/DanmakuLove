function wait(w)
	for i = 1, w do
		coroutine.yield()
	end
end