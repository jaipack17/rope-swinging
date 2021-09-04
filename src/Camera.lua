local Camera = {}
Camera.__index = Camera

local xmultiplier = 1.5
local ymultiplier = .05

function Camera.new(back, tarzan)
	local self = setmetatable({
		mover = back,
		tarzan = tarzan,
	}, Camera)
	
	return self
end

function Camera:Adjust()
	self.mover.CanvasPosition += Vector2.new(self.tarzan.velocity.x * xmultiplier, self.tarzan.velocity.y * ymultiplier)
end

return Camera
