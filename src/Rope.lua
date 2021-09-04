local function draw(hyp, origin, thickness, parent, l) 
	local line = l or Instance.new("Frame")
	line.Name = "rope"
	line.AnchorPoint = Vector2.new(.5, .5)
	line.Size = UDim2.new(0, hyp, 0, thickness or 1)
	line.BackgroundColor3 = Color3.new(1,1,1)
	line.BorderSizePixel = 0
	line.Position = UDim2.fromOffset(origin.x, origin.y)
	line.ZIndex = 0
	line.Parent = parent
	
	return line
end

return function (originx, originy, endpointx, endpointy, parent, thickness, l)
	local origin = {
		x = originx,
		y = originy
	}
	
	local endpoint = {
		x = endpointx,
		y = endpointy
	}
	
	local adj = (Vector2.new(endpoint.x, origin.y) - Vector2.new(origin.x, origin.y)).magnitude
	local opp = (Vector2.new(endpoint.x, origin.y) - Vector2.new(endpoint.x, endpoint.y)).magnitude
	local hyp = math.sqrt(adj^2 + opp^2)
	
	local theta = math.deg(math.acos(adj/hyp))
	
	local line = l and draw(hyp, origin, thickness, parent, l) or draw(hyp, origin, thickness, parent)
	
	local pos = line.AbsolutePosition
	local size = line.AbsoluteSize
	
	if (endpoint.x == origin.x and endpoint.y > origin.y) or (endpoint.x == origin.x and endpoint.y <= origin.y) then
		theta = 90 -- y axis
	elseif (endpoint.x < origin.x and endpoint.y == origin.y) or (endpoint.x >= origin.x and endpoint.y == origin.y) then
		theta = 0 -- x axis
	elseif endpoint.x >= origin.x and endpoint.y <= origin.y then
		theta = -theta-- quad 1
	elseif endpoint.x <= origin.x and endpoint.y <= origin.y then
		theta = theta + 180 -- quad 2
	elseif endpoint.x <= origin.x and endpoint.y >= origin.y then
		theta = -theta -- quad 3		
	elseif endpoint.x >= origin.x and endpoint.y >= origin.x then
		theta = math.abs(theta) -- quad 4
	end
	
	local mid = Vector2.new((origin.x + endpoint.x)/2, (origin.y + endpoint.y)/2)
		
	line.Position = UDim2.fromOffset(mid.x, mid.y)
	line.Rotation = theta
	
	return line
end
