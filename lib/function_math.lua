function math.dist(x1,y1, x2,y2)
	return ((x2-x1)^2+(y2-y1)^2)^0.5
end

function math.distsquare(x1,y1, x2,y2)
	return (x2-x1)^2+(y2-y1)^2
end

function math.clamp(val, min, max)
    return math.max(min, math.min(val, max))
end
