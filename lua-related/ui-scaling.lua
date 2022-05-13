--[[

	[UI-Scaling]
	
	Script that scales UI basically (perfectly) across all platforms.
	This script took a while due to the "scaleBetween" function which was written in JS.
	https://stackoverflow.com/a/31687097
	
	Theres only really one variable you should worry about, which is ScaledResolutionCap.
	Cause once the ViewportSize hits the MinResolution value, it will cap the scaling.
	Vise versa for MaxResolution.
	
	Wish ROBLOX handled this for us automatically but, guess we are left to do things on our own.
	
	[ScrollingFrames]

	The most problematic UI-Instance, by default it functions well but when it comes to scaling it doesn't go well...
	ROBLOX handles ScrollingFrames terribly where the scrollbar may break and not clamp correctly that or scrolling down may not be enough.
	The best solution to this was by taking advantage of AutomaticCanvasSize, forcing updates by setting CanvasSize.
	(You can read the code for the terribly written code for it down below to see how it works [line 82])
	
	[Conclusion]
	
	UI on ROBLOX is just a nightmare to work with, it never really works out too well due to the loopholes you have to jump.
	This script by no means is something I am proud of cause most of this stuff should be automatically handled for us developers.
	Creating these "fixes" is always a huge annoyance and a complete inconvenience. It would at least help if some of the properties,
	were a little more accurate to the numbers they disabled which would help perfect scaling, through their "automatic" nature.
	However for the many years of people complaining with UI, there just isn't really any improvement done to it.
	
]]--

local CollectionService = game:GetService("CollectionService")
local Camera = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer

local MaxResolution = 1080
local MinResolution = 480
local ScaledResolutionCap = 800

local InstanceTable = {}

local function SetTags()
	for _, Constraint in pairs(Player.PlayerGui:GetDescendants()) do
		if Constraint:FindFirstAncestor("Chat") then
			continue
		end
		if Constraint:IsA("UIScale") then
			CollectionService:AddTag(Constraint, "UISCALETAG")
		elseif Constraint:IsA("ScrollingFrame") then
			CollectionService:AddTag(Constraint, "SCROLLINGFRAME")
		end
		
	end
end

local function GetTags(String)
	return CollectionService:GetTagged(String)
end

function scaleBetween(unscaledNum, minAllowed, maxAllowed, min, max)
	return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
end

local function ScaleFromResolution(Axis)
	return 1 / scaleBetween(Axis, MaxResolution, ScaledResolutionCap, MaxResolution, MinResolution) * Axis
end

SetTags()
Player.PlayerGui.DescendantAdded:Connect(function()
	SetTags()
end)

local function Update()
	local X, Y = Camera.ViewportSize.X, Camera.ViewportSize.Y

	if Y < X then
		for _, UIScale in pairs(GetTags("UISCALETAG")) do
			UIScale.Scale = ScaleFromResolution(Y)
		end
	else
		for _, UIScale in pairs(GetTags("UISCALETAG")) do
			UIScale.Scale = ScaleFromResolution(X)
		end
	end
end

CollectionService:GetInstanceAddedSignal("SCROLLINGFRAME"):Connect(function(ScrollingFrame)
	
	if InstanceTable[ScrollingFrame] then
		return
	end

	InstanceTable[ScrollingFrame] = ScrollingFrame
	
	print(InstanceTable)
	
	for i=1, 2 do
		task.wait()
		ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		local AbsoluteY, AbsoluteX = ScrollingFrame.AbsoluteCanvasSize.Y, ScrollingFrame.AbsoluteCanvasSize.X
		ScrollingFrame.CanvasSize = UDim2.new(0, AbsoluteX, 0, AbsoluteY)
		ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
	end
	

	ScrollingFrame.ChildAdded:Connect(function()
		for i=1, 2 do
			task.wait()
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			local AbsoluteY, AbsoluteX = ScrollingFrame.AbsoluteCanvasSize.Y, ScrollingFrame.AbsoluteCanvasSize.X
			ScrollingFrame.CanvasSize = UDim2.new(0, AbsoluteX, 0, AbsoluteY)
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
		end
	end)
	
	ScrollingFrame.ChildRemoved:Connect(function()
		for i=1, 2 do
			task.wait()
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			local AbsoluteY, AbsoluteX = ScrollingFrame.AbsoluteCanvasSize.Y, ScrollingFrame.AbsoluteCanvasSize.X
			ScrollingFrame.CanvasSize = UDim2.new(0, AbsoluteX, 0, AbsoluteY)
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
		end
	end)
	
end)

game:GetService("RunService").Heartbeat:Connect(function()
	Update()
end)
