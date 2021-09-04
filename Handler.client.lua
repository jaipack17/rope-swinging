local tarzanmodule = require(script.Tarzan)
local camera = require(script.Camera)
local rope = require(script.Rope)
local canvas = script.Parent.Canvas
local back = canvas.Parent.Back

local runservice = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local rep = game:GetService("ReplicatedStorage")

local GRAVITY = Vector2.new(0, .15)
local targets = back.Focus:GetChildren()

local newrope = rope(0, 0, 1, 1, back, 5)
local tarzan = tarzanmodule.new(canvas.Tarzan, newrope)
local cam = camera.new(back.Focus, tarzan)

function debugTargets()
	for _, target in ipairs(targets) do
		target.Position = UDim2.new(0, target.Position.X.Offset, 0, target.Position.Y.Offset + 100)
	end
end

debugTargets()

function move()
	tarzan:ApplyForce(GRAVITY)
	tarzan:Swing()
	tarzan:ConnectRope()
	tarzan:Update()
	cam:Adjust()
end

function lockTarget(input)
	if #targets == 0 then return end
	
	local frame
	local mindist = 150
	local minmag = math.huge
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouse = uis:GetMouseLocation()
		for _, t in ipairs(targets) do
			local center = t.AbsolutePosition + t.AbsoluteSize/2
			local dist = (center - mouse).magnitude
			
			if dist < mindist and dist < minmag then
				minmag = dist
				frame = t
			end
		end
		
		tarzan:Lock(frame)
	end
end

function unlock(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		tarzan:Lock(nil)
	end
end

runservice.RenderStepped:Connect(move)
uis.InputBegan:Connect(lockTarget)
uis.InputEnded:Connect(unlock)
