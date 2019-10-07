function collideCircleWithRotatedRectangle(circle, rect) -- Ported to Lua from http://www.migapro.com/circle-and-rotated-rectangle-collision-detection/

	local rectCenterX = rect.x
	local rectCenterY = rect.y

	local rectX = rectCenterX - rect.width / 2
	local rectY = rectCenterY - rect.length / 2

	local rectReferenceX = rectX
	local rectReferenceY = rectY

	-- Rotate circle's center point back
	local unrotatedCircleX = math.cos( rect.dir ) * ( circle.x - rectCenterX ) - math.sin( rect.dir ) * ( circle.y - rectCenterY ) + rectCenterX
	local unrotatedCircleY = math.sin( rect.dir ) * ( circle.x - rectCenterX ) + math.cos( rect.dir ) * ( circle.y - rectCenterY ) + rectCenterY

	-- Closest point in the rectangle to the center of circle rotated backwards(unrotated)
	local closestX, closestY

	-- Find the unrotated closest x point from center of unrotated circle
	if unrotatedCircleX < rectReferenceX then
		closestX = rectReferenceX
	elseif unrotatedCircleX > rectReferenceX + rect.width then
		closestX = rectReferenceX + rect.width
	else
		closestX = unrotatedCircleX
	end

	-- Find the unrotated closest y point from center of unrotated circle
	if unrotatedCircleY < rectReferenceY then
		closestY = rectReferenceY
	elseif unrotatedCircleY > rectReferenceY + rect.length then
		closestY = rectReferenceY + rect.length
	else
		closestY = unrotatedCircleY
	end

	-- Determine collision
	local collision = false
	local distance = math.dist( unrotatedCircleX, unrotatedCircleY, closestX, closestY )

	if distance < circle.radius then
		collision = true
	else
		collision = false
	end

	return collision
end

function collideRectangleWithRectangle(rect1, rect2)
	if rect1.X1 < rect2.X2 and rect1.X2 > rect2.X1 and rect1.Y1 < rect2.Y2 and rect1.Y2 > rect2.Y1 then
		return true
	else return false end
end
