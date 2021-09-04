local Tarzan = {}
Tarzan.__index = Tarzan

local ts = game:GetService("TweenService")

local height = workspace.CurrentCamera.ViewportSize.y

local offset = Vector2.new(0, 36)
local rope = require(script.Parent.Rope)

local damp = .98
local xstiffness = .002
local ystiffness = .0016

function Tarzan.new(frame, r)
	local self = setmetatable({
		frame = frame,
		velocity = Vector2.new(0, 0),
		acceleration = Vector2.new(0, 0),
		radius = frame.AbsoluteSize.x/2,
		position = frame.AbsolutePosition,
		size = frame.AbsoluteSize,
		mass = 1,
		rope = r,
		lock = nil,
	}, Tarzan)
	
	return self
end

function Tarzan:ApplyForce(force)
	self.velocity += force/self.mass
end

function Tarzan:Lock(frame)
	self.lock = frame
end

function Tarzan:Swing()
	if not self.lock then return end
	
	local target = self.lock.AbsolutePosition + self.lock.AbsoluteSize/2 + offset
		
	local forceX = (target.x - self.position.x) * xstiffness;
	self.velocity = Vector2.new((self.velocity.x + forceX), self.velocity.y) 
	local forceY = (target.y - self.position.y) * ystiffness;
	self.velocity = Vector2.new(self.velocity.x, (self.velocity.y + forceY))

	self.position += self.velocity
end

function Tarzan:ConnectRope()
	if not self.lock then self.rope.Visible = false return end
	
	self.rope.Visible = true
	
	local bob = self.position
	local target = self.lock.AbsolutePosition + self.lock.AbsoluteSize/2 + offset
	
	rope(bob.x, bob.y, target.x, target.y, script.Parent.Parent.Back, 5, self.rope)
end

function Tarzan:Update()
	self.velocity += self.acceleration
	self.velocity = self.velocity * damp
	self.position += self.velocity
	self.frame.Position = UDim2.new(0, self.position.x, 0, self.position.y)		
	
	if self.position.y + self.radius >= height then
		self.position = Vector2.new(self.position.x, height - self.radius)
		self.velocity = Vector2.new(self.velocity.x, -self.velocity.y)
	end
end

return Tarzan
