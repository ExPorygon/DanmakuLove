function wait(coo,w)
	for i = 1, w do
		coroutine.yield(coo)
	end
end
